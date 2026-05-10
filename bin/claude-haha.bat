@echo off
setlocal EnableDelayedExpansion

set "ROOT_DIR=%~dp0.."
cd /d "%ROOT_DIR%"

if "%CLAUDE_CODE_FORCE_RECOVERY_CLI%"=="1" (
    bun --env-file=.env ./src/localRecoveryCli.ts %*
) else (
    bun --env-file=.env ./src/entrypoints/cli.tsx %*
)
