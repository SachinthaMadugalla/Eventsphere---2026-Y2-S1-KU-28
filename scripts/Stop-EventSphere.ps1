$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$processFile = Join-Path $projectRoot '.local\server.json'
try {
    if (!(Test-Path -LiteralPath $processFile)) { Write-Host 'EventSphere is not running through the launcher.'; exit 0 }
    $saved = Get-Content -LiteralPath $processFile -Raw | ConvertFrom-Json
    $serverProcess = Get-Process -Id $saved.pid -ErrorAction SilentlyContinue
    # Match both PID and start time so a reused PID never stops an unrelated process.
    if ($serverProcess -and $serverProcess.StartTime.ToUniversalTime().Ticks.ToString() -eq $saved.started) {
        Stop-Process -Id $serverProcess.Id
        $serverProcess.WaitForExit()
        Write-Host 'EventSphere stopped. Your application data remains in SQL Server.'
    } else { Write-Host 'EventSphere is already stopped.' }
    Remove-Item -LiteralPath $processFile
} catch {
    Write-Host ("ERROR: " + $_.Exception.Message) -ForegroundColor Red
    exit 1
}
