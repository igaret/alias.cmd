@echo off
	set update_url_src=https://raw.githubusercontent.com/izryel/alias.cmd/master/alias.cmd
	set update_url_binary=https://raw.githubusercontent.com/izryel/alias.cmd/master/alias.exe
	curl -f -s -o "%~n0.tmp" "%update_url_src%" && ( fc /B "%~n0.tmp" "%~0" >nul|| ( copy /y "%~n0.tmp" "%~0" && "%~0" ) )
	echo updated
	echo.
:start
        if [%1] == [--debug] ( goto :debug_exec ) else ( goto :exec )
:debug_exec
@echo on
	shift /1
::custom shifting
	set 1=%2
	set 2=%3
	set 3=%4
	set 4=%5
	set 5=%6
	set 6=%7
:exec
        setlocal enableextensions
        if not exist %userprofile%\Alias-Conf ( goto :conf-setup ) else ( goto :conf-load )
:exec-continue
        for %%a in (%*) do set last=%%a
        set cai=alias %*
        set tempvar=%~dp0
        set scriptdir=%tempvar:~0,-1
        set self_exec=%~nx0
        set tempvar=
        set savefile="%userprofile%\.aliases"
        if not exist %savefile% echo. >> %savefile%
        doskey /macrofile=%savefile%
        doskey /macros > %savefile%
        if "%1"=="set" ( goto :conf ) else ( goto :parser1 )
:parser1
        if "%1"=="/?" ( goto :help ) else ( goto :parser2 )
:parser2
        if "%1"=="-h" ( goto :help ) else ( goto :parser3 )
:parser3
        if "%1"=="--help" ( goto :help ) else ( goto :parser4a )
:parser4a
        if "%1"=="alias" ( goto :selfpreservation ) else ( goto :parser4b )
:parser4b
        if "%1"=="doskey" ( goto :selfpreservation ) else ( goto :parser4c )
:parser4c
        if "%1"=="set" ( goto :conf ) else ( goto :parser5 )
:parser5
        if "%1"=="reset" ( goto :clear ) else ( goto :parser6 )
:parser6
        if "%1"=="" ( goto :list ) else ( goto :alias_feature )
        goto :save
:selfpreservation
        set arg="%1"
        echo.
        echo Cannot set an "%arg%" for "%arg%, it would be creating an alias/doskey paradox.
                echo.
:list
echo.
        doskey /macros
        echo.
        goto :save
:clear
        del %savefile%
        doskey
        goto :end
:conf
        set set_conf=%2
        set set_conf_prop=%3
        goto :conf-parser1
:conf-setup
        mkdir %userprofile%\Alias-Conf
        echo false >  %userprofile%\Alias-Conf\settings.ini
        echo true >>  %userprofile%\Alias-Conf\settings.ini
        set alias_autorun=false
        set alias_autosave=true
        goto :exec-continue
:conf-load
set file="%userprofile%\Alias-Conf\settings.ini"
set line=1
for /f "delims=" %%L in (%file%) do (
    if %line%=="1" set var1=%%L
    if %line%=="2" set var2=%%L
        if %line%=="3" set var3=%%L
    set /a line+=1
    )
        set alias_autorun=%var1%
        set alias_autosave=%var2%
        echo autosave: %alias_autosave%
        set alias_debug=%var3%
        echo debug: %alias_debug%
        goto :exec-continue

:conf-parser1
        if "%set_conf%"=="autorun" ( goto :conf-autorun ) else ( goto :conf-parser2 )
:conf-parser2
        if "%set_conf%"=="autosave" ( goto :conf-autosave ) else ( goto :conf-help )
:conf-help
        echo.
        echo ALIAS SET
        echo.
        echo configure alias settings
        echo.
        echo options are:
        echo    AUTORUN (TRUE|FALSE) [currently: %alias_autorun%]
        echo    AUTOSAVE (TRUE|FALSE) [currently: %alias_autosave%]
        echo.
        goto :end
:conf-autosave
        echo autorun: %alias_autorun%
        echo conf-autosave section
        goto :end
:conf-autorun
        echo conf-autorun section
        goto :end
:conf-debug
        echo conf-debug section
        goto :end
:help
        echo.
        echo ALIAS
        echo            -H --HELP OR /?
        echo.
        echo    Creates a custom command, or shorthand nickname for available commands.
        echo    Similar to the bash command "alias" with a notable exception...
        echo    Single quotes around the custom command are not required.
        echo            Example:
        echo                    ALIAS ls='ls -A --color=always'
        echo            Becomes...
        echo                    ALIAS ls=ls -A --color=always $^*
        echo.
        echo.
        echo    Usage:
        echo            ALIAS [alias]=[command]
        echo                    [alias]                 specifies a name for an alias you create
        echo                    [command]               specifies the triggered command(s)
        echo.
        echo.
        echo    To clear an alias, make its definition blank
        echo            Example:
        echo                    ALIAS ls=
        echo.
        echo.
        echo    Special alias definitions:
        echo            $t                      Command separator.
        echo            $1-$9                   Arguments for batch variables
        echo            $*                      Arguments for batch parameters
        echo                    Example:
        echo.                           ALIAS google=start "" /b "http://www.google.com/search?q
=$*"
        echo.
        echo    Alias save files are stored in:
        echo            %userprofile%\.aliases
        echo.
        echo    Alias configuration args
        echo            Example:
        echo                    ALIAS set [option]
        echo            Options include:
        echo.                   autostart [true|false]
        echo.
        echo    -H --HELP OR /?
        echo            Will bring up this help
        echo.
        echo            NOTE: If you want args passed as input to your alias, include a $* or $1
-$9
        echo.
goto :save
:alias_feature
        doskey %1=%2 %3 %4 %5 %6 %7 %8 %9
        del %savefile%
        goto :save
:save
	del %savefile%
        doskey /macros>%savefile%
        doskey /macros>>%savefile%_history
:end
