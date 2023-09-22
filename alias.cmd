:: alias.cmd
:: by garet mccallister (izryel)
@echo off
call :env
call :set_version
:test_if_setup
	if exist "%alias_dir" (
		goto :script_start
	) else (
		call :install
		goto :script_start
	)
:script_start
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
	curl https://raw.githubusercontent.com/izryel/alias.cmd/master/current_version.txt>alias_online_version.txt 2>nul
	set /p alias_online_version=<alias_online_version.txt
	del /s /q alias_online_version.txt >nul 2>nul
	endlocal
	if %alias_online_version% gtr %alias_local_version% (
		curl https://raw.githubusercontent.com/izryel/alias.cmd/master/alias.cmd>%alias_dir%\alias.cmd 2>nul
		curl https://raw.githubusercontent.com/izryel/alias.cmd/master/refreshenv.cmd>%alias_dir%\refeshenv.cmd 2>nul
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
:parser1
	if "%arg1%"=="/?" (
		goro :help
	) else (
		if "%arg1%"=="-?" (
			goto :help
		) else (
			if "%arg1%"=="?" (
				goto :help
			) else (
				if "%arg1%"=="-h" (
					goto :help
				) else (
					if "%arg1%"=="--help" (
						goto :help
					) else (
						if "%arg1%"=="help" (
							goto :help
						) else (
							goto :parser2
						)
					)
				)
			)
		)
	)
:parser2
	endlocal
	goto :parser4a
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
	goto :cleanup
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
	goto :eof
:env
	set alias_dir=%allusersprofile%\alias
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
	set "env=hklm\system\currentcontrolset\control\session manager\environment"
	for /f "tokens=2*" %%i in ('reg query "%env%" /v path ^| findstr /i "\<path\>"') do (
		rem // make addition persistent through reboots
		reg add "%env%" /f /v path /t reg_expand_sz /d "%%j;%~1"
		rem // apply change to the current process
		for %%a in ("%%j;%~1") do path %%~a
	)
	(setx /m foo bar & reg delete "%env%" /f /v foo) >nul 2>nul
	goto :eof
:set_version
	set /p alias_local_version=<%alias_dir%\current_version.txt
	goto :eof
:help
	echo.                                                                                                                               
	echo  alias -- expanded doskey functionality                                                                                                                           
	echo.
	goto :eof
:install
	mkdir %alias_dir%
	curl https://raw.githubusercontent.com/izryel/alias.cmd/master/alias.cmd > %alias_dir%\alias.cmd 2>nul
	curl https://raw.githubusercontent.com/izryel/alias.cmd/master/refreshenv.cmd > %alias_dir%\refreshenv.cmd 2>nul
	curl https://raw.githubusercontent.com/izryel/alias.cmd/master/current_version.txt > %alias_dir%\current_version.txt 2>nul
	goto :eof
:end
:eof
