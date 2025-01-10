@echo off
setlocal enabledelayedexpansion

rem Save current state of the command prompt.
set "OLDPATH=%PATH%"
set "OLDCD=%CD%"

if EXIST config.cmd (
    call config.cmd
    set "PATH=!PATHLOVE!;%PATH%"

    where /Q love.exe
    if ERRORLEVEL 1 (
        echo Failed to find love.exe in PATH. Please check your config.cmd
        goto EXIT
    )
) else (
    echo Failed to find config.cmd.
    goto EXIT
)

cd src
love %CD% --console

:EXIT
rem Load old state of the command prompt.
set "PATH=%OLDPATH%"
cd %OLDCD%

exit /B