@echo off
	setlocal enabledelayedexpansion
	set time_start=%time%
	set time_choice_wait=20
	set script_ver=1.00
	set script_name=%~n0
	set server_url=https://dl.dropboxusercontent.com/u/12345678/
	set script_name_bat=%~dp0%script_name%.bat
	set script_name_cfg=%~dp0%script_name%.conf
	set script_name_latest_ver=%~dp0%script_name%.latest.ver
	echo %script_name% v%script_ver%
	echo %script_ver% > %script_name%.current.ver
	if not exist "%script_name_cfg%" call :script_missing_cfg
	for /f "delims=" %%x in (%script_name%.conf) do (set "%%x")
	if %__deploy_mode% equ 1 goto :eof
	if %auto_update_compare% equ 1 call :script_compare_ver
:script_main
:: =======================================
:: === edit below this line ==
	echo waiting for content...
:: === edit above this line ==
:: =======================================
	goto end
:script_missing_cfg
	echo creating new %script_name%.conf file...
	echo __deploy_mode=0 > "%script_name_cfg%"
	echo repository_base_url=%server_url% >> "%script_name_cfg%"
	echo auto_update_compare=1>> "%script_name_cfg%"
	echo auto_update_download=1 >> "%script_name_cfg%"
	echo update %script_name%.conf as needed, then save and close to continue.
	echo waiting for notepad to close...
	notepad "%script_name_cfg%"
	goto :eof
:script_compare_ver
	echo please wait while script versions are compared...
	powershell -command "& { (new-object net.webclient).downloadfile('%server_url%%script_name%.current.ver', '%script_name_latest_ver%') }"
	if not exist "%script_name_latest_ver%" goto end
	set /p script_latest_ver= < "%script_name_latest_ver%"
	if %script_ver% equ %script_latest_ver% call :script_compare_ver_same
	if %script_ver% neq %script_latest_ver% call :script_compare_ver_diff
	goto :eof
:script_compare_ver_same
	echo versions are both %script_name% v%script_ver%
	goto :eof
:script_compare_ver_diff
	echo current version:%script_ver% ^| server version:%script_latest_ver%
	if %auto_update_download% equ 1 goto script_download_script
	echo.
	echo would you like to download the latest %script_name% v%script_latest_ver%?
	echo defaulting to n in %time_choice_wait% seconds...
	choice /c yn /t %time_choice_wait% /d n
	if errorlevel 2 goto script_download_nothing
	if errorlevel 1 goto script_download_script
	if errorlevel 0 goto script_download_nothing
:script_download_script
	echo please wait while script downloads...
	powershell -command "& { (new-object net.webclient).downloadfile('%server_url%%script_name%.bat', '%script_name_bat%') }"
	echo script updated to v%script_latest_ver%^^!
:: user must exit script. current batch is stale.
	goto :end
:script_download_nothing
	goto :eof
:end
	set time_end=%time%
