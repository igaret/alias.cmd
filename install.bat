curl https://raw.githubusercontent.com/izryel/alias.cmd/master/alias.cmd --output %ProgramData%\alias.cmd 
mkdir %systemdrive%\Walls
setx PATH "%PATH%;%SystemDrive%\Walls" /M
set PATH="%PATH%;%SystemDrive%\Walls"
copy  %ProgramData%\alias.cmd %SystemDrive%\Walls\ /y
