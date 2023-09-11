:: alias.cmd
:: by garet mccallister (izryel)
::
:: [table of contents]
:: 	script_start
::		(determine if debugging or not)
::	
:: 	
:: notes:
:: [if else statements template]
::	if "%arg"=="foobar" (
::		cmd example
::		cmd arg example
::		goto :statement_true
::	) else (
::		cmd example
::		cmd arg example
::		goto :statement_false
:: 	)	
@echo off
	setlocal enableextensions
	setlocal disableextensions
	setlocal enabledelayedexpansion
	setlocal disabledelayedexpansion
	goto :set_version
:help
	echo.                                                                                                                               
	echo  alias -- expanded doskey functionality                                                                                                                           
	echo  usage:
	echo  alias -h --help or /?                                                                                                      
	echo.                                                                                                                                 
	echo     creates a custom command, or shorthand nickname for available commandsecho                                                       
	echo     similar to the bash command "alias" with a notable exceptionecho echo echo                                                               
	echo     single quotes around the custom command are not required                                                                     
	echo             example:                                                                                                             
	echo                     alias ls='ls -a --color=always'                                                                              
	echo             becomesecho echo echo                                                                                                            
	echo                     alias ls=ls -a --color=always $^*                                                                            
	echo.                                                                                                                                 
	echo.                                                                                                                                 
	echo     usage:                                                                                                                       
	echo             alias [alias]=[command]                                                                                              
	echo                     [alias]          specifies a name for an alias you create                                                    
	echo                     [command]                  specifies the triggered command(s)                                                
	echo.                                                                                                                                 
	echo.                                                                                                                                 
	echo     to clear an alias, make its definition blank                                                                                 
	echo             example:                                                                                                             
	echo                     alias ls=                                                                                                    
	echo                                                                                                                                 
	echo.                                                                                                                                 
	echo     special alias definitions:                                                                                                   
	echo             $t                        command separator                                                                  
	echo             $1-$9              arguments for batch variables                                                                     
	echo             $*                        arguments for batch parameters                                                             
	echo                     example:                                                                                                     
	echo                       alias google=start "" /b "http://wwwecho googleecho com/search?q=$*"                                                                                                                                         
	echo.                                                                                                                                 
	echo     alias save files for users are stored in:                                                                                              
	echo             %userprofile%\echo aliases
	echo     alias save files for machine are stored in:                                                                                              
	echo             %programdata%\echo aliases                                                                                               
	echo.                                                                                                                                 
	echo     alias debugging                                                                                                     
	echo                     alias --debug [option]                                                                                           
	echo             example:                                                                                                             
	echo                     alias --debug ls=dir /b $*                                                                                           
	echo.                                                                                             
	echo             note: if you want args passed as input to your alias, include a $* or $1-$9                                                                                                                                          
	echo.        
	echo.
	goto :save
:set_version
	set alias_local_version=2.08
:make_eval
	setlocal enableextensions
::	setlocal disableextensions
	setlocal enabledelayedexpansion
::	setlocal disabledelayedexpansion
	if not exist %~d0eval.cmd (
	echo @echo off > %~d0eval.cmd
	echo echo %%* ^> tmp >> %~d0eval.cmd
	echo set /p eval=^<tmp >> %~d0eval.cmd
	echo %%eval%% >> %~d0eval.cmd
	)
:script_start
	if [%1] == [--debug] (
		set arg1=%2
		set arg2=%3
		set arg3=%4
		set arg4=%5
		set arg5=%6
		set arg6=%7
		set arg7=%8
		set arg8=%9
		@echo on
		goto :update_check
	) else (
		set arg1=%1
		set arg2=%2
		set arg3=%3
		set arg4=%4
		set arg5=%5
		set arg6=%6
		set arg7=%7
		set arg8=%8
		@echo off
		goto :update_check	
	)
:update_check
	setlocal enableextensions
	setlocal disabledelayedexpansion
	set alias_command=%~f0
	curl https://raw.githubusercontent.com/izryel/alias.cmd/master/current_version.txt>alias_online_version.txt 2>nul
	set /p alias_online_version=<alias_online_version.txt
	del /s /q alias_online_version.txt >nul 2>nul
	setlocal enableextensions
	setlocal enabledelayedexpansion
	if %alias_online_version% gtr %alias_local_version% (
		curl https://raw.githubusercontent.com/izryel/alias.cmd/master/alias.cmd>%alias_command% 2>nul
		goto :cleanup
	) else (
		goto :start
	)
:start
::setlocal enableextensions
setlocal disableextensions
::setlocal enabledelayedexpansion
setlocal disabledelayedexpansion
	set useraliases=%userprofile%\.aliases
	set useraliases_history="%userprofile%\.aliases_history"
	if not exist %useraliases% echo. > %useraliases%
	doskey /macrofile="%useraliases%"
	doskey /macros > "%useraliases%"
:parser1
	if "%arg1%"=="/?" (
		goro :help
	) else (
		if "%arg1%"=="-h" (
			goto :help
		) else (
			if "%arg1%"=="--help" (
				goto :help
			) else (
				goto :parser4a
			)
		)
	)
:parser2
	
:parser3
	
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
	echo cannot set an "%cmd_as_arg%" for "%cmd_as_arg%, it would be creating an alias/doskey paradox.
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

:init_exec_alias
	doskey %arg1%=%arg2% %arg3% %arg4% %arg5% %arg6% %arg7% %arg8%
	del %useraliases%
	goto :save
:save
	doskey /macros>%useraliases%
	doskey /macros>>%useraliases_history%
	goto :cleanup
:up_to_date
	echo alias.cmd is up to date
	echo.
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
