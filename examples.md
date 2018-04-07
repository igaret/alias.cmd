
ls=ls --color=always $*

forcesysrefresh=taskkill /f /im explorer.exe $t nircmd elevate explorer

tl=tasklist

notepad++="C:\Program Files\Notepad++\notepad++.exe" $*

google=start "" /b "http://www.google.com/search?q=$*"

elevate=nircmd elevate $*

kill=taskkill /f /im $*^*

chrome=start "" /b "www.google.com"

clipboard=nircmd clipboard $*

phone=start "" /b "https://textfree.us/#"
