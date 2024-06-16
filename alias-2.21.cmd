:: alias-[current_version].cmd
:: version 2.21
:: by garet mccallister (g4r3t-mcc4ll1st3r/izryel)
@echo off
:start_of_script
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
		goto :script_start
	)
:script_start
endlocal
	set useraliases=%userprofile%\.aliases
	set useraliases_history=%userprofile%\.aliases_history%
	if not exist %useraliases% echo. > %useraliases%
	doskey /macrofile=%useraliases%
	doskey /macros > %useraliases%
:parser1
	if [%arg1%] == [/?] (
		goto :help
	) else (
		if [%arg1%] == [-?] (
			goto :help
		) else (
			if [%arg1%] == [?] (
				goto :help
			) else (
				if [%arg1%] == [-h] (
					goto :help
				) else (
					if [%arg1%] == [--help] (
						goto :help
					) else (
						if [%arg1%] == [help] (
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
	if [%arg1%] == [alias] ( goto :selfpreservation ) else ( goto :parser4b )
:parser4b
	if [%arg1%] == [doskey] ( goto :selfpreservation ) else ( goto :parser5a)
:parser5a
	if [%arg1%] == [update] ( goto :update ) else ( goto :parser5b )
:parser5b
	if [%arg1%] == [reset] ( goto :reset ) else ( goto :parser6 )
:parser6
	if [%arg1%] == [] ( goto :list ) else ( goto :init_exec_alias )
	goto :save
:selfpreservation
	set cmd_as_arg=%arg1%
	echo.
	echo cannot set an %cmd_as_arg% for %cmd_as_arg%, it would be creating an alias/doskey paradox.
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
	set current_version=""
	goto :eof
:env
	goto :eof
:env-append_path <val>
	goto :eof
:set_version
	goto :eof
:help
	echo.                                                                                                                               
	echo  alias -- expanded doskey functionality                                                                                                                           
	echo.
	goto :eof
:install
	goto :eof
:end
:eof
`
