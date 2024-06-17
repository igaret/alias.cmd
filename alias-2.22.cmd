:: alias-[current_version].cmd
:: version 2.22
:: by garet mccallister (g4r3t-mcc4ll1st3r/izryel)
@echo off
:arg_debugger
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
		set arg9=%9
		@echo off
		goto :arg_force
	)
:arg_force
	if [%1] == [--force] (
		set force=true
		set arg1=%2
		set arg2=%3
		set arg3=%4
		set arg4=%5
		set arg5=%6
		set arg6=%7
		set arg7=%8
		set arg8=%9
		set arg9=%10
		goto :script_start
	) else (
		set force=false
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
:parser1a
	if [%arg1%] == [alias] ( goto :selfpreservation ) else ( goto :parser1b )
:parser1b
	if [%arg1%] == [doskey] ( goto :selfpreservation ) else ( goto :parser1c)
:parser1c
	if [%arg1%] == [] ( goto :list ) else ( goto :init_exec_alias )
:selfpreservation
	set cmd_as_arg=%arg1%
	if [%force%] == [true] (
		doskey alias=
		doskey /macros > %useraliases%
		goto :init_exec_alias
	) else (
		echo.
		echo cannot set an %cmd_as_arg% for %cmd_as_arg%, it would be creating an alias/doskey paradox.
		echo.
		goto :cleanup
	)
:list
	echo.
	doskey /macros
	echo.
	goto :cleanup
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
:end
:eof
