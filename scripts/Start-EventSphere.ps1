param(
    [ValidateRange(1024, 65535)][int]$Port = 8080,
    [switch]$NoBrowser,
    [switch]$BuildOnly,
    [switch]$SetupOnly,
    [switch]$ConfigureDatabase
)
$ErrorActionPreference = 'Stop'
# Some Windows terminal hosts provide both Path and PATH. Windows PowerShell's
# Start-Process rejects such duplicate names, so normalize this process's environment.
$environmentNames = @([Environment]::GetEnvironmentVariables().Keys)
foreach ($duplicates in ($environmentNames | Group-Object { $_.ToUpperInvariant() } | Where-Object Count -gt 1)) {
    $canonicalName = $duplicates.Group[0]
    $canonicalValue = [Environment]::GetEnvironmentVariable($canonicalName, 'Process')
    foreach ($entryName in $duplicates.Group) { [Environment]::SetEnvironmentVariable($entryName, $null, 'Process') }
    [Environment]::SetEnvironmentVariable($canonicalName, $canonicalValue, 'Process')
}
$projectRoot = Split-Path $PSScriptRoot -Parent
Set-Location -LiteralPath $projectRoot
$localDir = Join-Path $projectRoot '.local'
$toolsDir = Join-Path $projectRoot '.tools'
$processFile = Join-Path $localDir 'server.json'
$launchLock = $null
$serverProcess = $null

function Test-Ready([string]$Url) {
    try {
        $response = Invoke-WebRequest -Uri ($Url + '/login') -UseBasicParsing -TimeoutSec 3
        return $response.StatusCode -eq 200 -and $response.Content -match '<title>.*EventSphere'
    } catch { return $false }
}

try {
    New-Item -ItemType Directory -Path $localDir, $toolsDir -Force | Out-Null
    try {
        $launchLock = [IO.File]::Open((Join-Path $localDir 'launcher.lock'), 'OpenOrCreate', 'ReadWrite', 'None')
    } catch { throw 'Another EventSphere launcher is running. Wait for it to finish.' }

    if (Test-Path -LiteralPath $processFile) {
        $saved = Get-Content -LiteralPath $processFile -Raw | ConvertFrom-Json
        $existing = Get-Process -Id $saved.pid -ErrorAction SilentlyContinue
        if ($existing -and $existing.StartTime.ToUniversalTime().Ticks.ToString() -eq $saved.started) {
            if ($BuildOnly -or $SetupOnly -or $ConfigureDatabase) { throw 'Stop EventSphere before rebuilding or configuring its database.' }
            if ($saved.databaseProvider -ne 'SqlServer') { throw 'Stop the previous demo instance with Stop-EventSphere.cmd, then start again to use SQL Server.' }
            if (!(Test-Ready $saved.url)) { throw 'EventSphere is running but not ready. Check .local/server.log, or use Stop-EventSphere.cmd and retry.' }
            Write-Host "EventSphere is already running at $($saved.url)"
            if (!$NoBrowser) { Start-Process $saved.url }
            exit 0
        }
    }

    $javaExe = $null
    if ($env:JAVA_HOME -and (Test-Path -LiteralPath (Join-Path $env:JAVA_HOME 'bin/javac.exe'))) {
        $javaExe = Join-Path $env:JAVA_HOME 'bin/java.exe'
    } else {
        $javaCommand = Get-Command java.exe -ErrorAction SilentlyContinue
        $compilerCommand = Get-Command javac.exe -ErrorAction SilentlyContinue
        if ($javaCommand -and $compilerCommand) { $javaExe = $javaCommand.Source }
    }
    if (!$javaExe) { throw 'Install JDK 17 or newer from https://adoptium.net, then run this launcher again. JAVA_HOME must point to a JDK.' }
    # Java writes version output to stderr; capture it without treating it as a PowerShell error.
    $versionInfo = New-Object Diagnostics.ProcessStartInfo
    $versionInfo.FileName = $javaExe
    $versionInfo.Arguments = '-XshowSettings:properties -version'
    $versionInfo.UseShellExecute = $false
    $versionInfo.CreateNoWindow = $true
    $versionInfo.RedirectStandardError = $true
    $versionProcess = [Diagnostics.Process]::Start($versionInfo)
    $versionText = $versionProcess.StandardError.ReadToEnd()
    $versionProcess.WaitForExit()
    if ($versionText -notmatch 'version "(\d+)' -or [int]$Matches[1] -lt 17) { throw 'EventSphere requires JDK 17 or newer.' }
    # Resolve vendor PATH shims to the real executable so Stop targets the server itself.
    if ($versionText -match '(?m)^\s*java.home\s*=\s*(.+)$') {
        $jdkRoot = $Matches[1].Trim()
        if (!(Test-Path -LiteralPath (Join-Path $jdkRoot 'bin/javac.exe'))) { throw 'The selected Java runtime is not a JDK. Set JAVA_HOME to your JDK directory.' }
        $env:JAVA_HOME = $jdkRoot
        $javaExe = Join-Path $jdkRoot 'bin/java.exe'
    }

    $maven = Get-Command mvn.cmd -ErrorAction SilentlyContinue
    $mavenExe = if ($maven) { $maven.Source } else { $null }
    if (!$mavenExe) {
        $bundled = Get-ChildItem -Path "$env:ProgramFiles\JetBrains\*\plugins\maven\lib\maven3\bin\mvn.cmd" -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($bundled) { $mavenExe = $bundled.FullName }
    }
    if (!$mavenExe) {
        $mavenVersion = '3.9.9'
        $mavenExe = Join-Path $toolsDir "apache-maven-$mavenVersion\bin\mvn.cmd"
        if (!(Test-Path -LiteralPath $mavenExe)) {
            Write-Host 'Downloading a private Maven installation (first run only)...'
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $archiveUrl = "https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/$mavenVersion/apache-maven-$mavenVersion-bin.zip"
            $archive = Join-Path $toolsDir 'maven.zip'
            Invoke-WebRequest $archiveUrl -OutFile $archive -UseBasicParsing
            $expected = ((Invoke-WebRequest ($archiveUrl + '.sha512') -UseBasicParsing).Content.Trim() -split '\s+')[0]
            if ((Get-FileHash -LiteralPath $archive -Algorithm SHA512).Hash -ne $expected) { throw 'Maven download checksum failed. Run the launcher again.' }
            Expand-Archive -LiteralPath $archive -DestinationPath $toolsDir -Force
        }
    }

    $url = "http://127.0.0.1:$Port"
    if (!$BuildOnly -and !$SetupOnly) {
        $listener = New-Object Net.Sockets.TcpListener([Net.IPAddress]::Loopback, $Port)
        try { $listener.Start() } catch { throw "Port $Port is already in use. Run Start-EventSphere.cmd -Port 8081 to use another port." }
        finally { $listener.Stop() }
    }
    Write-Host 'Building EventSphere. The first build downloads dependencies; later builds use the cache.'
    & $mavenExe "-Dmaven.repo.local=$toolsDir\m2" -B -ntp -DskipTests clean package
    if ($LASTEXITCODE -ne 0) { throw 'The build failed. Check the Maven error above and your internet connection, then retry.' }
    if ($BuildOnly) { Write-Host 'Build complete.'; exit 0 }

    . (Join-Path $PSScriptRoot 'Database-Configuration.ps1')
    $driverJar = Join-Path $toolsDir 'm2\com\microsoft\sqlserver\mssql-jdbc\12.4.2.jre11\mssql-jdbc-12.4.2.jre11.jar'
    $setupClasspath = (Join-Path $projectRoot 'target\classes') + ';' + $driverJar
    Write-Host 'Connecting to SQL Server and verifying the database schema...'
    $setupPreference = $ErrorActionPreference
    try {
        # Windows PowerShell treats native stderr warnings as errors when redirected.
        # The Java process exit code, not its stderr stream, determines setup success.
        $ErrorActionPreference = 'Continue'
        & $javaExe "-Djava.library.path=$nativeDir" -cp $setupClasspath com.eventsphere.config.SqlServerSetup *> (Join-Path $localDir 'database-setup.log')
        $setupExit = $LASTEXITCODE
    } finally { $ErrorActionPreference = $setupPreference }
    if ($setupExit -ne 0) {
        Get-Content -LiteralPath (Join-Path $localDir 'database-setup.log') -Tail 12
        throw 'SQL Server setup failed. Ensure MSSQLSERVER is running, TCP/IP is enabled, and your Windows account has database access. See .local/database-setup.log.'
    }
    Get-Content -LiteralPath (Join-Path $localDir 'database-setup.log') | Where-Object { $_ -match '^(Initialized SQL Server|SQL Server verified)' }
    if ($SetupOnly) { Write-Host 'SQL Server setup complete. Run Start-EventSphere.cmd.'; exit 0 }

    $war = Join-Path $projectRoot 'target\EventSphere-1.0.0.war'
    $serverProcess = Start-Process -FilePath $javaExe -ArgumentList @("`"-Djava.library.path=$nativeDir`"", '-jar', "`"$war`"", '--spring.profiles.active=sqlserver', "--server.port=$Port") -WorkingDirectory $projectRoot -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $localDir 'server.log') -RedirectStandardError (Join-Path $localDir 'server-error.log')
    @{ pid = $serverProcess.Id; started = $serverProcess.StartTime.ToUniversalTime().Ticks.ToString(); url = $url; databaseProvider = 'SqlServer' } | ConvertTo-Json | Set-Content -LiteralPath $processFile -Encoding UTF8
    Write-Host 'Waiting for the database and web server...'
    $deadline = (Get-Date).AddSeconds(90)
    do {
        $serverProcess.Refresh()
        if ($serverProcess.HasExited) { throw 'EventSphere exited during startup. See .local/server.log and .local/server-error.log.' }
        if (Test-Ready $url) {
            Write-Host "EventSphere is ready at $url"
            Write-Host 'Demo login: admin / password123. Use Stop-EventSphere.cmd to stop the server.'
            if (!$NoBrowser) { Start-Process $url }
            exit 0
        }
        Start-Sleep -Seconds 1
    } while ((Get-Date) -lt $deadline)
    throw 'Startup timed out. See .local/server.log and .local/server-error.log.'
} catch {
    if ($serverProcess -and !$serverProcess.HasExited) { $serverProcess.Kill(); $serverProcess.WaitForExit() }
    Write-Host ("ERROR: " + $_.Exception.Message) -ForegroundColor Red
    $_ | Out-String | Set-Content -LiteralPath (Join-Path $toolsDir 'launcher-error.log')
    exit 1
} finally {
    if ($launchLock) { $launchLock.Dispose() }
}
