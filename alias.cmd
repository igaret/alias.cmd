@echo off
	if "%alias_firstrun%"=="complete" ( goto :init ) else ( goto :setup )
:setup
	setx walls "%SystemDrive%\Walls" /m
	if not exist %walls% ( goto :create_walls ) else ( goto :update )
:create_walls
	mkdir %walls%
	setx alias_firstrun "complete" /m
	setx PATH "%PATH%;%walls%" /m
	goto :update
:update
	set alias_vars="%*"
	set update_url_src=https://raw.githubusercontent.com/izryel/alias.cmd/master/aliasd.cmd
	curl %update_url_src% -o %walls%\aliasd.cmd
	goto :cleanup
:start
	if [%1] == [--debug] ( goto :debug_exec ) else ( goto :exec )
:debug_exec
	set arg1=%2
	set arg2=%3
	set arg3=%4
	set arg4=%5
	set arg5=%6
	set arg6=%7
	set arg7=%8
	set arg8=%9
@echo on
	goto :init
:exec
	set arg1=%1
	set arg2=%2
	set arg3=%3
	set arg4=%4
	set arg5=%5
	set arg6=%6
	set arg7=%7
	set arg8=%8
@echo off
:init
	setlocal enableextensions
	set useraliases="%userprofile%\.aliases"
	set useraliases_history="%userprofile%\.aliases_history"
	if not exist %useraliases% echo. > %useraliases%
	doskey /macrofile=%useraliases%
	doskey /macros > %useraliases%
	if "%arg1%"=="set" ( goto :conf ) else ( goto :parser1 )
:parser1
	if "%arg1%"=="/?" ( goto :help ) else ( goto :parser2 )
:parser2
	if "%arg1%"=="-h" ( goto :help ) else ( goto :parser3 )
:parser3
	if "%arg1%"=="--help" ( goto :help ) else ( goto :parser4a )
:parser4a
	if "%arg1%"=="alias" ( goto :selfpreservation ) else ( goto :parser4b )
:parser4b
	if "%arg1%"=="doskey" ( goto :selfpreservation ) else ( goto :parser5a)
:parser5a
	if "%arg1%"=="update" ( goto :update ) else ( goto :parser5b )
:parser5b
	if "%arg1%"=="reset" ( goto :reset ) else ( goto :parser6 )
:parser6
	if "%arg1%"=="" ( goto :list ) else ( goto :init_exec_alias )
	goto :save
:selfpreservation
	set cmd_as_arg="%arg1%"
	echo.
	echo Cannot set an "%cmd_as_arg%" for "%cmd_as_arg%, it would be creating an alias/doskey paradox.
		echo.
:list
echo.
	doskey /macros
	echo.
	goto :save
:reset
	del %useraliases%
	doskey
	goto :cleanup
:help
	echo.
	echo ALIAS
	echo		-H --HELP OR /?
	echo.
	echo	Creates a custom command, or shorthand nickname for available commands.
	echo	Similar to the bash command "alias" with a notable exception...
	echo	Single quotes around the custom command are not required.
	echo		Example:
	echo			ALIAS ls='ls -A --color=always'
	echo		Becomes...
	echo			ALIAS ls=ls -A --color=always $^*
	echo.
	echo.
	echo	Usage:
	echo		ALIAS [alias]=[command]
	echo			[alias]		 specifies a name for an alias you create
	echo			[command]		   specifies the triggered command(s)
	echo.
	echo.
	echo	To clear an alias, make its definition blank
	echo		Example:
	echo			ALIAS ls=
	echo.
	echo.
	echo	Special alias definitions:
	echo		$t			  Command separator.
	echo		$1-$9		   Arguments for batch variables
	echo		$*			  Arguments for batch parameters
	echo			Example:
	echo.			   ALIAS google=start "" /b "http://www.google.com/search?q
=$*"
	echo.
	echo	Alias save files are stored in:
	echo		%userprofile%\.aliases
	echo.
	echo	Alias configuration args
	echo		Example:
	echo			ALIAS set [option]
	echo		Options include:
	echo.		   autostart [true|false]
	echo.
	echo	-H --HELP OR /?
	echo		Will bring up this help
	echo.
	echo		NOTE: If you want args passed as input to your alias, include a $* or $1
-$9
	echo.
goto :save
:init_exec_alias
	doskey %arg1%=%arg2% %arg3% %arg4% %arg5% %arg6% %arg7% %arg8%
	del %useraliases%
	goto :save
:save
	doskey /macros>%useraliases%
	doskey /macros>>%useraliases_history%
:cleanup
	set useraliases=""
	set cmd_as_arg=""
	set arg1=""
	set arg2=""
	set arg3=""
	set arg4=""
	set arg5=""
	set arg6=""
	set arg7=""
	set arg8=""
:end
