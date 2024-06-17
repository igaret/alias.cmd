:: alias.cmd
:: version 2.21
:: by garet mccallister (g4r3t-mcc4ll1st3r/izryel)
@echo off
:start_of_script
	set alias_dir=%allusersprofile%\alias
	set current_version=2.21
	set useraliases=%userprofile%\.aliases
	if [%1] == [--setup] (
		doskey alias=
		doskey /macros>%useraliases%
		doskey alias=%alias_dir%\alias.cmd $*
		goto :end
	)
:update_check
		curl https://raw.githubusercontent.com/g4r3t-mcc4ll1st3r/alias.cmd/master/current_version.txt>%tmp%\alias_online_version.txt 2>nul
		set /p alias_online_version=<%tmp%\alias_online_version.txt
		del /s /q %tmp%\alias_online_version.txt >nul 2>nul
		if [%alias_online_version%] gtr [%current_version%] ( 
			echo updating to %alias_online_version%
			type %alias_dir%\alias.cmd > %alias_dir%\.alias-deprecated-%date%
			ren %alias_dir%\alias-%current_version%.cmd %alias_dir%\.alias_%current_version%-deprecated-%date%		
			curl https://raw.githubusercontent.com/g4r3t-mcc4ll1st3r/alias.cmd/master/alias.cmd>%alias_dir%\alias.cmd 2>nul
			curl https://raw.githubusercontent.com/g4r3t-mcc4ll1st3r/alias.cmd/master/alias-%alias_online_version%.cmd>%alias_dir%\alias-%alias_online_version%.cmd 2>nul
			curl https://raw.githubusercontent.com/badrelmers/RefrEnv/main/refrenv.bat>%alias_dir%\refrenv.bat 2>nul		
			set args=%*
			%alias_dir%\alias-%current_version%.cmd %args%
		) else ( 
			set args=%*
			%alias_dir%\alias-%current_version%.cmd %args%
		)
:end
:eof
