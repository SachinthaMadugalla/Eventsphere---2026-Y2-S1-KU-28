@echo off
setlocal
echo ========================================================
echo  EventSphere - Trigger Stripe Test Payment Event
echo ========================================================
echo.

set "STRIPE_EXE=%LOCALAPPDATA%\Microsoft\WinGet\Packages\Stripe.StripeCli_Microsoft.Winget.Source_8wekyb3d8bbwe\stripe.exe"
if not exist "%STRIPE_EXE%" (
    set "STRIPE_EXE=stripe"
)

for /f "usebackq tokens=*" %%k in (`powershell -NoProfile -Command "if (Test-Path '.local\stripe.json') { (Get-Content '.local\stripe.json' -Raw | ConvertFrom-Json).secretKey }"`) do set "STRIPE_KEY=%%k"
if "%STRIPE_KEY%"=="" set "STRIPE_KEY=%STRIPE_SECRET_KEY%"

if "%STRIPE_KEY%"=="" (
    echo Stripe API key not found in .local\stripe.json or STRIPE_SECRET_KEY env variable.
    echo Please run Start-EventSphere.cmd to configure Stripe.
    pause
    exit /b 1
)

"%STRIPE_EXE%" trigger payment_intent.succeeded --api-key %STRIPE_KEY%
echo.
pause
