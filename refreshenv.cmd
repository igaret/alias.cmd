:bof
@echo off
set /p dummy="getting environment... "
goto init
:setfromreg
    "%windir%\system32\reg" query "%~1" /v "%~2" > "%temp%\_envset.tmp" 2>nul
    for /f "usebackq skip=2 tokens=2,*" %%a in ("%temp%\_envset.tmp") do (
        set %~3=%%b
    )
    goto :eof
:getregenv
    "%windir%\system32\reg" query "%~1" > "%temp%\_envget.tmp"
    for /f "usebackq skip=2" %%a in ("%temp%\_envget.tmp") do (
        if /i not "%%~a"=="path" (
            call :setfromreg "%~1" "%%~a" "%%~a"
        )
    )
    goto :eof
:init
    @echo off >"%temp%\_env.cmd"
    call :getregenv "hklm\system\currentcontrolset\control\session manager\environment" >> "%temp%\_env.cmd"
    call :getregenv "hkcu\environment">>"%temp%\_env.cmd" >> "%temp%\_env.cmd"
    call :setfromreg "hklm\system\currentcontrolset\control\session manager\environment" path path_hklm >> "%temp%\_env.cmd"
    call :setfromreg "hkcu\environment" path path_hkcu >> "%temp%\_env.cmd"
    set path=%%path_hklm%%;%%path_hkcu%% >> "%temp%\_env.cmd"
    del /f /q "%temp%\_envset.tmp" 2>nul
    del /f /q "%temp%\_envget.tmp" 2>nul
    call "%temp%\_env.cmd"
    set /p dummy="done"
    echo .
:eof
