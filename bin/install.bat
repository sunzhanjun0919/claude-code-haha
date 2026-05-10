@echo off
setlocal EnableDelayedExpansion

set "INSTALL_DIR=%~dp0"
cd /d "%INSTALL_DIR%"

echo ============================================
echo   Claude Code for Windows - Installer
echo ============================================
echo.

where bun >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [INFO] Bun not found. Installing Bun...
    powershell -ExecutionPolicy Bypass -Command "irm bun.sh/install.ps1 | iex"
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Failed to install Bun. Please install manually from https://bun.sh
        pause
        exit /b 1
    )
)

echo [OK] Bun is installed
echo.

echo [INFO] Installing dependencies...
bun install
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo [OK] Installation complete!
echo.
echo To run Claude Code:
echo   bin\claude-haha.bat
echo.
echo Or add to PATH:
echo   set PATH=%cd%\bin;%PATH%
echo.
pause
