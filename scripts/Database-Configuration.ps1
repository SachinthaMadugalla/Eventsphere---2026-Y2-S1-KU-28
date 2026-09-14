# Dot-sourced by the launcher after it has resolved Java and created .local/.tools.
$databaseFile = Join-Path $localDir 'database.json'
if (!(Test-Path -LiteralPath $databaseFile)) {
    Copy-Item -LiteralPath (Join-Path $projectRoot 'database.example.json') -Destination $databaseFile
}
$databaseConfig = Get-Content -LiteralPath $databaseFile -Raw | ConvertFrom-Json
if ($ConfigureDatabase) {
    Write-Host 'SQL Server setup. Press Enter to keep the current value.'
    $answer = Read-Host "Server host [$($databaseConfig.Host)]"
    if ($answer) { $databaseConfig.Host = $answer }
    $answer = Read-Host "TCP port [$($databaseConfig.Port)]"
    if ($answer) { $databaseConfig.Port = [int]$answer }
    $answer = Read-Host "Database [$($databaseConfig.Database)]"
    if ($answer) { $databaseConfig.Database = $answer }
    $answer = Read-Host "Authentication: Windows or Sql [$($databaseConfig.Authentication)]"
    if ($answer) { $databaseConfig.Authentication = $answer }
    if ($databaseConfig.Authentication -eq 'Sql') {
        $databaseConfig.Username = Read-Host 'SQL Server login name'
        $password = Read-Host 'SQL Server password (saved encrypted for this Windows account)' -AsSecureString
        $password | Export-Clixml -LiteralPath (Join-Path $localDir 'sql-password.xml')
    }
    $databaseConfig | ConvertTo-Json | Set-Content -LiteralPath $databaseFile -Encoding UTF8
}
if ($databaseConfig.Authentication -notin @('Windows', 'Sql')) { throw 'Authentication must be Windows or Sql in .local/database.json.' }
if ($databaseConfig.Host -notmatch '^[A-Za-z0-9._-]+$') { throw 'Use a server host name or IP address without a named instance suffix; specify its TCP port separately.' }
if ([int]$databaseConfig.Port -lt 1 -or [int]$databaseConfig.Port -gt 65535) { throw 'Invalid SQL Server TCP port.' }
if ($databaseConfig.Database -notmatch '^[A-Za-z][A-Za-z0-9_]{0,127}$') { throw 'Invalid database name.' }

$settings = @{
    DB_HOST = [string]$databaseConfig.Host
    DB_PORT = [string]$databaseConfig.Port
    DB_NAME = [string]$databaseConfig.Database
    DB_INTEGRATED_SECURITY = ($databaseConfig.Authentication -eq 'Windows').ToString().ToLowerInvariant()
    DB_USERNAME = [string]$databaseConfig.Username
    DB_TRUST_SERVER_CERTIFICATE = ([bool]$databaseConfig.TrustServerCertificate).ToString().ToLowerInvariant()
    DB_SEED_DEMO = ([bool]$databaseConfig.SeedDemo).ToString().ToLowerInvariant()
}
foreach ($key in $settings.Keys) {
    if (!$env:EVENTSPHERE_USE_ENV_DATABASE -or $null -eq [Environment]::GetEnvironmentVariable($key, 'Process')) {
        [Environment]::SetEnvironmentVariable($key, $settings[$key], 'Process')
    }
}
if ($env:DB_INTEGRATED_SECURITY -eq 'false' -and !$env:DB_PASSWORD) {
    $passwordFile = Join-Path $localDir 'sql-password.xml'
    if (!(Test-Path -LiteralPath $passwordFile)) { throw 'Run Setup-SQLServer.cmd to save your SQL login, or set DB_PASSWORD in this terminal.' }
    $securePassword = Import-Clixml -LiteralPath $passwordFile
    $credential = New-Object Management.Automation.PSCredential($env:DB_USERNAME, $securePassword)
    $env:DB_PASSWORD = $credential.GetNetworkCredential().Password
}
if ($env:DB_INTEGRATED_SECURITY -eq 'true') { $env:DB_PASSWORD = $null; $env:DB_USERNAME = $null }

$nativeDir = Join-Path $toolsDir 'sqlserver-auth'
if ($env:DB_INTEGRATED_SECURITY -eq 'true') {
    $nativeArch = if ($versionText -match 'sun.arch.data.model\s*=\s*32') { 'x86' } else { 'x64' }
    $nativeName = "mssql-jdbc_auth-12.4.2.$nativeArch.dll"
    $nativeFile = Join-Path $nativeDir $nativeName
    if (!(Test-Path -LiteralPath $nativeFile)) {
        New-Item -ItemType Directory -Path $nativeDir -Force | Out-Null
        Write-Host 'Downloading Microsoft SQL Server Windows-authentication support...'
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $nativeUrl = "https://repo.maven.apache.org/maven2/com/microsoft/sqlserver/mssql-jdbc_auth/12.4.2.$nativeArch/$nativeName"
        $downloadFile = $nativeFile + '.download'
        Invoke-WebRequest $nativeUrl -UseBasicParsing -OutFile $downloadFile
        $checksumResponse = Invoke-WebRequest ($nativeUrl + '.sha256') -UseBasicParsing
        $checksumText = if ($checksumResponse.Content -is [byte[]]) { [Text.Encoding]::ASCII.GetString($checksumResponse.Content) } else { [string]$checksumResponse.Content }
        $expected = ($checksumText.Trim() -split '\s+')[0]
        if ((Get-FileHash -LiteralPath $downloadFile -Algorithm SHA256).Hash -ne $expected) { throw 'Microsoft authentication DLL checksum failed.' }
        Move-Item -LiteralPath $downloadFile -Destination $nativeFile
    }
}
Write-Host "SQL Server: $($env:DB_HOST):$($env:DB_PORT) / $($env:DB_NAME), Windows authentication: $($env:DB_INTEGRATED_SECURITY)"
