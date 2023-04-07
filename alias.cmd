@echo off
	set tempvar=%~dp0
	set scriptdir=%tempvar:~0,-1%
	set tempvar=
	if not exist %userprofile%\Doskey-Aliases mkdir %userprofile%\Doskey-Aliases && echo.>%userprofile%\Doskey-Aliases\.aliases
	doskey /macrofile=%userprofile%\Doskey-Aliases\.aliases
	doskey /macros>%userprofile%\Doskey-Aliases\.aliases
:parser1
	if "%1"=="/?" ( goto :help ) else ( goto :parser2 )
:parser2
	if "%1"=="-h" ( goto :help ) else ( goto :parser3 )
:parser3
	if "%1"=="--help" ( goto :help ) else ( goto :parser4a )
:parser4a
	if "%1"=="alias" ( goto :selfpreservation ) else ( goto :parser4b )
:parser4b
	if "%1"=="doskey" ( goto :selfpreservation ) else ( goto :parser5 )
:parser5
	if "%1"=="clear-aliases" ( goto :clear ) else ( goto :parser6 )
:parser6
	if "%1"=="" ( goto :list ) else ( goto :alias )
	goto :end
:selfpreservation
set arg=%1
echo.
echo Cannot set an %arg% for %arg%, it would be creating an alias/doskey paradox. 
echo.
:list
echo.
	doskey /macros
echo.
	goto :end 
:alias
	doskey %*
	del %userprofile%\Doskey-Aliases\.aliases
	goto :end
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
	echo			ALIAS ls=ls -A --color=always
	echo.
	echo.	
	echo	Usage:
	echo		ALIAS [alias]=[command]
	echo			[alias]			specifies a name for an alias you create
	echo			[command]		specifies the triggered command(s)
	echo.
	echo.
	echo 	To clear an alias, make its definition blank
	echo		Example:
	echo			ALIAS ls=
	echo.
	echo.
	echo	Special alias definitions:
	echo		$t     			Command separator.
	echo		$1-$9  			Arguments for batch variables
	echo		$*     			Arguments for batch parameters
	echo			Example:
	echo.				ALIAS google=start "" /b "http://www.google.com/search?q=$*"
	echo.
	echo	Alias save files are stored in:
	echo		%userprofile%\Doskey-Aliases
	echo.
	echo	-H --HELP OR /?
	echo		Will bring up this help
	echo.
goto :end
:end
	doskey /macros>%userprofile%\Doskey-Aliases\.aliases
	doskey /macros>>%userprofile%\Doskey-Aliases\.aliases_history
REM End of Script
