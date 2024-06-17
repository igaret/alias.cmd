<!-- : Begin batch script
@echo off
:: PUSHD "%~dp0"


:: author: Badr Elmers 2021-2024
:: version: 1.1
:: https://github.com/badrelmers/RefrEnv


:: ___USAGE_____________________________________________________________

:: NAME
::    RefrEnv - Refresh the Environment for CMD
::
:: SYNOPSIS
::    call refrenv.bat
:: 
:: DESCRIPTION
::    By default with no arguments, this script will do a full 
::    refresh (refresh all non critical variables*, and refresh the PATH).
::
::    you can use the following variables to change the default behaviour:
::
::    RefrEnv_ResetPath=yes       Reset the actual PATH inside CMD, then refresh
::                                it with a new PATH. This will delete any PATH 
::                                added by the script who called RefrEnv. It is 
::                                equivalent to running a new CMD session.
::
::    RefrEnv_debug=yes           Debug what this script do. The folder containing
::                                the files used to set the variables will be
::                                open, then see _NewEnv.sh, this is the file
::                                which run inside your script to setup the new
::                                variables, you can also revise the intermediate
::                                .txt files.


:: you can also put this script in windows\systems32 or another place in your %PATH% then call it from an interactive console by writing refrenv

:: *critical variables: are variables which belong to cmd/windows and should not be refreshed normally like:
:: - windows vars:
:: ALLUSERSPROFILE APPDATA CommonProgramFiles CommonProgramFiles(x86) CommonProgramW6432 COMPUTERNAME ComSpec HOMEDRIVE HOMEPATH LOCALAPPDATA LOGONSERVER NUMBER_OF_PROCESSORS OS PATHEXT PROCESSOR_ARCHITECTURE PROCESSOR_ARCHITEW6432 PROCESSOR_IDENTIFIER PROCESSOR_LEVEL PROCESSOR_REVISION ProgramData ProgramFiles ProgramFiles(x86) ProgramW6432 PUBLIC SystemDrive SystemRoot TEMP TMP USERDOMAIN USERDOMAIN_ROAMINGPROFILE USERNAME USERPROFILE windir SESSIONNAME


:: ___INFO_____________________________________________________________
:: :: this script reload environment variables inside cmd every time you want environment changes to propagate, so you do not need to restart cmd after setting a new variable with setx or when installing new apps which add new variables ...etc


:: This is a better alternative to the chocolatey refreshenv for cmd, which solves a lot of problems like:

:: The Chocolatey refreshenv is so bad if the variable have some cmd meta-characters, see this test:
    :: add this to the path in HKCU\Environment: test & echo baaaaaaaaaad, and run the chocolatey refreshenv you will see that it prints baaaaaaaaaad which is very bad, and the new path is not added to your path variable.
    :: This script solve this and you can test it with any meta-character, even something so bad like:
    :: ; & % ' ( ) ~ + @ # $ { } [ ] , ` ! ^ | > < \ / " : ? * = . - _ & echo baaaad
    
:: refreshenv adds only system and user environment variables, but CMD adds volatile variables too (HKCU\Volatile Environment). This script will merge all the three and ::ove any duplicates.

:: refreshenv reset your PATH. This script append the new path to the old path of the parent script which called this script. It is better than overwriting the old path, otherwise it will delete any newly added path by the parent script.

:: This script solve this problem described in a comment by @Gene Mayevsky: refreshenv modifies env variables TEMP and TMP replacing them with values stored in HKCU\Environment. In my case I run the script to update env variables modified by Jenkins job on a slave that's running under SYSTEM account, so TEMP and TMP get substituted by %USERPROFILE%\AppData\Local\Temp instead of C:\Windows\Temp. This breaks build because linker cannot open system profile's Temp folder.

:: ________
:: this script solve things like that too:
:: The confusing thing might be that there are a few places to start the cmd from. In my case I run cmd from windows explorer and the environment variables did not change while when starting cmd from the "run" (windows key + r) the environment variables were changed.

:: In my case I just had to kill the windows explorer process from the task manager and then restart it again from the task manager.
:: Once I did this I had access to the new environment variable from a cmd that was spawned from windows explorer.

:: my conclusion:
:: if I add a new variable with setx, i can access it in cmd only if i run cmd as admin, without admin right i have to restart explorer to see that new variable. but running this script inside my script (who sets the variable with setx) solve this problem and i do not have to restart explorer


:: ________
:: windows recreate the path using three places at less:
:: the User namespace:    HKCU\Environment
:: the System namespace:  HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
:: the Session namespace: HKCU\Volatile Environment
:: but the original chocolatey script did not add the volatile path. This script will merge all the three and ::ove any duplicates. this is what windows do by default too

:: there is this too which cmd seems to read when first running, but it contains only TEMP and TMP,so i will not use it
:: HKEY_USERS\.DEFAULT\Environment


:: ___TESTING_____________________________________________________________
:: to test this script with ext::e cases do
    :: :: Set a bad variable
    :: add a var in reg HKCU\Environment as the following, and see that echo is not executed.  if you use refreshenv of chocolatey you will see that echo is executed which is so bad!
    :: so save this in reg:
    :: all 32 characters: & % ' ( ) ~ + @ # $ { } [ ] ; , ` ! ^ | > < \ / " : ? * = . - _ & echo baaaad
    :: and this:
    :: (^.*)(Form Product=")([^"]*") FormType="[^"]*" FormID="([0-9][0-9]*)".*$
    :: and use set to print those variables and see if they are saved without change ; refreshenv fail dramatically with those variables
    
    
:: invalid characters (illegal characters in file names) in Windows using NTFS
:: \ / : * ? "  < > |  and ^ in FAT 



:: __________________________________________________________________________________________
:: __________________________________________________________________________________________
:: __________________________________________________________________________________________
:: this is a hybrid script which call vbs from cmd directly
:: :: The only restriction is the batch code cannot contain - - > (without space between - - > of course)
:: :: The only restriction is the VBS code cannot contain </script>.
:: :: The only risk is the undocumented use of "%~f0?.wsf" as the script to load. Somehow the parser properly finds and loads the running .BAT script "%~f0", and the ?.wsf suffix mysteriously instructs CSCRIPT to interpret the script as WSF. Hopefully MicroSoft will never disable that "feature".
:: :: https://stackoverflow.com/questions/9074476/is-it-possible-to-embed-and-execute-vbscript-within-a-batch-file-without-using-a

if "%RefrEnv_debug%"=="yes" (
    echo RefrEnv - Refresh the Environment for CMD - ^(Debug enabled^)
) else (
    echo RefrEnv - Refresh the Environment for CMD
)

set "TEMPDir=%TEMP%\refrenv"
IF NOT EXIST "%TEMPDir%" mkdir "%TEMPDir%"
set "outputfile=%TEMPDir%\_NewEnv.cmd"


:: detect if DelayedExpansion is enabled
:: It relies on the fact, that the last caret will be ::oved only in delayed mode.
:: https://www.dostips.com/forum/viewtopic.php?t=6496
set "DelayedExpansionState=IsDisabled"
IF "^!" == "^!^" (
    :: echo DelayedExpansion is enabled
    set "DelayedExpansionState=IsEnabled"
)


:: :: generate %outputfile% which contain all the new variables
:: cscript //nologo "%~f0?.wsf" %1
cscript //nologo "%~f0?.wsf" "%outputfile%" %DelayedExpansionState%


:: ::set the new variables generated with vbscript script above
:: for this to work always it is necessary to use DisableDelayedExpansion or escape ! and ^ when using EnableDelayedExpansion, but this script already solve this, so no worry about that now, thanks to God
:: test it with some bad var like:
:: all 32 characters: ; & % ' ( ) ~ + @ # $ { } [ ] , ` ! ^ | > < \ / " : ? * = . - _ & echo baaaad
:: For /f delims^=^ eol^= %%a in (%outputfile%) do %%a
:: for /f "delims== tokens=1,2" %%G in (%outputfile%) do set "%%G=%%H"
For /f delims^=^ eol^= %%a in (%outputfile%) do set %%a


:: for safely print a variable with bad charachters do:
:: SETLOCAL EnableDelayedExpansion
:: echo "!z9!"
:: or
:: set z9
:: but generally paths and environment variables should not have bad metacharacters, but it is not a rule!


if "%RefrEnv_debug%"=="yes" (
    explorer "%TEMPDir%"
) else (
    rmdir /Q /S "%TEMPDir%"
)

:: cleanup
set "TEMPDir="
set "outputfile="
set "DelayedExpansionState="
set "RefrEnv_debug="


:: pause
exit /b



:: #############################################################################
:: :: to run jscript you have to put <script language="JScript"> directly after ----- Begin wsf script --->
----- Begin wsf script --->
<job><script language="VBScript">
:: #############################################################################
:: ### put you code here #######################################################
:: #############################################################################

:: based on itsadok script from here
:: https://stackoverflow.com/questions/171588/is-there-a-command-to-refresh-environment-variables-from-the-command-prompt-in-w

:: and it is faster as stated by this comment
:: While I prefer the Chocolatey code-wise for being pure batch code, overall I decided to use this one, since it's faster. (~0.3 seconds instead of ~1 second -- which is nice, since I use it frequently in my Explorer "start cmd here" entry) – 

:: and it is safer based on my tests, the Chocolatey refreshenv is so bad if the variable have some cmd metacharacters


Const ForReading = 1 
Const ForWriting = 2
Const ForAppending = 8 

Set WshShell = WScript.CreateObject("WScript.Shell")
filename=WScript.Arguments.Item(0)
DelayedExpansionState=WScript.Arguments.Item(1)

TMPfilename=filename & "_temp_.cmd"
Set fso = CreateObject("Scripting.fileSystemObject")
Set tmpF = fso.CreateTextFile(TMPfilename, TRUE)


set oEnvS=WshShell.Environment("System")
for each sitem in oEnvS
    tmpF.WriteLine(sitem)
next
SystemPath = oEnvS("PATH")

set oEnvU=WshShell.Environment("User")
for each sitem in oEnvU
    tmpF.WriteLine(sitem)
next
UserPath = oEnvU("PATH")

set oEnvV=WshShell.Environment("Volatile")
for each sitem in oEnvV
    tmpF.WriteLine(sitem)
next
VolatilePath = oEnvV("PATH")

set oEnvP=WshShell.Environment("Process")
:: i will not save the process env but only its path, because it have strange variables like  =::=::\ and  =F:=.... which seems to be added by vbscript
:: for each sitem in oEnvP
    :: tmpF.WriteLine(sitem)
:: next
:: here we add the actual session path, so we do not reset the original path, because maybe the parent script added some folders to the path, If we need to reset the path then comment the following line
ProcessPath = oEnvP("PATH")

:: merge System, User, Volatile, and possibly process PATHs
If oEnvP("RefrEnv_ResetPath") = "yes" Then
  NewPath = SystemPath & ";" & UserPath & ";" & VolatilePath
Else
  NewPath = SystemPath & ";" & UserPath & ";" & VolatilePath & ";" & ProcessPath
End If



:: ________________________________________________________________
:: :: ::ove duplicates from path
:: :: expand variables so they become like windows do when he read reg and create path, then ::ove duplicates without sorting 
    :: why i will clean the path from duplicates? because:
    :: the maximum string length in cmd is 8191 characters. But string length doesnt mean that you can save 8191 characters in a variable because also the assignment belongs to the string. you can save 8189 characters because the ::aining 2 characters are needed for "a="
   
    :: based on my tests: 
    :: when i open cmd as user , windows does not ::ove any duplicates from the path, and merge system+user+volatil path
    :: when i open cmd as admin, windows do: system+user path (here windows do not ::ove duplicates which is stupid!) , then it adds volatil path after ::oving from it any duplicates 

:: ' https://www.rosettacode.org/wiki/::ove_duplicate_elements#VBScript
Function ::ove_duplicates(list)
	arr = Split(list,";")
	Set dict = CreateObject("Scripting.Dictionary")
    :: ' force dictionary compare to be case-insensitive , uncomment to force case-sensitive
    dict.Compa::ode = 1

	For i = 0 To UBound(arr)
		If dict.Exists(arr(i)) = False Then
			dict.Add arr(i),""
		End If
	Next
	For Each key In dict.Keys
		tmp = tmp & key & ";"
	Next
	::ove_duplicates = Left(tmp,Len(tmp)-1)
End Function
 
:: expand variables
NewPath = WshShell.ExpandEnvironmentStrings(NewPath)
:: ::ove duplicates
NewPath=::ove_duplicates(NewPath)

:: ::ove_duplicates() will add a ; to the end so lets ::ove it if the last letter is ;
If Right(NewPath, 1) = ";" Then 
    NewPath = Left(NewPath, Len(NewPath) - 1) 
End If
  
tmpF.WriteLine("PATH=" & NewPath)
tmpF.Close

:: ________________________________________________________________
:: :: exclude setting variables which may be dangerous to change

    :: when i run a script from task scheduler using SYSTEM user the following variables are the differences between the scheduler env and a normal cmd script, so i will not override those variables
    :: APPDATA=D:\Users\LLED2\AppData\Roaming
    :: APPDATA=D:\Windows\system32\config\systemprofile\AppData\Roaming

    :: LOCALAPPDATA=D:\Users\LLED2\AppData\Local
    :: LOCALAPPDATA=D:\Windows\system32\config\systemprofile\AppData\Local

    :: TEMP=D:\Users\LLED2\AppData\Local\Temp
    :: TEMP=D:\Windows\TEMP

    :: TMP=D:\Users\LLED2\AppData\Local\Temp
    :: TMP=D:\Windows\TEMP

    :: USERDOMAIN=LLED2-PC
    :: USERDOMAIN=WORKGROUP

    :: USERNAME=LLED2
    :: USERNAME=LLED2-PC$

    :: USERPROFILE=D:\Users\LLED2
    :: USERPROFILE=D:\Windows\system32\config\systemprofile

    :: i know this thanks to this comment
    :: The solution is good but it modifies env variables TEMP and TMP replacing them with values stored in HKCU\Environment. In my case I run the script to update env variables modified by Jenkins job on a slave that's running under SYSTEM account, so TEMP and TMP get substituted by %USERPROFILE%\AppData\Local\Temp instead of C:\Windows\Temp. This breaks build because linker cannot open system profile's Temp folder. – Gene Mayevsky Sep 26 '19 at 20:51


:: Delete Lines of a Text File Beginning with a Specified String
:: those are the variables which should not be changed by this script 
arrBlackList = Array("ALLUSERSPROFILE=", "APPDATA=", "CommonProgramFiles=", "CommonProgramFiles(x86)=", "CommonProgramW6432=", "COMPUTERNAME=", "ComSpec=", "HOMEDRIVE=", "HOMEPATH=", "LOCALAPPDATA=", "LOGONSERVER=", "NUMBER_OF_PROCESSORS=", "OS=", "PATHEXT=", "PROCESSOR_ARCHITECTURE=", "PROCESSOR_ARCHITEW6432=", "PROCESSOR_IDENTIFIER=", "PROCESSOR_LEVEL=", "PROCESSOR_REVISION=", "ProgramData=", "ProgramFiles=", "ProgramFiles(x86)=", "ProgramW6432=", "PUBLIC=", "SystemDrive=", "SystemRoot=", "TEMP=", "TMP=", "USERDOMAIN=", "USERDOMAIN_ROAMINGPROFILE=", "USERNAME=", "USERPROFILE=", "windir=", "SESSIONNAME=")

Set objFS = CreateObject("Scripting.FileSystemObject")
Set objTS = objFS.OpenTextFile(TMPfilename, ForReading)
strContents = objTS.ReadAll
objTS.Close

TMPfilename2= filename & "_temp2_.cmd"
arrLines = Split(strContents, vbNewLine)
Set objTS = objFS.OpenTextFile(TMPfilename2, ForWriting, True)

:: this is the equivalent of findstr /V /I /L  or  grep -i -v  , i don t know a better way to do it, but it works fine
For Each strLine In arrLines
    bypassThisLine=False
    For Each BlackWord In arrBlackList
        If Left(UCase(LTrim(strLine)),Len(BlackWord)) = UCase(BlackWord) Then
            bypassThisLine=True
        End If
    Next
    If bypassThisLine=False Then
        objTS.WriteLine strLine
    End If
Next

:: ____________________________________________________________
:: :: expand variables because registry save some variables as unexpanded %....%
:: :: and escape ! and ^ for cmd EnableDelayedExpansion mode

set f=fso.OpenTextFile(TMPfilename2,ForReading)
:: Write file:  ForAppending = 8 ForReading = 1 ForWriting = 2 , True=create file if not exist
set fW=fso.OpenTextFile(filename,ForWriting,True)
Do Until f.AtEndOfStream
    LineContent = f.ReadLine
    :: expand variables
    LineContent = WshShell.ExpandEnvironmentStrings(LineContent)
    
    :: _____this part is so important_____
    :: if cmd delayedexpansion is enabled in the parent script which calls this script then bad thing happen to variables saved in the registry if they contain ! . if var have ! then ! and ^ are ::oved; if var do not have ! then ^ is not ::oved . to understand what happens read this :
    :: how cmd delayed expansion parse things
    :: https://stackoverflow.com/questions/4094699/how-does-the-windows-command-interpreter-cmd-exe-parse-scripts/7970912#7970912
    :: For each parsed token, first check if it contains any !. If not, then the token is not parsed - important for ^ characters. If the token does contain !, then scan each character from left to right:
    ::     - If it is a caret (^) the next character has no special meaning, the caret itself is ::oved
    ::     - If it is an exclamation mark, search for the next exclamation mark (carets are not observed anymore), expand to the value of the variable.
    ::         - Consecutive opening ! are collapsed into a single !
    ::         - Any ::aining unpaired ! is ::oved
    :: ...
    :: Look at next string of characters, breaking before !, :, or <LF>, and call them VAR

    :: conclusion:
    :: when delayedexpansion is enabled and var have ! then i have to escape ^ and ! ,BUT IF VAR DO NOT HAVE ! THEN DO NOT ESCAPE ^  .this made me crazy to discover
    :: when delayedexpansion is disabled then i do not have to escape anything
    
    If DelayedExpansionState="IsEnabled" Then
        If InStr(LineContent, "!") > 0 Then
            LineContent=Replace(LineContent,"^","^^")
            LineContent=Replace(LineContent,"!","^!")
        End If
    End If
    :: __________
    
    fW.WriteLine(LineContent)
Loop

f.Close
fW.Close

:: #############################################################################
:: ### end of vbscript code ####################################################
:: #############################################################################
:: this must be at the end for the hybrid trick, do not ::ove it
</script></job>
