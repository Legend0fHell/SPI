@echo off

set SCRIPT="%temp%\SPI_ShortcutGenerator.vbs"
del %SCRIPT%
echo  == SPI EXTRACTION: CREATING SHORTCUT ==
echo [%time%] Initialization.
set path="%~dp0SPI.cmd"
set shortcutPath=%userprofile%\Desktop\SPI.lnk
copy "%~dp0tools\SPI_Backup.lnk" "%shortcutPath%"
echo [%time%] Copied the Shortcut.
echo Set oWS = WScript.CreateObject("WScript.Shell") >>%SCRIPT%
echo sLinkFile = "%shortcutPath%" >>%SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >>%SCRIPT%
echo oLink.IconLocation = "%~dp0tools\SPI.ico" >>%SCRIPT%
echo oLink.TargetPath = %path% >>%SCRIPT%
echo oLink.Arguments = 1 >>%SCRIPT%
echo oLink.Save >>%SCRIPT%
echo [%time%] Created file to modify the content of the Shortcut.
"%windir%\System32\cscript.exe" /nologo %SCRIPT%
echo [%time%] Modified the content of the Shortcut.
del %SCRIPT%
echo [%time%] Deleted file to modify the content of the Shortcut.
echo [%time%] Finalization.
exit