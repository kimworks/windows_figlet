@echo off
rem ========================================================================
rem figlet.bat
rem 2024-01-08: figlet for windows wrapper
rem KimWorks LLC
rem ========================================================================
set "EXEC=c:\bin\figlet\figlet.exe"
set "FONTDIR=c:\bin\figlet\fonts"

if not exist "%EXEC%" (
    echo Figlet executable not found: %EXEC%
    exit /b 1
)

if not exist "%FONTDIR%" (
    echo Font directory not found: %FONTDIR%
    exit /b 1
)

if "%~1"=="" (
    echo Usage: 
    echo   %0 listfonts             - to list fonts for figlet
    echo   %0 [-f fontname] message - optional fontname is used to print message
    exit /b 1
)

if "%~1"=="listfonts" (    
    setlocal enabledelayedexpansion
    rem echo Files matching *.flf in %FONTDIR%:
    for %%F in (%FONTDIR%\*.flf) do (
        set "filename=%%~nF"
        echo !filename:.flf=!
    )
    endlocal
    exit /b 0
)

set "fontname="
set "cmdline=%EXEC% -d"%FONTDIR%""

rem --- font option, "-f <fontname>" is passed
if /i "%~1"=="-f" (
    goto with_font_option
)
setlocal enabledelayedexpansion
goto setcmdline

:with_font_option
rem --- if -f passed, and at lest 3 args (-f <fontname> <message>) must be passed
setlocal
set "argCount=0"
for %%a in (%*) do (
    set /a "argCount+=1"
)
if %argCount% lss 3 (
    echo ⛔ At least one message must be provided after font name.
    exit /b 1
)
endlocal
set "fontname=%~2"

rem --- remove rest of the argument after "-f <fontname>" to get message args
shift
shift
set "args=%*"
setlocal enabledelayedexpansion
set "args=!args:*%fontname%=!"

:setcmdline
rem --- if fontname is set, add the font parameters
if not "!fontname!"=="" (
    set "cmdline=!cmdline! -f"!fontname!" !args!"
) else (
    set "cmdline=!cmdline! %*"
)

rem --- final command
%cmdline%

endlocal