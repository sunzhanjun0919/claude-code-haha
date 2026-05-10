@echo off
setlocal EnableDelayedExpansion

set "BUN_CMD=bun"
where bun >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    set "BUN_PATH=%USERPROFILE%\.bun\bin\bun.exe"
    if exist "!BUN_PATH!" (
        set "BUN_CMD=!BUN_PATH!"
    ) else (
        echo [INFO] Installing Bun...
        powershell -ExecutionPolicy Bypass -Command "irm bun.sh/install.ps1 | iex"
        where bun >nul 2>&1
        if %ERRORLEVEL% NEQ 0 (
            echo [ERROR] Bun installation failed
            pause
            exit /b 1
        )
        set "BUN_CMD=bun"
    )
)

set "ROOT_DIR=%~dp0.."
cd /d "%ROOT_DIR%"
"!BUN_CMD!" --env-file=.env ./src/entrypoints/cli.tsx %*
