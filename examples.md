clipboard=nircmd clipboard $*
ls=ls --color=always $*
phone=start "" /b "https://textfree.us/#"
forcesysrefresh=taskkill /f /im explorer.exe $t nircmd elevate explorer
tl=tasklist
notepad++="C:\Program Files\Notepad++\notepad++.exe" $*
google=start "" /b "http://www.google.com/search?q=$*"
elevate=nircmd elevate $*
kill=taskkill /f /im $**
chrome=start "" /b "www.google.com"