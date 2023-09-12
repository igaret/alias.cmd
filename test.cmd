::@echo off
	setlocal enabledelayedexpansion
	set time_start=%time%
	set time_choice_wait=20
	set script_ver=1.01
	set script_name=%~n0
	set server_url=https://raw.githubusercontent.com/izryel/alias.cmd/master
	set script_name_cmd=%script_name%.cmd
	set script_name_cfg=%script_name%.conf
	set script_name_latest_ver=%script_name%.latest.ver
	set local_dir=%allusersprofile%\test
	echo %script_name% v%script_ver%
	echo %script_ver% > %script_name%.current.ver
	if not exist "%script_name_cfg%" call :script_missing_cfg
	for /f "delims=" %%x in (%script_name%.conf) do (set "%%x")
	if %__deploy_mode% equ 1 goto ::eof
	if %auto_update_compare% equ 1 call :script_compare_ver
:script_main
:: =======================================
:: === edit below this line ==
	echo waiting for content...
:: === edit above this line ==
:: =======================================
	goto :end
:script_missing_cfg
	echo creating new %script_name%.conf file...
	echo __deploy_mode=0 > "%script_name_cfg%"
	echo repository_base_url=%server_url% >> "%script_name_cfg%"
	echo auto_update_compare=1>> "%script_name_cfg%"
	echo auto_update_download=1 >> "%script_name_cfg%"
	echo local_dir=%allusersprofile%\test >> "%script_name_cfg%"
	goto ::eof
:script_compare_ver
	echo please wait while script versions are compared...
	powershell -command "& { (new-object net.webclient).downloadfile('%server_url%/%script_name%.current.ver', '%local_dir%\%script_name_latest_ver%') }"
	if not exist "%script_name_latest_ver%" goto :end
	set /p script_latest_ver= < "%script_name_latest_ver%"
	if %script_ver% equ %script_latest_ver% call :script_compare_ver_same
	if %script_ver% neq %script_latest_ver% call :script_compare_ver_diff
	goto ::eof
:script_compare_ver_same
	echo versions are both %script_name% v%script_ver%
	goto ::eof
:script_compare_ver_diff
	echo current version:%script_ver% ^| server version:%script_latest_ver%
	if %auto_update_download% equ 1 goto :script_download_script
	echo.
	echo would you like to download the latest %script_name% v%script_latest_ver%?
	echo defaulting to n in %time_choice_wait% seconds...
	choice /c yn /t %time_choice_wait% /d n
	if errorlevel 1 ( goto :script_download_script ) else ( goto :eof )
:script_download_script
	echo please wait while script downloads...
	powershell -command "& { (new-object net.webclient).downloadfile('%server_url%/%script_name_cmd%', '%local_dir%\%script_name_cmd%') }"
	echo script updated to v%script_latest_ver%^^!
:: user must exit script. current batch is stale.
	goto :end
:script_download_nothing
	goto :eof
:end
	set time_end=%time%
:eof
