@echo off
setlocal EnableDelayedExpansion

set "ROOT_DIR=%~dp0.."
cd /d "%ROOT_DIR%"

echo ============================================
echo   Claude Code - Recovery Mode
echo ============================================
echo.

bun --env-file=.env ./src/localRecoveryCli.ts %*
