@echo off
setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "PROJECT_DIR=%SCRIPT_DIR%.."
cd /d "%PROJECT_DIR%"

echo ============================================
echo   Claude Code - Windows Installer & Launcher
echo ============================================
echo.

:BUN_CHECK
where bun >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set "BUN_CMD=bun"
    echo [OK] Bun found: !BUN_CMD!
    goto :INSTALL_DEPS
)

set "BUN_PATH=%USERPROFILE%\.bun\bin\bun.exe"
if exist "!BUN_PATH!" (
    set "BUN_CMD=!BUN_PATH!"
    echo [OK] Bun found: !BUN_CMD!
    goto :INSTALL_DEPS
)

echo [INFO] Bun not found. Installing Bun...
echo.

:BUN_INSTALL
powershell -ExecutionPolicy Bypass -Command "irm bun.sh/install.ps1 | iex"
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Failed to install Bun automatically.
    echo.
    echo Please install Bun manually:
    echo   1. Open PowerShell as Administrator
    echo   2. Run: iwr bun.sh/install.ps1 -useb | iex
    echo.
    echo Or download from: https://bun.sh
    echo.
    pause
    exit /b 1
)

where bun >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    set "BUN_PATH=%USERPROFILE%\.bun\bin\bun.exe"
    if exist "!BUN_PATH!" (
        set "BUN_CMD=!BUN_PATH!"
    ) else (
        echo [ERROR] Bun installation failed.
        pause
        exit /b 1
    )
) else (
    set "BUN_CMD=bun"
)

:INSTALL_DEPS
echo.
echo [INFO] Installing dependencies...
echo.

if exist "package.json" (
    "!BUN_CMD!" install
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo [ERROR] Failed to install dependencies.
        pause
        exit /b 1
    )
)

echo.
echo ============================================
echo   Installation complete!
echo ============================================
echo.
echo Starting Claude Code...
echo.

:LAUNCH
if "%CLAUDE_CODE_FORCE_RECOVERY_CLI%"=="1" (
    "!BUN_CMD!" --env-file=.env ./src/localRecoveryCli.ts %*
) else (
    "!BUN_CMD!" --env-file=.env ./src/entrypoints/cli.tsx %*
)

set "EXIT_CODE=%ERRORLEVEL%"
if %EXIT_CODE% NEQ 0 (
    echo.
    echo [ERROR] Claude Code exited with code %EXIT_CODE%
)

pause
exit /b %EXIT_CODE%
