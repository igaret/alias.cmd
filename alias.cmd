@echo off
	if "%alias_firstrun%"=="complete" ( goto :update ) else ( goto :setup )
:setup
	setx walls "%SystemDrive%\Walls" /m
	if not exist %walls% ( goto :create_walls ) else ( goto :update )
:create_walls
	mkdir %walls%
	setx alias_firstrun "complete" /m
	setx PATH "%PATH%;%walls%" /m
	goto :update
:update
	set alias_vars="%*"
	set update_url_src=https://raw.githubusercontent.com/izryel/alias.cmd/master/aliasd.cmd
	curl %update_url_src% -o %walls%\aliasd.cmd
	%walls%\aliasd %alias_vars%
