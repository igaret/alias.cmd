:: alias.cmd
:: version 2.42
:: by garet mccallister (g4r3t-mcc4ll1st3r/izryel/igaret)
@echo off
set current_version=2.42
:init
	for %%a in (
		/d /debug --debug -debug -d
	) do if [%1]==[%%a] (
		goto :set_debug
	)
	goto :set_nodebug
:set_debug
	set arg1=%2
	set arg2=%3
	set arg3=%4
	set arg4=%5
	set arg5=%6
	set arg6=%7
	set arg7=%8
	set arg8=%9
	@echo on
	goto :check_admin
:set_nodebug
	@echo off
	set arg1=%1
	set arg2=%2
	set arg3=%3
	set arg4=%4
	set arg5=%5
	set arg6=%6
	set arg7=%7
	set arg8=%8
:check_admin
	set is_admin=false
	net session >nul 2>&1
	if [%errorlevel%] == [0] (
		set is_admin=true
	)
:set_env
	set alias_dir=%allusersprofile%\alias
	if [%is_admin%] == [true] (
		set useraliases=%alias_dir%\.aliases
		set useraliases_history=%alias_dir%\.aliases_history
	) else (
		set useraliases=%userprofile%\.aliases
		set useraliases_history=%userprofile%\.aliases_history
	)
	if not exist %alias_dir% (
		goto :user_setup_query
	)
	for %%a in (
		? /? help /help --help -help -h
	) do if [%arg1%]==[%%a] (
		goto :help
	)
	for %%a in (
		doskey alias unalias
	) do if [%arg1%]==[%%a] (
		goto :selfpreservation
	)
	if exist %useraliases% (
		goto :parser1
	)
	if not exist %useraliases% (
		echo unalias=%alias_dir%\alias.cmd $1^^= > %useraliases%
	)
	goto :parser1
:user_setup_query
	echo Install ALIAS for permanent use?
	set user_input=
	set /p user_input=(y)es/(n)o: 
	if /i [%user_input%] == [y] ( 
		goto :setup_alias
	) else (
		goto :decline_setup
	)
	goto :user_setup_query
:decline_setup
	echo.
	echo ok. skipping install.
	echo if you change your mind later, just run "alias /setup | --setup | -setup | -s"
	echo OR
	echo if you change your mind later, just run "alias /install | --install | -install | -i"
	echo.
:parser1
	for %%a in (
		/s /i /setup /install --setup --install -setup -install -s -i
	) do if [%arg1%]==[%%a] (
		goto :setup_alias
	)
	goto :parser2
:parser2
	for %%a in (
		/update --update -update -u /u
	) do if [%arg1%]==[%%a] (
		goto :update_check
	)
	goto :parser3
:parser3
	for %%a in (
		/reset --reset -reset -r /r
	) do if [%arg1%]==[%%a] (
		goto :reset
	)
	goto :parser4
:parser4
	for %%a in (
		/list --list -list -l /l
	) do if [%arg1%]==[%%a] (
		goto :list
	)
	if [%arg1%] == [] (
		goto :list
	)
	goto :init_exec_alias
:selfpreservation
	set cmd_as_arg=%arg1%
	set is_unalias=%0
	if [%0] == [unalias] (
		goto :init_exec_unalias
	) else (
		goto :selfpreservation_echo
	)
:selfpreservation_echo
	echo.
	echo cannot set an %cmd_as_arg% for %cmd_as_arg%, it would be creating an alias/doskey paradox.
	echo
	goto :cleanup
:list
	echo.
	doskey /macrofile=%useraliases%
	doskey /macros
	echo.
	goto :cleanup
:init_exec_unalias
	doskey /macrofile=%useraliases%
	doskey %arg1%=
	goto :save
:init_exec_alias
	doskey /macrofile=%useraliases%
	doskey %arg1%=%arg2% %arg3% %arg4% %arg5% %arg6% %arg7% %arg8%
	goto :save
:save
	del /s /q %useraliases%
	doskey /macros > %useraliases%

	doskey /macros >> %useraliases_history%
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
	echo  ALIAS -- expanded doskey functionality
	echo.
	echo 	*** no madatory arguments, however if none are passed then arg assumed is "list" ***
	echo.
	echo following options will include all following arguments, but does not require them:
	echo 	DEBUGGING:	/d /debug --debug -debug -d
	echo.
	echo following options will not consider any following arguments...
	echo 	SHOW HELP:	/? /help --help -help -h OR ?
	echo			(will show this help)
	echo.
	echo 	RESET:		/r /reset --reset -reset -r
	echo			(will delete current savelist)
	echo.
	echo 	INSTALL
	echo 	or:		/i /s /install /setup --install --setup -install -setup -i -s
	echo	SETUP
	echo.
	echo			(will install alias.cmd in \ProgramData\alias.cmd\)
	echo 	list:		/l /list --list -list -l
	echo			(will list all currently saved "aliases" aka "doskey macros"
	echo.
	echo since alias is dependent upon doskey to operate:
	echo.
	echo doskey /?:
	doskey /?
	echo.
	goto :cleanup
:update_check
	curl -sL https://raw.githubusercontent.com/igaret/alias.cmd/master/current_version.txt>%tmp%\alias_online_version.txt 2>nul
	set /p alias_online_version=<%tmp%\alias_online_version.txt
	del /s /q %tmp%\alias_online_version.txt >nul 2>nul
	if [%alias_online_version%] gtr [%current_version%] ( 
		echo updating to %alias_online_version%
		ren %alias_dir%\alias.cmd %alias_dir%\.alias_%current_version%.cmd
		curl -sL https://raw.githubusercontent.com/igaret/alias.cmd/master/alias.cmd>%alias_dir%\alias.cmd 2>nul
		curl -sL https://raw.githubusercontent.com/badrelmers/RefrEnv/main/refrenv.bat>%alias_dir%\refrenv.cmd 2>nul		
	)
	goto :cleanup
:setup_alias
	if not exist %alias_dir% mkdir %alias_dir%
:setup_alias2 	
	curl -sL https://raw.githubusercontent.com/igaret/alias.cmd/master/alias.cmd>%alias_dir%\alias.cmd 2>nul
	curl -sL https://raw.githubusercontent.com/badrelmers/RefrEnv/main/refrenv.bat>%alias_dir%\refrenv.cmd 2>nul
	if [%is_admin%] == [true] (
		setx path "%path%;%alias_dir%" /m
	) else (
		setx path "%path%;%alias_dir%"
	)
	%alias_dir%\refrenv.cmd  2>nul
	echo alias setup complete.
	echo alias.cmd was moved to %alias_dir% and added tp ^%PATH^%
	call :post_inst
	goto :eof
:reset
	del /s /q %useraliases%
	echo. > %useraliases%
	taskkill /f /im doskey* 2>nul
	echo reset complete
	goto :eof
:post_inst
	echo [%~f0]
	goto :eof
goto :eof
:eof
