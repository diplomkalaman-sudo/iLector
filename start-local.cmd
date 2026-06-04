@echo off
setlocal

cd /d "%~dp0backend"
set PYTHONDONTWRITEBYTECODE=1

python --version >nul 2>&1
if errorlevel 1 (
    echo Python was not found. Install Python and add it to PATH.
    pause
    exit /b 1
)

python -c "import django" >nul 2>&1
if errorlevel 1 (
    echo Django/dependencies are missing. Installing requirements.txt...
    python -m pip install -r requirements.txt
    if errorlevel 1 (
        echo Dependency installation failed.
        pause
        exit /b 1
    )
)

python manage.py migrate --check >nul 2>&1
if errorlevel 1 (
    echo Applying database migrations...
    python manage.py migrate
    if errorlevel 1 (
        echo Migration failed.
        pause
        exit /b 1
    )
)

powershell -NoProfile -Command "if (Get-NetTCPConnection -LocalPort 8000 -State Listen -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }" >nul 2>&1
if not errorlevel 1 (
    echo.
    echo Local server already running: http://127.0.0.1:8000/
    echo Open this URL: http://127.0.0.1:8000/
    echo.
    start "" "http://127.0.0.1:8000/"
    pause
    exit /b 0
)

echo.
echo Local server starting: http://127.0.0.1:8000/
echo Open this URL: http://127.0.0.1:8000/
echo.
start "" cmd /c "timeout /t 2 /nobreak >nul && start "" http://127.0.0.1:8000/"
python manage.py runserver 127.0.0.1:8000

pause
