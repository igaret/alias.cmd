:: alias.cmd
:: by garet mccallister (g4r3t-mcc4ll1st3r)
@echo off
call :set_env
call :alias_setversion
:test_if_setup
	if exist "%alias_dir%" (
		goto :debug_parser
	) else (
		call :install_alias
		goto :debug_parser
	)
:debug_parser
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
		set arg9=%10
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
		set arg9=%9
		@echo off
		goto :update_check	
	)
:update_check
	curl https://raw.githubusercontent.com/g4r3t-mcc4ll1st3r/alias.cmd/master/current_version.txt>alias_online_version.txt 2>nul
	set /p alias_online_version=<alias_online_version.txt
	del /s /q alias_online_version.txt >nul 2>nul
	endlocal
	if %alias_online_version% gtr %alias_local_version% (
		curl https://raw.githubusercontent.com/g4r3t-mcc4ll1st3r/alias.cmd/master/alias.cmd>%alias_dir%\alias.cmd 2>nul
		curl https://raw.githubusercontent.com/g4r3t-mcc4ll1st3r/alias.cmd/master/refreshenv.cmd>%alias_dir%\refeshenv.cmd 2>nul
		echo %alias_online_version%>%alias_dir%\current_version.txt
		goto :start
	) else (
		goto :start
	)
:start
endlocal
	set useraliases=%userprofile%\.aliases
	set useraliases_history="%userprofile%\.aliases_history"
	if not exist %useraliases% echo. > %useraliases%
	doskey /macrofile="%useraliases%"
	doskey /macros > "%useraliases%"
:alias_arg_parser_1
	if "%arg1%"=="/?" (
		goro :alias_help
	) else (
		if "%arg1%"=="-?" (
			goto :alias_help
		) else (
			if "%arg1%"=="?" (
				goto :alias_help
			) else (
				if "%arg1%"=="-h" (
					goto :alias_help
				) else (
					if "%arg1%"=="--help" (
						goto :alias_help
					) else (
						if "%arg1%"=="help" (
							goto :alias_help
						) else (
							goto :alias_arg_parser_2a
						)
					)
				)
			)
		)
	)
:alias_arg_parser_2a
	if "%arg1%"=="alias" ( goto :doskey_selfpreservation ) else ( goto :alias_arg_parser_2b )
:alias_arg_parser_2b
	if "%arg1%"=="doskey" ( goto :doskey_selfpreservation ) else ( goto :alias_arg_parser_3)
:alias_arg_parser_3
	if "%arg1%"=="update" ( goto :update ) else ( goto :alias_arg_parser_4 )
:alias_arg_parser_4
	if "%arg1%"=="reset" ( goto :reset_aliases ) else ( goto :alias_arg_parser_5 )
:alias_arg_parser_5
	if "%arg1%"=="" ( goto :alias_output_list ) else ( goto :alias_init )
	goto :alias_save
:doskey_selfpreservation
	set cmd_as_arg="%arg1%"
	echo.
	echo cannot set an "%cmd_as_arg%" for "%cmd_as_arg%, it would be creating an alias/doskey paradox.
	echo.
	goto :alias_cleanup
:alias_output_list
	echo.
	doskey /macros
	echo.
	goto :alias_save
:reset_aliases
	del %useraliases%
	doskey
	goto :alias_cleanup
:alias_init
	doskey %arg1%=%arg2% %arg3% %arg4% %arg5% %arg6% %arg7% %arg8%
	del %useraliases%
	goto :alias_save
:alias_save
	doskey /macros>%useraliases%
	doskey /macros>>%useraliases_history%
	goto :alias_cleanup
:alias_uptodate
	echo alias.cmd is up to date
	echo.
:alias_cleanup
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
	goto :eof
:set_env
	set alias_dir=%allusersprofile%\alias
	goto :eof
:refreshenv
	setlocal enabledelayedexpansion
	for %%i in ("%alias_dir%") do pushd "%%~i" 2>nul && (set "new=!alias_dir!" && popd) || goto usage
	for %%i in ("%path:;=";"%") do pushd "%%~i" 2>nul && (
		rem // delaying expansion of !new! prevents parentheses from breaking things
		if /i "!new!"=="!alias_dir!" (
			endlocal
			goto :eof
		)
		popd
	)
	call :env-append_path "%new%"
	endlocal
	goto :eof
:env-append_path <val>
	set env="hklm\system\currentcontrolset\control\session manager\environment"
	for /f "tokens=2*" %%i in ('reg query "%env%" /v path ^| findstr /i "\<path\>"') do (
		rem // make addition persistent through reboots
		reg add "%env%" /f /v path /t reg_expand_sz /d "%%j;%~1"
		rem // apply change to the current process
		for %%a in ("%%j;%~1") do path %%~a
	)
	(setx /m foo bar & reg delete "%env%" /f /v foo) >nul 2>nul
	goto :eof
:alias_setversion	
	set /p alias_local_version=<%alias_dir%\current_version.txt
	goto :eof
:alias_help
	echo.                                                                                                                               
	echo  alias -- expanded doskey functionality                                                                                                                           
	echo.
	goto :eof
:install_alias
	mkdir %alias_dir% 2>nul
	curl https://raw.githubusercontent.com/g4r3t-mcc4ll1st3r/alias.cmd/master/alias.cmd > %alias_dir%\alias.cmd 2>nul
	curl https://raw.githubusercontent.com/g4r3t-mcc4ll1st3r/alias.cmd/master/refreshenv.cmd > %alias_dir%\refreshenv.cmd 2>nul
	curl https://raw.githubusercontent.com/g4r3t-mcc4ll1st3r/alias.cmd/master/current_version.txt > %alias_dir%\current_version.txt 2>nul
	setx PATH "%alias_dir%;%PATH%" /m
	call :refreshenv
	goto :eof
:end
:eof
