:: alias.cmd
:: version 2.4
:: by garet mccallister (g4r3t-mcc4ll1st3r/izryel/igaret)
@echo off
set current_version=2.41
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
	set alias_dir=%allusersprofile%\alias
	set useraliases=%userprofile%\.aliases
	set useraliases_history=%userprofile%\.aliases_history
	if not exist %alias_dir% goto :user_setup_query
	for %%a in (
		/? help /help --help -help -h 
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
	echo if you change your mind later, just run "alias setup"
	echo.
:parser1
	C:\windows\system32\doskey.exe /macrofile=%useraliases%
	for %%a in (
		setup /s /i /setup /install --setup --install -setup -install -s -i s i
	) do if [%arg1%]==[%%a] (
		goto :setup_alias
	)
	goto :parser2
:parser2
	for %%a in (
		update /update --update -update -u /u u
	) do if [%arg1%]==[%%a] (
		goto :update_check
	)
	goto :parser3
:parser3
	for %%a in (
		reset /reset --reset -reset -r /r r 
	) do if [%arg1%]==[%%a] (
		goto :reset
	)
	goto :parser4
:parser4
	for %%a in (
		list /list --list -list -l /l l
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
	C:\windows\system32\doskey.exe /macros
	echo.
	goto :save
:init_exec_unalias
	del %useraliases%
	C:\windows\system32\doskey.exe %arg1%=
	goto :save
:init_exec_alias
	C:\windows\system32\doskey.exe %arg1%=%arg2% %arg3% %arg4% %arg5% %arg6% %arg7% %arg8%
	del %useraliases%
	goto :save
:save
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
	echo  alias -- expanded doskey functionality                                                                                                                           
	echo.
	echo no madatory arguments, however if none are passed then arg assumed is "list"
	echo.\
	echo following options will include all following arguments, but does not require them:
	echo 	debugging:	/d /debug --debug -debug -d debug d
	echo.
	echo following options will not consider any following arguments...
	echo 	show help:	/? /help --help -help -h help h OR ?
	echo			(will show this help)
	echo 	reset:		/r /reset --reset -reset -r reset r
	echo			(will delete current savelist)
	echo 	install:	/i /s /install /setup --install --setup -install -setup -i -s i s
	echo 			(will install alias.cmd in \ProgramData\alias.cmd\)
	echo 	list:		/l /list --list -list -l l
	echo			(will list all currently saved "aliases" aka "doskey macros"
	echo.
	echo.
	echo.
	echo since alias is dependent upon doskey to operate:
	doskey /?
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
	%alias_dir%\refrenv.cmd  2>nul
	echo alias setup complete.
	echo alias.cmd was moved to %alias_dir% and added tp ^%PATH^%
	call :post_inst & exit /b 
:reset
	del /s /q %useraliases%
	echo. > %useraliases%
	taskkill /f /im doskey* 2>nul
	echo reset complete
	goto :eof
:post_inst
	echo [%~f0]
	goto :eof
:end
:eof
