
forcesysrefresh=taskkill /f /im explorer.exe $t nircmd elevate explorer

tl=tasklist

notepad++="C:\Program Files\Notepad++\notepad++.exe" $*

google=start "" /b "http://www.google.com/search?q=$*"

elevate=nircmd elevate $*

kill=taskkill /f /im $*^*

chrome=start "" /b "www.google.com"

clipboard=nircmd clipboard $*

phone=start "" /b "https://textfree.us/#"

7z="\Program Files\7-Zip\7z.exe" $*

kill=taskkill /f /im $*^*

apt-cyg=bash -c "apt-cyg $*"

winget="C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_1.26.430.0_x64__8wekyb3d8bbwe\winget.exe" $*
    
pwd=echo %cd%

ex=explorer .\

chrome="C:\Program Files\Google\Chrome\Application\chrome.exe" $*

ifconfig=ipconfig $*


