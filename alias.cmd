:: alias.cmd
:: version 2.3
:: by garet mccallister (g4r3t-mcc4ll1st3r/izryel/igaret)
@echo off
endlocal
set current_version=2.3
:init
	if [%1] == [--debug] (
		@echo on
		set arg1=%2
		set arg2=%3
		set arg3=%4
		set arg4=%5
		set arg5=%6
		set arg6=%7
		set arg7=%8
		set arg8=%9
		goto :script_start
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
		goto :script_start
	)
:script_start
	if [%arg1%] == [alias] ( goto :selfpreservation )
	if [%arg1%] == [doskey] ( goto :selfpreservation )
	set alias_dir=%allusersprofile%\alias
	set useraliases=%userprofile%\.aliases
	set useraliases_history=%userprofile%\.aliases_history
	if exist %useraliases% goto :parser4
	if not exist %useraliases% echo. > %useraliases%
	if not exist %alias_dir% goto :user_setup_query
:pre_user_setup_query
	set arg1=%arg2%
	set arg2=%arg3%
	set arg3=%arg4%
	set arg4=%arg5%
	set arg5=%arg6%
	set arg6=%arg7%
	set arg7=%arg8%
	set arg8=%arg9%
:user_setup_query
	echo Install ALIAS for permanent use?
	set user_input=
	set /p user_input=(y/n): 
	if /i "%user_input%" == "y" goto :setup_alias
	if /i "%user_input%" == "n" goto :decline_setup
	echo incorrect input & goto :user_setup_query
:decline_setup
	echo.
	echo ok. skipping install.
	echo if you change your mind later, just run "alias setup"
	echo.
:parser3
	endlocal
	goto :parser4
:parser4
	if [%arg1%] == [setup] ( goto :pre_user_setup_query ) else ( goto :parser5 )
:parser5
	if [%arg1%] == [update] ( goto :update_check ) else ( goto :parser6 )
:parser6
	if [%arg1%] == [reset] ( goto :reset ) else ( goto :parser7 )
:parser7
	if [%arg1%] == [] ( goto :list ) else ( goto :init_exec_alias )
:selfpreservation
	set cmd_as_arg=%arg1%
	echo.
	echo cannot set an %cmd_as_arg% for %cmd_as_arg%, it would be creating an alias/doskey paradox.
	echo
	goto :cleanup
:list
	echo.
	doskey /macros
	echo.
	goto :save
:init_exec_alias
	doskey %arg1%=%arg2% %arg3% %arg4% %arg5% %arg6% %arg7% %arg8%
	del %useraliases%
	goto :save
:save
	doskey /macros>%useraliases%
	doskey /macros>>%useraliases_history%
	goto :cleanup
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
	set current_version=""
	goto :eof
:help
	echo.                                                                                                                               
	echo  alias -- expanded doskey functionality                                                                                                                           
	echo.
	goto :cleanup
:update_check
	curl https://raw.githubusercontent.com/igaret/alias.cmd/master/current_version.txt>%tmp%\alias_online_version.txt 2>nul
	set /p alias_online_version=<%tmp%\alias_online_version.txt
	del /s /q %tmp%\alias_online_version.txt >nul 2>nul
	if [%alias_online_version%] gtr [%current_version%] ( 
		echo updating to %alias_online_version%
		ren %alias_dir%\alias.cmd %alias_dir%\.alias_%current_version%.cmd
		curl https://raw.githubusercontent.com/igaret/alias.cmd/master/alias.cmd>%alias_dir%\alias.cmd 2>nul
		curl https://raw.githubusercontent.com/badrelmers/RefrEnv/main/refrenv.bat>%alias_dir%\refrenv.cmd 2>nul		
	)
	goto :cleanup
:setup_alias
	if not exist %alias_dir% mkdir %alias_dir%
:setup_alias2
	curl https://raw.githubusercontent.com/igaret/alias.cmd/master/alias.cmd>%alias_dir%\alias.cmd 2>nul
	curl https://raw.githubusercontent.com/badrelmers/RefrEnv/main/refrenv.bat>%alias_dir%\refrenv.cmd 2>nul		
	setx path "%PATH%;%alias_dir%" /m
	echo alias setup complete.
	echo alias.cmd was moved to %alias_dir% and added to PATH
	del /s /q "%~f0" 2>nul
	%alias_dir%\refrenv.cmd 
	call :post_inst & exit /b 
:reset
	del /s /q %useraliases%
	echo. > %useraliases%
	echo reset complete
	goto :eof
:post_inst
	(goto) 2>nul & timeout /t 1 2>nul
:end
:eof
::		call :setup_check
::		call :update_check
::	setx alias_dir "%allusersprofile%\alias" /m
::		setx path "%PATH%;%alias_dir%"

::	del /s /q %~dp0/%0
