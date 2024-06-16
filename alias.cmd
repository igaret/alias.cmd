:: alias.cmd
:: version 2.21
:: by garet mccallister (g4r3t-mcc4ll1st3r/izryel)
@echo off
:start_of_script
	set alias_dir=%allusersprofile%\alias
	set current_version=2.21
:update_check
	if [%1] == [--setup] (
		doskey alias=
		doskey alias=%alias_dir%\alias-%alias_online_version%.cmd $1	
		goto :end
	)
	if exist %alias_dir%\current_version.txt (
	::	set /p alias_local_version=<%alias_dir%\current_version.txt 
		del %alias_dir%\current_version.txt
		set alias_local_version=%current_version%		
	) else (
		set alias_local_version=%current_version%
	)
	curl https://raw.githubusercontent.com/g4r3t-mcc4ll1st3r/alias.cmd/master/current_version.txt>%tmp%\alias_online_version.txt 2>nul
	set /p alias_online_version=<%tmp%\alias_online_version.txt
	del /s /q %tmp%\alias_online_version.txt >nul 2>nul
	endlocal
	if [%alias_online_version%] gtr [%alias_local_version%] (
		echo updating to %alias_online_version%
		doskey alias=	
		curl https://raw.githubusercontent.com/g4r3t-mcc4ll1st3r/alias.cmd/master/alias.cmd>%alias_dir%\alias.cmd 2>nul
		curl https://raw.githubusercontent.com/g4r3t-mcc4ll1st3r/alias.cmd/master/alias-%alias_online_version%.cmd>%alias_dir%\alias-%alias_online_version%.cmd 2>nul
		curl https://raw.githubusercontent.com/g4r3t-mcc4ll1st3r/alias.cmd/master/refreshenv.cmd>%alias_dir%\refeshenv.cmd 2>nul
		echo %alias_online_version%>%alias_dir%\current_version.txt
		goto :pre-init
	) else (
		goto :pre-init
	)
:pre-init
	if [%1] == [-v] (
		echo %current_version%
		goto :end
	) else (
		if [%1] == [--version] (
			echo %current_version%
			goto :end
		) else (
			goto :end
		)
	)
:end
	%alias_dir%\alias-%current_version% %*
:eof
