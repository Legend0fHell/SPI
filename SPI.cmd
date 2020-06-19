:: =====================================================================================
::
::                   Restart Internet Connection - Fix Internet Connection [SPI]
::                                  Introductory Header
::
::         FILE: SPI.cmd
::
::  DESCRIPTION: SPI is a script that restart the connection, and also optimizes
::				 your connection by lots of verified methods.
::               
::        USAGE: One-press optimization.
::               Open by the given shortcut.
::
:: REQUIREMENTS: Windows 7 or newer.
::               Services related to Internet connection must be turned on.
::
::       AUTHOR: Pham Nhat Quang [Legend0fHell]
::      VERSION: 4.3.0
::      CREATED: 06.08.‎2016 - ‏‎15:29:37
::     REVISION: 19.06.2020
::
:: =====================================================================================
::
::                                         Notes
::
:: This script is not contain any malicious codes/viruses. All the modules were commented.
:: To improve the optimize speed, this script will use multi-tasking, meaning that there will be several instances running all at once.
:: Debugging is always harder than programming, so if you write code as cleverly as you know how, by definition you will be unable to debug it.
::
:: =====================================================================================
::
::                                       Changelog
::
::    Version 4.3.0 [04.06.2020]
::  * ADD:
:: - Easier way to check the latency.
:: - Shortcut Generator.
:: - Proper Icon file.
::  * CHANGES:
:: - GUI Header.
::
:: =====================================================================================

:: Set console.
:: /************************************************************************************/
:main.mode
	@echo off
	CHCP 1258 >nul 2>&1
	CHCP 65001 >nul 2>&1
	setlocal EnableExtensions EnableDelayedExpansion
	set ver=4.3.0
	set verdate=Jun 19 2020
	set configLineSkip=61
	color 0e
:: /************************************************************************************/


:: Set the default config.
:: /************************************************************************************/
:config.default
	set width=90
	set height=35
	set lang=2
	set colorPrompt=E
	set colorWorking=A
	set autoChoose=30
	set checkPingEnable=1
	set pingURL=facebook.com
	set dns1=1.1.1.1
	set dns2=1.0.0.1
	set promptUseEnable=1
	set customHosts=0
	set operateMode=0
	set browsersFound=0
	set connectionStatusLength=0
	set PingLength=0
	set end=10
:: /************************************************************************************/


:: Check if the config files is valid.
:: /************************************************************************************/
:config.checkVaild
	:: Create a referrence version file to validate the config file.
	(
		echo # Setting the config wrong can cause the script to crash. Do not change configVersion.
		echo # If the script crash, try deleting this config file.
		echo configVersion=!ver!-!verdate!
	) >"%temp%\ver.txt"
	set configDir=%~dp0config.txt
	:: Check the existance of the config file. Compare with the referrence file.
	:: If the config file is found and valid go to set the config else recreate it.
	if exist !configDir! (
		set existConfig=1
		echo N | comp /n=3 "!temp!\ver.txt" "!configDir!" | findstr /i "OK" && call :config.set
	) else (
		set existConfig=0
	)
	call :config.update
	call :main.setVariables
	goto main.checkVer
:: /************************************************************************************/


:: Set the variables needed.
:: /************************************************************************************/
:main.setVariables
	mode con cols=!width! lines=!height!
	title SPI ^| Restart Internet Connection - Fix Internet Connection
	set "valuecore="
	set "core="
	set "linesCore= "
	for /l %%G in (!width!,-1,1) do (
		set valuecore=!valuecore! 
		set core=!core!=
	)
	for /l %%G in (!width!,-1,3) do (
		set linesCore=!linesCore!_
	)
	set space=!valuecore!
	set widthTemp=!width!
	set label=Starting&call :main.label 8
	set internetStatus=1
	set now=-1
	set /a length=!end! * (!width! / (!end!+2))
	set /a left=(!width!-!length!)/2-1
	set /a between=!width!-8-(!left!*2)
	set /a endprog=10000/!end!
	set /a char=!length!/!end!
	set counter=0
	set counterb=000
	set noPhaseChanged=0
	set failedPingCheck=0
	set showInfo=0
	set retryTime=0
goto :EOF
:: /************************************************************************************/


:: Check the OS version.
:: /************************************************************************************/
:main.checkVer
	ver | findstr /i "6\.1\." > nul
	if %ERRORLEVEL% EQU 0 (
		set ChOS=Windows 7
		set OSAllowed=1
	)
	ver | findstr /i "6\.2\." > nul
	if %ERRORLEVEL% EQU 0 (
		set ChOS=Windows 8
		set OSAllowed=1
	)
	ver | findstr /i "6\.3\." > nul
	if %ERRORLEVEL% EQU 0 (
		set ChOS=Windows 8.1
		set OSAllowed=1
	)
	ver | findstr /i "10\.0\." > nul
	if %ERRORLEVEL% EQU 0 (
		set ChOS=Windows 10
		set OSAllowed=1
	)
	if %OSAllowed% NEQ 1 (
		cls
		set label=Failed&call :main.label 6
		echo  You MUST use Windows 7 or newer versions so that the script can work properly.
		echo  Supported System: Windows 7, 8, 8.1, 10. Windows Server is NOT RECOMMENDED.
		echo  Press any key to exit.
		echo.
		set label=That bai&call :main.label 8
		echo  Ban PHAI sử dụng Windows 7 hoac phien ban moi hon đe su dung dung cu.
		echo  Ho tro: Windows 7, 8, 8.1, 10. KHONG KHUYEN NGHI su dung Windows Server.
		echo  Nhan phim bat ky de thoat.
		pause >nul
		exit
	)
:: /************************************************************************************/


:: Check if users run the Script via the given Shortcut.
:: /************************************************************************************/
:main.checkShortcut
	:: Find the argument "1" when opening the file. This is to check if the script was run by the given shortcut.
	echo %1 | findstr "1" >nul
	if %errorlevel%==1 (
		if %lang%==2 del /f /s config.txt >nul
		cls
		set label=Failed&call :main.label 6
		echo  You MUST run this Script via the given Shortcut in order for it to work.
		echo  Press any key to exit.
		echo.
		set label=That bai&call :main.label 8
		echo  Ban PHAI chay cong cu nay bang Loi tat ^(Shortcut^) da cho de cong cu hoat dong.
		echo  Nhan phim bat ky de thoat.
		pause >nul
		exit
	)
	:: Checking things.
	call :main.preloadPS
	if %lang%==1 (echo  [%time%] Đang chạy trước PowerShell...) else (echo  [%time%] Preloading PowerShell...)
	if %lang%==1 (echo  [%time%] Đang kiểm tra kết nối mạng...) else (echo  [%time%] Checking the Internet connection...)
	call :main.checkConnection 1
	if %lang%==1 (echo  [%time%] Đang kiểm tra trình duyệt...) else (echo  [%time%] Checking the browsers...)
	call :main.checkBrowsers
	set connectionStatusLengthBackup=!connectionStatusLength!
	set failedPingCheckBackup=!failedPingCheck!
	goto config.detectFirstRun
:: /************************************************************************************/


:: Set the custom config.
:: /************************************************************************************/
:config.set
	for /f delims^=^ eol^=# %%i in ('findstr "=" config.txt') do (set "%%i") >nul
	if %customHosts%==1 (
		del /f /q %temp%\customHosts.txt >nul
		for /f "delims= skip=%configLineSkip%" %%i in (config.txt) do (
			echo %%i>>"%temp%\customHosts.txt"
		)
	)
goto :EOF
:: /************************************************************************************/


:: Update the config with new settings or restart it.
:: /************************************************************************************/
:config.update
	if !existConfig!==1 call :config.set
	(
		echo # Setting the config wrong can cause the script to crash. Do not change configVersion.
		echo # If the script crash, try deleting this config file.
		echo configVersion=!ver!-!verdate!
		echo.
		echo [Script Settings]
		echo # Change the Width of the Console. [Default: 90 - For the best appearance] [Min: 80] [Character]
		echo width=!width!
		echo.
		echo # Change the Height of the Console. [Default: 35] [Min: 35] [Character]
		echo height=!height!
		echo.
		echo # Auto-Select or Prompt the Languages. [Default: Ask] [0-English / 1-Vietnamese / 2-Ask]
		echo lang=!lang!
		echo.
		echo # Change the Prompt Color. See Color Table for details. [Default: E] [1-9 / A-F]
		echo colorPrompt=!colorPrompt!
		echo.
		echo # Change the Working Color. See Color Table for details. [Default: A] [1-9 / A-F]
		echo colorWorking=!colorWorking!
		echo.
		echo [Color Table]
		echo.
		echo # ColorCode  ColorName             ColorCode  ColorName
		echo # ---------  ------------          ---------  ------------
		echo # 1          Blue                  9          Light Blue
		echo # 2          Green                 A          Light Green
		echo # 3          Aqua                  B          Light Aqua
		echo # 4          Red                   C          Light Red
		echo # 5          Purple                D          Light Purple
		echo # 6          Yellow                E          Light Yellow
		echo # 7          White                 F          Bright White
		echo # 8          Gray
		echo.
		echo [Progress Settings]
		echo.
		echo # Change the auto-choose interval. [Default: 30] [0-9999] [Seconds]
		echo autoChoose=!autoChoose!
		echo.
		echo # Enable or Disable the Latency Checking. [Default: 1] [0-Disable / 1-Enable]
		echo checkPingEnable=!checkPingEnable!
		echo.
		echo # Change the URL to Check the Latency. [Default: facebook.com] [Valid URL] [URL/IP]
		echo pingURL=!pingURL!
		echo.
		echo # Change the DNS that the script will use. There are 2 addresses, Primary[1] and Secondary[2] DNS.
		echo # [Default: 1.1.1.1 / 1.0.0.1 - CloudFlare] [Vaild DNS] [IPv4]
		echo dns1=!dns1!
		echo dns2=!dns2!
		echo.
		echo # Prompt to use the Script. [Default: 1] [0-Disable / 1-Enable]
		echo promptUseEnable=!promptUseEnable!
		echo.
		echo [Hosts File Settings]
		echo.
		echo # Allow your custom addresses to be added to your Hosts file. [Default: 0] [0-Permit / 1-Allow]
		echo customHosts=!customHosts!
		echo.
		echo # These addresses will be added to your Hosts file to stop Telemetry.
		echo # To add your custom addresses, you must allow customHosts by the above settings.
		echo.
	) >config.txt
	:: Set the default addresses in the config file. If customHosts is 1, it will skip setting the default addresses.
	if %customHosts%==1 (
		type %temp%\customHosts.txt >>config.txt
	) else (
		(
			echo 184-86-53-99.deploy.static.akamaitechnologies.com
			echo a-0001.a-msedge.net
			echo a-0002.a-msedge.net
			echo a-0003.a-msedge.net
			echo a-0004.a-msedge.net
			echo a-0005.a-msedge.net
			echo a-0006.a-msedge.net
			echo a-0007.a-msedge.net
			echo a-0008.a-msedge.net
			echo a-0009.a-msedge.net
			echo a1621.g.akamai.net
			echo a1856.g2.akamai.net
			echo a1961.g.akamai.net
			echo a248.e.akamai.net
			echo a978.i6g1.akamai.net
			echo a.ads1.msn.com
			echo a.ads2.msads.net
			echo a.ads2.msn.com
			echo ac3.msn.com
			echo ad.doubleclick.net
			echo adnexus.net
			echo adnxs.com
			echo ads1.msads.net
			echo ads1.msn.com
			echo ads.msn.com
			echo aidps.atdmt.com
			echo aka-cdn-ns.adtech.de
			echo a-msedge.net
			echo any.edge.bing.com
			echo a.rad.msn.com
			echo az361816.vo.msecnd.net
			echo az512334.vo.msecnd.net
			echo b.ads1.msn.com
			echo b.ads2.msads.net
			echo bingads.microsoft.com
			echo b.rad.msn.com
			echo bs.serving-sys.com
			echo c.atdmt.com
			echo cdn.atdmt.com
			echo cds26.ams9.msecn.net
			echo choice.microsoft.com
			echo choice.microsoft.com.nsatc.net
			echo compatexchange.cloudapp.net
			echo corpext.msitadfs.glbdns2.microsoft.com
			echo corp.sts.microsoft.com
			echo cs1.wpc.v0cdn.net
			echo db3aqu.atdmt.com
			echo df.telemetry.microsoft.com
			echo diagnostics.support.microsoft.com
			echo e2835.dspb.akamaiedge.net
			echo e7341.g.akamaiedge.net
			echo e7502.ce.akamaiedge.net
			echo e8218.ce.akamaiedge.net
			echo ec.atdmt.com
			echo fe2.update.microsoft.com.akadns.net
			echo feedback.microsoft-hohm.com
			echo feedback.search.microsoft.com
			echo feedback.windows.com
			echo flex.msn.com
			echo g.msn.com
			echo h1.msn.com
			echo h2.msn.com
			echo hostedocsp.globalsign.com
			echo i1.services.social.microsoft.com
			echo i1.services.social.microsoft.com.nsatc.net
			echo ipv6.msftncsi.com
			echo ipv6.msftncsi.com.edgesuite.net
			echo lb1.www.ms.akadns.net
			echo live.rads.msn.com
			echo m.adnxs.com
			echo msedge.net
			echo msftncsi.com
			echo msnbot-65-55-108-23.search.msn.com
			echo msntest.serving-sys.com
			echo oca.telemetry.microsoft.com
			echo oca.telemetry.microsoft.com.nsatc.net
			echo onesettings-db5.metron.live.nsatc.net
			echo pre.footprintpredict.com
			echo preview.msn.com
			echo rad.live.com
			echo rad.msn.com
			echo redir.metaservices.microsoft.com
			echo reports.wes.df.telemetry.microsoft.com
			echo schemas.microsoft.akadns.net
			echo secure.adnxs.com
			echo secure.flashtalking.com
			echo services.wes.df.telemetry.microsoft.com
			echo settings-sandbox.data.microsoft.com
			echo settings-win.data.microsoft.com
			echo sls.update.microsoft.com.akadns.net
			echo sqm.df.telemetry.microsoft.com
			echo sqm.telemetry.microsoft.com
			echo sqm.telemetry.microsoft.com.nsatc.net
			echo ssw.live.com
			echo static.2mdn.net
			echo statsfe1.ws.microsoft.com
			echo statsfe2.update.microsoft.com.akadns.net
			echo statsfe2.ws.microsoft.com
			echo survey.watson.microsoft.com
			echo telecommand.telemetry.microsoft.com
			echo telecommand.telemetry.microsoft.com.nsatc.net
			echo telemetry.appex.bing.net
			echo telemetry.microsoft.com
			echo telemetry.urs.microsoft.com
			echo vortex-bn2.metron.live.com.nsatc.net
			echo vortex-cy2.metron.live.com.nsatc.net
			echo vortex.data.microsoft.com
			echo vortex-sandbox.data.microsoft.com
			echo vortex-win.data.microsoft.com
			echo cy2.vortex.data.microsoft.com.akadns.net
			echo watson.live.com
			echo watson.microsoft.com
			echo watson.ppe.telemetry.microsoft.com
			echo watson.telemetry.microsoft.com
			echo watson.telemetry.microsoft.com.nsatc.net
			echo wes.df.telemetry.microsoft.com
			echo win10.ipv6.microsoft.com
			echo www.bingads.microsoft.com
			echo www.go.microsoft.akadns.net
			echo www.msftncsi.com
			echo client.wns.windows.com
			echo wdcpalt.microsoft.com
			echo settings-ssl.xboxlive.com
			echo settings-ssl.xboxlive.com-c.edgekey.net
			echo settings-ssl.xboxlive.com-c.edgekey.net.globalredir.akadns.net
			echo e87.dspb.akamaidege.net
			echo insiderservice.microsoft.com
			echo insiderservice.trafficmanager.net
			echo e3843.g.akamaiedge.net
			echo flightingserviceweurope.cloudapp.net
			echo static.ads-twitter.com
			echo www-google-analytics.l.google.com
			echo p.static.ads-twitter.com
			echo hubspot.net.edge.net
			echo e9483.a.akamaiedge.net
			echo www.google-analytics.com
			echo padgead2.googlesyndication.com
			echo mirror1.malwaredomains.com
			echo mirror.cedia.org.ec
			echo hubspot.net.edgekey.net
			echo insiderppe.cloudapp.net
			echo livetileedge.dsx.mp.microsoft.com
			echo fe2.update.microsoft.com.akadns.net
			echo s0.2mdn.net
			echo statsfe2.update.microsoft.com.akadns.net
			echo survey.watson.microsoft.com
			echo view.atdmt.com
			echo watson.microsoft.com
			echo watson.ppe.telemetry.microsoft.com
			echo watson.telemetry.microsoft.com
			echo watson.telemetry.microsoft.com.nsatc.net
			echo wes.df.telemetry.microsoft.com
			echo apps.skype.com
			echo c.msn.com
			echo pricelist.skype.com
			echo s.gateway.messenger.live.com
			echo ui.skype.com
		) >>config.txt
	)
	if !existConfig! NEQ 2 call :config.set
goto :EOF
:: /************************************************************************************/


:: Ask the users the language they are going to use.
:: /************************************************************************************/
:config.languageSelect
	cls
	set label=Select Language&call :main.label 15
	echo  1/ If something went wrong (the script automatically runs, etc. ),
	echo     close this windows, delete "config.txt" in this folder and run this
	echo     script via the given Shortcut.
	echo  2/ You can create a Shortcut via the option in Additional Tools.
	echo  3/ Make sure this script's directory DOES NOT CONTAIN any Unicode characters:
	echo     %~dp0
	echo  4/ Automatically choose English in !autoChoose! second[s].
	echo.
	set label=Chọn Ngôn ngữ&call :main.label 13
	echo  1/ Nếu xảy ra lỗi (công cụ tự động chạy,...), tắt cửa sổ này, xóa "config.txt"
	echo     trong thư mục này và mở công cụ bằng Lối dẫn (Shortcut) đã cho.
	echo  2/ Bạn có thể tạo Lối dẫn (Shortcut) bằng lựa chọn trong mục Công cụ Bổ sung.
	echo  3/ Đảm bảo đường dẫn của công cụ KHÔNG CHỨA những ký tự Unicode (chữ Việt,...)
	echo     %~dp0
	echo  4/ Tự động chọn Tiếng Anh sau !autoChoose! giây.
	set /a blankLines=!height!-20
	call :main.blankLines !blankLines!
	echo !linesCore!
	echo  Press the corresponding key of the language. ^| Nhấn phím thích hợp của ngôn ngữ.
	choice /c ve /n /t !autoChoose! /d e /m " [E] English  [V] Tiếng Việt"
	set /a lang-=%errorlevel%
	set existConfig=2
	call :config.update
	goto main.setGUI
:: /************************************************************************************/


:: Check the connection.
:: /************************************************************************************/
:main.checkConnection
	:: Mode 0 = Checking just for connection.
	:: Mode 1 = Checking the connection and the latency.
	ping -n 1 !dns1! | findstr TTL >nul && set "internetStatus=1" || set internetStatus=0
	if %1 == 1 (
		if %checkPingEnable%==1 (
			call :progress.checkLatency1
			if !failedPingCheck! == 1 (
				if !lang! == 0 (
					if !internetStatus! == 0 (
						set connectionStatus=No connection found.
						set connectionStatusLength=20
					) else (
						set connectionStatus=Connection timed out.
						set connectionStatusLength=21
					)
				) else (
					if !internetStatus! == 0 (
						set connectionStatus=Không có kết nối.
						set connectionStatusLength=17
					) else (
						set connectionStatus=Quá thời gian kết nối.
						set connectionStatusLength=22
					)
				)
			) else (
				set PingBefore2=!PingBefore!
				call :sub.findPingLength
				set /a connectionStatusLength=!PingLength!+2
				set connectionStatus=!PingBefore!ms
			)
		) else (
			if !lang! == 0 (
				set connectionStatus=Feature disabled.
				set connectionStatusLength=17
			) else (
				set connectionStatus=Tính năng bị vô hiệu hóa.
				set connectionStatusLength=25
			)
		)
	)
goto :EOF
:: /************************************************************************************/


:: Find the length of the latency.
:: /************************************************************************************/
:sub.findPingLength
	if !pingBefore2!==0 (
		goto :EOF
	) else (
		set /a PingLength+=1
		set /a PingBefore2=!PingBefore2!/10
		goto sub.findPingLength
	)
:: /************************************************************************************/


:: Preload PowerShell.
:: /************************************************************************************/
:main.preloadPS
	start "SPI | Preload PowerShell" /MIN cmd /c powershell -Command "& {exit;}"
goto :EOF
:: /************************************************************************************/


:: Check the appearance of browsers. If the script detects them, it will prompt the users.
:: /************************************************************************************/
:main.checkBrowsers
	FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq chrome.exe"') DO IF %%x == chrome.exe set browsersFound=1
	FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq firefox.exe"') DO IF %%x == firefox.exe set browsersFound=1
	FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq opera.exe"') DO IF %%x == opera.exe set browsersFound=1
	FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq msedge.exe"') DO IF %%x == msedge.exe set browsersFound=1
	FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq vivaldi.exe"') DO IF %%x == vivaldi.exe set browsersFound=1
	FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq thunderbird.exe"') DO IF %%x == thunderbird.exe set browsersFound=1
goto :EOF
:: /************************************************************************************/


:: Backup files before the script changes anything.
:: /************************************************************************************/
:main.backup
	:: Create Backup Info File.
	(
		echo # This is the directory that SPI made to store the backup.
		echo # Backup created at !time! !date!
		echo backupCreateTime=!time! !date!
	) > "backup\backupInfo.txt"
	
	:: Backup Hosts file.
	copy "%WINDIR%\system32\drivers\etc\hosts" "backup\hosts"
	
	:: Reading the ipconfig setting

	for /f "tokens=* delims={}" %%i in ('wmic nicconfig get DNSServerSearchOrder ^| findstr "{"') do (
		set backupDNSOutput=%%i
		(echo backup_DNS=!backupDNSOutput:}=!) >> "backup\backupFile"
	)
goto :EOF
:: /************************************************************************************/


:: Check if this is the first time the script is opened on the users' PC.
:: /************************************************************************************/
:config.detectFirstRun
	if %lang%==2 goto config.languageSelect
	goto main.setGUI
:: /************************************************************************************/


:: Calculate the execution time of an activity.
:: /************************************************************************************/
:main.timer
	set options="tokens=1-4 delims=:.,"
	for /f %options% %%a in ("%timerStart%") do set timerStart_h=%%a&set /a timerStart_m=100%%b %% 100&set /a timerStart_s=100%%c %% 100&set /a timerStart_ms=100%%d %% 100
	for /f %options% %%a in ("%timerEnd%") do set timerEnd_h=%%a&set /a timerEnd_m=100%%b %% 100&set /a timerEnd_s=100%%c %% 100&set /a timerEnd_ms=100%%d %% 100
	set /a hours=%timerEnd_h%-%timerStart_h%
	set /a mins=%timerEnd_m%-%timerStart_m%
	set /a secs=%timerEnd_s%-%timerStart_s%
	set /a ms=%timerEnd_ms%-%timerStart_ms%
	if %ms% lss 0 set /a secs-=1 & set /a ms = 100%ms%
	if %secs% lss 0 set /a mins-=1 & set /a secs = 60%secs%
	if %mins% lss 0 set /a hours-=1 & set /a mins = 60%mins%
	if %hours% lss 0 set /a hours = 24%hours%
	if 1%ms% lss 100 set ms=0%ms%
	set /a totalsecs = %hours%*3600 + %mins%*60 + %secs%
goto :EOF
:: /************************************************************************************/


:: Echo the given blank lines. This is GUI-based.
:: /************************************************************************************/
:main.blankLines
	for /l %%G in (1,1,%1) do echo.
goto :EOF
:: /************************************************************************************/


:: Print the labels.
:: /************************************************************************************/
:main.label
	set /a leftLabel=(%widthTemp%-%1-34)/2
	echo !space:~0,%leftLabel%! +============== %label% ==============+
goto :EOF
:: /************************************************************************************/


:: Print the header and title.
:: /************************************************************************************/
:main.header
	cls
	echo  %title%
	echo  %subtitle%
	echo %core%
goto :EOF
:: /************************************************************************************/


:: Print the progress bar and custom title.
:: /************************************************************************************/
:main.showProgress
	if %noPhaseChanged%==1 (
		set now=-1
		set counterb=000
		set valuecore=%space%
	)
	set color=%2
	if %color%==2 (color 0%colorPrompt%) else (color 0%colorWorking%)
	call :main.header
	echo  %progress%: !progress[%3]! - %1
	set /a now+=1
	if %now%==10 set /a between-=1
	if %counterb% LSS 1000 (set percent=  %counterb:~0,-2%) else if %counterb% LSS 10000 (set percent= %counterb:~0,-2%) else if %counterb%==10000 (set percent=%counterb:~0,-2%)
	echo !space:~0,%left%![!valuecore:~0,%length%!]
	echo !space:~0,%left%!%now%/%end%!space:~0,%between%!%percent%%%
	title SPI ^| %counterb:~0,-2%%% %now%/%end% ^| !progress[%3]! - %1
	set /a counter+=%char%
	if %noPhaseChanged%==0 (
		set /a counterb+=%endprog%
		set valuecore=!core:~0,%counter%!%space%
	)
	if %noPhaseChanged%==2 (
		set /a now-=1
		set /a counter-=%char%
	)
	echo.
goto :EOF
:: /************************************************************************************/


:: Set the Internet Status Info on the title of the script.
:: /************************************************************************************/
:main.setInternetStatus
	set /a alignTitle=!width!-2-27-12-!connectionStatusLength!
	set title=Restart Internet Connection!space:~0,%alignTitle%!Connection: !connectionStatus!
	set /a alignSubtitle=!width!-36-38
	set noInternet=Please check your Internet connection.
	if !lang!==1 (
		set /a alignTitle=!width!-30-9-!connectionStatusLength!
		set title=Khởi động lại Kết nối Internet!space:~0,%alignTitle%!Kết nối: !connectionStatus!
		set /a alignSubtitle=!width!-36-30
		set noInternet=Hãy kiểm tra kết nối Internet.
	)
	if !failedPingCheck!==0 (set subtitle=Legend0fHell - %ver% - %verdate%) else (set subtitle=Legend0fHell - %ver% - %verdate%!space:~0,%alignSubtitle%!!noInternet!)
goto :EOF
:: /************************************************************************************/


:: Set GUI elements.
:: /************************************************************************************/
:main.setGUI
	title SPI ^| Restart Internet Connection - Fix Internet Connection
	set optYn= [Y] Accept  [N] Decline
	set optYnC= [Y] Restart  [O] Optimize  [T] Additional Tools  [I] Show Info
	set optCS= [Y] Close  [N] Skip
	set optOC= [O] Open  [C] Close
	set autoAcceptMsg= Automatically choose Restart in %autoChoose% second[s].
	set autoDeclineMsg= Automatically decline in %autoChoose% second[s].
	set splitTitle=Multi-Task
	set progress[1]=Checks
	set progress[2]=TCP/IP Settings
	set progress[3]=Browsers Tweaks
	set progress[4]=Telemetry Settings
	set progress[5]=Explorer Settings
	set progress[6]=OneDrive Settings
	set progress[7]=Adapters Settings
	set progress[8]=Status
	set progress[9]=Registry Settings
	set progress=Progress
	set guideMsg= Press the corresponding key of the tool.
	set "titleMoreTool=SPI ^| Additional Tools"
	if !lang!==1 (
		title SPI ^| Khởi động lại Kết nối Internet - Sửa Kết nối Internet
		set optYn= [Y] Đồng ý  [N] Từ chối
		set optYnC= [Y] Khởi động lại  [O] Tối ưu  [T] Công cụ Bổ sung  [I] Hiện Thông tin
		set optCS= [Y] Đóng  [N] Bỏ qua
		set optOC= [O] Mở  [C] Đóng
		set autoAcceptMsg= Tự động chọn Khởi động lại trong %autoChoose% giây.
		set autoDeclineMsg= Tự động từ chối trong %autoChoose% giây.
		set splitTitle=Tách
		set progress[1]=Kiểm tra
		set progress[2]=Cài đặt TCP/IP
		set progress[3]=Cài đặt Trình duyệt
		set progress[4]=Cài đặt Telemetry
		set progress[5]=Cài đặt Explorer
		set progress[6]=Cài đặt OneDrive
		set progress[7]=Cài đặt Adapter
		set progress[8]=Trạng thái
		set progress[9]=Cài đặt Registry
		set progress=Tiến trình
		set "titleMoreTool=SPI ^| Công cụ Bổ sung"
		set guideMsg= Nhấn phím thích hợp của công cụ muốn chọn.
	)
	call :main.setInternetStatus
	
	if %promptUseEnable%==0 (
		call :main.showProgress "Ready" 2 8
		goto main.preSetting
	)
:: /************************************************************************************/


:: Ask if users want to use this script and other guides.
:: /************************************************************************************/
:main.confirmUse
	if !lang!==0 (
		call :main.showProgress "Ready" 2 8
		echo  Restart Internet Connection [SPI] is a script that restarts your connection.
		echo.
		echo  Using this will interrupt your Internet connection for a very short time.
		echo  THIS SCRIPT WILL NOT REVERSE CHANGES. Use this script at your OWN RISKS.
	) else (
		call :main.showProgress "Sẵn sàng" 2 8
		echo  Khởi động lại Kết nối Internet [SPI] là công cụ khởi động lại đường truyền của bạn.
		echo.
		echo  Sử dụng công cụ này sẽ ngắt kết nối Internet của bạn trong thời gian rất ngắn.
		echo  CÔNG CỤ KHÔNG ĐẢO NGƯỢC NHỮNG THAY ĐỔI. Bạn CHỊU TRÁCH NHIỆM khi dùng công cụ.
	)
	set /a blankLines=!height!-16
	:: Echo this if showInfo is 1.
	if %showInfo%==1 (
		echo.
		if !lang!==0 (
			echo  This script will restart Internet connection by doing the following works:
			echo         + Flush DNS, release and renew IP.
			echo         + Delete unnecessary files.
			echo         + Run SpeedyFox - a safe browsers optimization tool.
			echo         + Restart networks adapters.
			echo  This script will optimize Internet connection by doing the following works:
			echo         + Configurate TCP/IP/DNS.
			echo         + Change Telemetry Settings, stop sending data to Microsoft.
			echo         + Uninstall OneDrive/OneNote, modify Explorer.
			echo         + Change Registry settings, Hosts file, and network adapters.
			echo         + Settings that reduce ping on many games: PUBG, CS:GO, LoL, etc.
		) else (
			echo  Công cụ này sẽ khởi động lại kết nối Internet bằng các việc sau:
			echo         + Xả DNS, làm mới IP.
			echo         + Xóa bỏ những file thừa, file rác.
			echo         + Chạy SpeedyFox - công cụ tối ưu hóa trình duyệt an toàn.
			echo         + Khởi động lại các adapter mạng.
			echo  Công cụ này sẽ tối ưu tốc độ Internet bằng các việc sau:
			echo         + Thay đổi cài đặt TCP/IP/DNS.
			echo         + Thay đổi cài đặt Telemetry, chặn dữ liệu tới Microsoft.
			echo         + Gỡ cài đặt OneDrive/OneNote, chỉnh sửa Explorer.
			echo         + Thay đổi cài đặt trong Registry, file Hosts, và các adapter mạng.
			echo         + Các thiết đặt giảm độ trễ cho rất nhiều game: PUBG, CS:GO, LoL, v.v.
		)
		set /a blankLines-=12
	)
	call :main.blankLines !blankLines!
	echo !linesCore!
	echo %guideMsg% ^|%autoAcceptMsg%
	choice /c ytio /n /t %autoChoose% /d y /m "%optYnC%"
		if %errorlevel%==1 goto main.preSetting
		if %errorlevel%==2 (
			set errorMoreTool=.
			goto main.moreTools
		)
		if %errorlevel%==3 (
			if %showInfo%==0 (
				set showInfo=1
				if !lang! == 0 (
					set optYnC= [Y] Restart  [O] Optimize  [T] Additional Tools  [I] Hide Info
				) else (
					set optYnC= [Y] Khởi động lại  [O] Tối ưu  [T] Công cụ Bổ sung  [I] Ẩn Thông tin
				)
			) else (
				set showInfo=0
				if !lang! == 0 (
					set optYnC= [Y] Restart  [O] Optimize  [T] Additional Tools  [I] Show Info
				) else (
					set optYnC= [Y] Khởi động lại  [O] Tối ưu  [T] Công cụ Bổ sung  [I] Hiện Thông tin
				)
			)
			set noPhaseChanged=1
			goto main.confirmUse
		)
		if %errorlevel%==4 (
			set operateMode=1
			goto main.preSetting
		)
:: /************************************************************************************/


:: Contain additional Batch tools related to Internet connection.
:: /************************************************************************************/
:main.moreTools
	IF not exist output\ mkdir output
	cls
	call :main.header
	title %titleMoreTool%
	set /a blankLines=!height!-34
	if !lang!==0 (
		set label=Additional Tools&call :main.label 16
		echo.
		echo  Additional Batch Tools
		echo  -----------------------
		echo    [1] Show your Public IP, Private IP and MAC Address.
		echo    [2] Trace the Location of a Website or an IP.
		echo    [3] Show Your Saved Wi-Fi Passwords.
		echo    [4] Show Your Firewall Rules.
		echo    [5] Show All Active/Used IP Addresses on Your Network.
		echo.
		echo  Shortcut
		echo  -----------------------
		echo    [6] Ping to a Website or an IP.
		echo    [7] Open Tracert.
		echo    [8] Open PathPing.
		echo    [9] Open "Network Connection" Window.
		echo    [10] Open NetStat.
		echo.
		echo  Script-Related
		echo  -----------------------
		echo    [11] Chuyển sang Giao diện Tiếng Việt.
		echo    [12] Reset the Configurations to Default state.
		echo    [13] Generate a Shortcut to the Desktop.
		echo    [14] Restart the Script.
		echo    [15] Exit this Page.
		echo!errorMoreTool!
		call :main.blankLines !blankLines!
		echo !linesCore!
		echo  Enter the corresponding number of the tool you want to use.
	) else (
		set label=Công cụ Bổ sung&call :main.label 15
		echo.
		echo  Công cụ Batch Bổ sung
		echo  -----------------------
		echo    [1] Hiện IP Công cộng, IP Riêng tư và Địa chỉ MAC.
		echo    [2] Tìm Vị trí của một Website hoặc một IP.
		echo    [3] Hiện Mật khẩu Wi-Fi đã lưu.
		echo    [4] Hiện Thiết đặt Tường lửa.
		echo    [5] Hiện Tất cả IP Hoạt động/Đã dùng trong Hệ thống Mạng của bạn.
		echo.
		echo  Phím tắt
		echo  -----------------------
		echo    [6] Ping đến một Website hoặc một IP.
		echo    [7] Mở Tracert.
		echo    [8] Mở PathPing.
		echo    [9] Mở Cửa sổ "Network Connection".
		echo    [10] Mở NetStat.
		echo.
		echo  Liên quan tới Công cụ
		echo  -----------------------
		echo    [11] Switch to English Interface.
		echo    [12] Khôi phục Cài đặt Gốc.
		echo    [13] Tạo một Lối dẫn tới Desktop.
		echo    [14] Khởi động lại Công cụ.
		echo    [15] Thoát khỏi Trang này.
		echo!errorMoreTool!
		call :main.blankLines !blankLines!
		echo !linesCore!
		echo  Nhấn số thích hợp ở công cụ bạn muốn sử dụng.
	)
	set /p "addOpt= [1-15]: "
	cls
	call :main.header
	if !lang!==0 (
		title %titleMoreTool% ^| Selected Tool: !addOpt!.
		echo  Selected tool: !addOpt!.
		echo  Running tool... This will take a while.
	) else (
		title %titleMoreTool% ^| Đã chọn Công cụ: !addOpt!.
		echo  Đã chọn công cụ: !addOpt!.
		echo  Đang chạy công cụ... Điều này sẽ mất một khoảng thời gian.
	)
	echo.
	setlocal EnableDelayedExpansion
	if !addOpt!==1 (
		if !lang!==0 (echo  Estimated Time: ~15 seconds.) else (echo  Thời gian dự tính: ~15 giây.)
		echo.
		set timerStart=!time!
		:: Find the Public IP by nslookup the following site.
		for /f "skip=1 tokens=2 delims=: " %%G in ('nslookup myip.opendns.com. resolver1.opendns.com ^| findstr /C:"Address"') do (
			set PubIP=%%G
		)
		for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do (
			set PriIP=%%a
		)
		set timerEnd=!time!
		call :main.timer
		if !lang!==0 (
			echo  Your MAC Address Information:
			getmac
			echo.
			echo  Your Current Public IP: !PubIP!
			echo  Your Current Private IP: !PriIP!
			echo.
			echo  Success. [!totalsecs!.!ms! seconds]
		) else (
			echo  Thông tin về địa chỉ MAC của bạn:
			getmac
			echo.
			echo  IP Công cộng của bạn: !PubIP!
			echo  IP Riêng tư của bạn: !PriIP!
			echo.
			echo  Thành công. [!totalsecs!,!ms! giây]
		)
	) else if !addOpt!==2 (
		if !lang!==0 (
			set /p input= Query Website/IP: 
		) else (
			set /p input= Website/IP cần tìm: 
		)
		if !lang!==0 (echo  Estimated Time: ~30 seconds.) else (echo  Thời gian dự tính: ~30 giây.)
		echo.
		set timerStart=!time!
		:: nslookup the given website/IP.
		nslookup !input! | findstr /c:"Addresses" >nul
		if %errorlevel%==0 (
			for /f "tokens=2 delims= " %%G in ('nslookup !input! ^| findstr /c:"Addresses"') do (
				set IP=%%G
			)
		) else (
			for /f "skip=1 tokens=2 delims= " %%G in ('nslookup !input! ^| findstr /c:"Address"') do (
				set IP=%%G
			)
		)
		set timerEnd=!time!
		call :main.timer
		if !lang!==0 (
			echo  Success. [!totalsecs!.!ms! seconds]
			echo  Traced IP: !IP!
			echo.
			echo  Location has been sent to your default browser.
		) else (
			echo  Thành công. [!totalsecs!,!ms! giây]
			echo  Đã tìm được IP: !IP!
			echo.
			echo  Vị trí đã được gửi sang trình duyệt mặc định của bạn.
		)
		:: Query the IP in whatsmyip.com.
		start www.whatsmyip.com/ip-trace/!IP!
	) else if !addOpt!==3 (
		if !lang!==0 (echo  Estimated Time: ~15 seconds.) else (echo  Thời gian dự tính: ~15 giây.)
		echo.
		set timerStart=!time!
		:: Execute the following command then search for Key Content.
		for /f "tokens=2 delims=:" %%G in ('netsh wlan show profile') do (
			for /f "tokens=* delims= " %%H in ("%%G") do (
				for /f "tokens=2 delims=:" %%a in ('netsh wlan show profile "%%H" key^=clear ^| findstr /C:"Key Content"') do (
					(
						echo  [SSID] %%G
						echo     -- [Pass]%%a
						echo.
					) >> output\savedPass.txt
				)
			)
		)
		set timerEnd=!time!
		call :main.timer
		if !lang!==0 (
			echo  Success. [!totalsecs!.!ms! seconds]
			echo  The results were written to %~dp0output\savedPass.txt.
		) else (
			echo  Thành công. [!totalsecs!,!ms! giây]
			echo  Kết quả đã được nhập vào %~dp0output\savedPass.txt.
		)
	) else if !addOpt!==4 (
		if !lang!==0 (echo  Estimated Time: ~5 seconds.) else (echo  Thời gian dự tính: ~5 giây.)
		echo.
		set timerStart=!time!
		:: Execute the following command then output it to a .txt file in output\
		netsh advfirewall firewall show rule name^=all >output\firewallRules.txt
		set timerEnd=!time!
		call :main.timer
		if !lang!==0 (
			echo  Success. [!totalsecs!.!ms! seconds]
			echo  The results were written to %~dp0output\firewallRules.txt.
		) else (
			echo  Thành công. [!totalsecs!,!ms! giây]
			echo  Kết quả đã được nhập vào %~dp0output\firewallRules.txt.
		)
	) else if !addOpt!==5 (
		if !lang!==0 (echo  Estimated Time: ~10 minutes.) else (echo  Thời gian dự tính: ~10 phút.)
		echo.
		set timerStart=!time!
		if exist activeIP.txt del /f /q activeIP.txt
		:: Execute the following command then output it to a .txt file in output\
		FOR /L %%i IN (1,1,254) DO ping -n 1 192.168.1.%%i | findstr /C:"Destination" /V | findstr /C:"Reply" >>output\activeIP.txt
		set timerEnd=!time!
		call :main.timer
		if !lang!==0 (
			echo  Success. [!totalsecs!.!ms! seconds]
			echo  The results were written to %~dp0output\activeIP.txt.
		) else (
			echo  Thành công. [!totalsecs!,!ms! giây]
			echo  Kết quả đã được nhập vào %~dp0output\activeIP.txt.
		)
	) else if !addOpt!==6 (
		if !lang!==0 (
			set /p pingWeb= Ping Website/IP: 
			echo 0 Requests means infinite requests until you press Ctrl+C.
			set /p pingRequest= Number of Requests: 
		) else (
			set /p pingWeb= Website/IP cần ping: 
			echo 0 Yêu cầu tức số lượng yêu cầu là vô hạn cho tới khi bạn nhấn Ctrl+C.
			set /p pingRequest= Số lượng Yêu cầu: 
		)
		echo.
		if !pingRequest!==0 (
			set pingOption=t
			if !lang!==0 (set estPing=Unknown) else (set estPing=Không Xác định)
		) else (
			set pingOption=n !pingRequest!
			set /a estPing=3*!pingRequest!
		)
		if !lang!==0 (
			echo  Estimated Time: ~!estPing! seconds.
		) else (
			echo  Thời gian dự tính: ~!estPing! giây.
		)
		set timerStart=!time!
		:: ping the given website/IP with the user given number of ping requests.
		ping -!pingOption! !pingWeb!
		set timerEnd=!time!
		call :main.timer
		if !lang!==0 (
			echo  Success. [!totalsecs!.!ms! seconds]
		) else (
			echo  Thành công. [!totalsecs!,!ms! giây]
		)
	) else if !addOpt!==7 (
		if !lang!==0 (
			set /p tracertWeb= Query Website/IP: 
		) else (
			set /p tracertWeb= Website/IP cần tìm: 
		)
		echo.
		if !lang!==0 (echo  Estimated Time: ~2 minutes.) else (echo  Thời gian dự tính: ~2 phút.)
		set timerStart=!time!
		:: tracert the given website/IP.
		tracert !tracertWeb!
		set timerEnd=!time!
		call :main.timer
		if !lang!==0 (
			echo  Success. [!totalsecs!.!ms! seconds]
		) else (
			echo  Thành công. [!totalsecs!,!ms! giây]
		)
	) else if !addOpt!==8 (
		if !lang!==0 (
			set /p tracertWeb= Query Website: 
		) else (
			set /p tracertWeb= Website cần tìm: 
		)
		echo.
		if !lang!==0 (echo  Estimated Time: ~2 minutes.) else (echo  Thời gian dự tính: ~2 phút.)
		set timerStart=!time!
		:: pathping the given website/IP.
		pathping !tracertWeb!
		set timerEnd=!time!
		call :main.timer
		if !lang!==0 (
			echo  Success. [!totalsecs!.!ms! seconds]
		) else (
			echo  Thành công. [!totalsecs!,!ms! giây]
		)
	) else if !addOpt!==9 (
		start ncpa.cpl
	) else if !addOpt!==10 (
		start netstat
	) else if !addOpt!==11 (
		if !lang!==1 (echo  Estimated Time: ~10 seconds.) else (echo  Thời gian dự tính: ~10 giây.)
		echo.
		set timerStart=!time!
		:: Basically adding 1 to the %lang% variable then restart the script by the shortcut in tools\
		set langTemp=!lang!
		set /a lang+=1
		if !lang!==2 set lang=0
		set existConfig=2
		call :config.update
		set timerEnd=!time!
		call :main.timer
		if !langTemp!==1 (
			echo  Success. [!totalsecs!.!ms! seconds]
			echo.
			echo  In order to change the config, you must restart the script.
			echo     Press any key to restart.
		) else (
			echo  Thành công. [!totalsecs!,!ms! giây]
			echo.
			echo  Để thay đổi thiết đặt, bạn phải khởi động lại công cụ.
			echo     Nhấn phím bất kỳ để khởi động lại.
		)
		pause >nul
		start tools\SPI_Backup.lnk
		exit
	) else if !addOpt!==12 (
		if !lang!==0 (echo  Estimated Time: ~10 seconds.) else (echo  Thời gian dự tính: ~10 giây.)
		echo.
		set timerStart=!time!
		:: Delete the config file to reset the configurations.
		set langTemp=!lang!
		del /f /q config.txt
		set timerEnd=!time!
		call :main.timer
		if !langTemp!==0 (
			echo  Success. [!totalsecs!.!ms! seconds]
			echo.
			echo  In order to change the config, you must restart the script.
			echo     Press any key to restart.
		) else (
			echo  Thành công. [!totalsecs!,!ms! giây]
			echo.
			echo  Để thay đổi thiết đặt, bạn phải khởi động lại công cụ.
			echo     Nhấn phím bất kỳ để khởi động lại.
		)
		pause >nul
		start tools\SPI_Backup.lnk
		exit
	) else if !addOpt!==13 (
		if !lang!==0 (echo  Estimated Time: ~1 seconds.) else (echo  Thời gian dự tính: ~1 giây.)
		echo.
		set timerStart=!time!
		start SPI_ShortcutGenerator.cmd
		set timerEnd=!time!
		call :main.timer
		if !lang!==0 (
			echo  Success. [!totalsecs!.!ms! seconds]
		) else (
			echo  Thành công. [!totalsecs!,!ms! giây]
		)
	) else if !addOpt!==14 (
		start tools\SPI_Backup.lnk
		exit
	) else if !addOpt!==15 (
		set noPhaseChanged=1
		set errorMoreTool=.
		set "addOpt="
		goto main.confirmUse
	) else (
		if !lang!==0 (
			set errorMoreTool=  Error: Invalid Tool.
			set "addOpt="
		) else (
			set errorMoreTool=  Lỗi: Công cụ Không hợp lệ.
			set "addOpt="
		)
		goto main.moreTools
	)
	endlocal
	echo.
	if %lang%==0 (echo  Press any key to go back.) else (echo  Nhấn phím bất kỳ để quay lại.)
	pause >nul
	set errorMoreTool=.
	set "addOpt="
	goto main.moreTools
:: /************************************************************************************/


:: Commands to do before running the tweaks.
:: /************************************************************************************/
:main.preSetting
	:: Backup settings before change anything.
	if not exist backup\ (
		mkdir backup
		set counterb=000
		set counter=0
		set valuecore=%space%
		set now=-1
		if !lang!==0 (
			call :main.showProgress "Backup" 2 1
			echo  This is the first run of the script. The script is creating a backup,
			echo  so that you could revert the changes that the script made.
		) else (
			call :main.showProgress "Sao lưu" 2 1
			echo  Đây là lần đầu tiên công cụ được chạy. Công cụ đang sao lưu cài đặt,
			echo  để bạn có thể khôi phục lại những cài đặt ban đầu.
		)
		echo.
		call :main.backup
	)
	if %operateMode%==1 (
		set end=70
		call :main.setVariables
	)
	if %noPhaseChanged%==1 set noPhaseChanged=0
	if %browsersFound%==1 (
		set counterb=000
		set counter=0
		set valuecore=%space%
		set now=-1
		if !lang!==0 (
			call :main.showProgress "Browsers' instances detected" 2 1
			echo  The script detected that there are running browsers' instances.
			echo  In order to apply some tweaks, you must close your browsers.
		) else (
			call :main.showProgress "Phát hiện tiến trình trình duyệt" 2 1
			echo  Công cụ đã phát hiện một số tiến trình trình duyệt đang chạy.
			echo  Để có thể áp dụng một số tinh chỉnh, bạn phải đóng trình duyệt của bạn.
		)
		set /a blankLines=!height!-14
		call :main.blankLines !blankLines!
		echo !linesCore!
		echo %autoDeclineMsg%
		choice /c yn /n /t %autoChoose% /d n /m "%optCS%"
			if !errorlevel!==1 (
				taskkill /f /im chrome.exe
				taskkill /f /im firefox.exe
				taskkill /f /im opera.exe
				taskkill /f /im msedge.exe
				taskkill /f /im vivaldi.exe
				taskkill /f /im thunderbird.exe
				set browsersFound=0
			)
	)
	if !lang!==0 (
		set /a alignTitle2=!width!-2-27-12
	) else (
		set /a alignTitle2=!width!-30-9-9
	)
	if !lang!==0 (
		set title=Restart Internet Connection!space:~0,%alignTitle2%!Executing...
	) else (
		set title=Khởi động lại Kết nối Internet!space:~0,%alignTitle2%!Đang thực thi...
	)
	set subtitle=Legend0fHell - %ver% - %verdate%
	set counterb=000
	set counter=0
	set valuecore=%space%
	set timerStart=%time%
	set now=0
	goto progress.restartConnection
:: /************************************************************************************/


:: Check the latency if the option is enabled.
:: /************************************************************************************/
:progress.checkLatency1
	:: Prevent the command from errors.
	if %internetStatus%==0 (
		set failedPingCheck=1
		goto :EOF
	)
	for /F "delims=" %%a in ('ping "%pingURL%" -n 2 ^| findstr TTL') do (
	   set line=%%a
	   for /F "tokens=7 delims== " %%b in ("%%a") do set pingBefore=%%b
	)
	if not defined pingBefore (
		set failedPingCheck=1
	) else (
		set failedPingCheck=0
		set pingBefore=%pingBefore:~0,-2%
	)
goto :EOF
:: /************************************************************************************/


:: RESTART THE CONNECTION MODULE
:: /************************************************************************************/
:progress.restartConnection
	:: Reset WinSock
	call :main.showProgress "WinSockReset" 1 2
		netsh winsock reset
		
	:: Reset the Log file in 2 directories.
	call :main.showProgress "Reset TCP/IP" 1 2
		netsh int ip reset %HomeDrive%\resetlog.txt
		netsh int ip reset reset.log
		
	:: Flush the DNS Cache.
	call :main.showProgress "DNS Cache" 1 2
		ipconfig /flushdns
		
	:: Release the IP.
	call :main.showProgress "Release IP" 1 2
		ipconfig /release
		
	:: Renew the IP. Multi-tasking this progress because this takes a lot of time.
	call :main.showProgress "Renew IP" 1 2
		start "SPI | %percent%%% %now%/%end% - Renew IP [!splitTitle!]" /MIN cmd /c ipconfig /renew"
		
	:: Clear Flash/Macromedia caches.
	call :main.showProgress "Flash/Macromedia" 1 3
		del /q /s /f "%HomeDrive%\Users\%USERNAME%\AppData\Roaming\Macromedia\Flashp~1" >nul
		rd /s /q "%HomeDrive%\Users\%USERNAME%\AppData\Roaming\Macromedia\Flashp~1" >nul
	
	:: Check the existance of SpeedyFox in tools\. If not found the file or browsers are running, SpeedyFox task will be skipped.
	if not exist "%~dp0tools\speedyfox.exe" (
		call :main.showProgress "Not found SpeedyFox. Skipping..." 1 8
		goto progress.restartConnection2
	)
	if %browsersFound%==0 (call :progress.SpeedyFox) else (call :main.showProgress "Found browsers' instances. Skipping..." 1 8)
	
:progress.restartConnection2
	:: Restarting the adapters. This has to be done on every adapters.
	call :main.showProgress "Restart Adapters" 1 7
		set checkInterfaceMode=2
		call :progress.getInterfaceName
	
	if %operateMode%==1 goto progress.Opt.TCPIP
	
	:: Waiting for the Internet Connection to estabilshed.
	if !lang!==0 (call :main.showProgress "Internet Connection" 1 1) else (call :main.showProgress "Kết nối Internet" 1 1)
	goto progress.waitInternet
:: /************************************************************************************/


:: Run TCP/IP/DNS tweaks.
:: /************************************************************************************/
:progress.Opt.TCPIP
	:: Delete the ARP Cache.
	call :main.showProgress "ARP Cache" 1 2
		netsh interface ip delete arpcache
		
	:: Use the custom template.
	call :main.showProgress "Custom Template" 1 2
		netsh int tcp set supplemental Custom
		netsh int tcp set supplemental InternetCustom
		
	:: Disable Receive Segment Coalescing.
	call :main.showProgress "Receive Segment Coalescing" 1 2
		netsh int tcp set global rsc=disabled >nul
		powershell -Command "& {Set-NetOffloadGlobalSetting -ReceiveSegmentCoalescing disabled;}"
		
	:: Disable Packet Coalescing.
	call :main.showProgress "Packet Coalescing" 1 2
		powershell -Command "& {Set-NetOffloadGlobalSetting -PacketCoalescingFilter disabled;}"
		
	:: Enable Checksum Offload.
	call :main.showProgress "Checksum Offload" 1 2
		powershell -Command "& {Enable-NetAdapterChecksumOffload -Name *;}"
		
	:: Disable Large Send Offload.
	call :main.showProgress "Large Send Offload" 1 2
		powershell -Command "& {Disable-NetAdapterLso -Name *;}"
		
	:: Disable RFC 1323 Timestamps.
	call :main.showProgress "RFC 1323 Timestamps" 1 2
		netsh int tcp set global timestamps=disabled
		
	:: Set the Initial RTO to 2500.
	call :main.showProgress "Initial RTO" 1 2
		netsh int tcp set global initialRto=2500 >nul
		
	:: Set the Min RTO to 300.
	call :main.showProgress "Min RTO" 1 2
		powershell -Command "& {set-NetTCPSetting -SettingName InternetCustom -MinRto 300;}"
		
	:: Set the Add-On Congestion Control Provider to CTCP by 3 methods.
	call :main.showProgress "Add-On Congestion Control Provider" 1 2
		netsh int tcp set global congestionprovider=ctcp
		powershell -Command "& {Set-NetTCPSetting -SettingName InternetCustom -CongestionProvider CTCP;}"
		powershell -Command "& {Set-NetTCPSetting -SettingName Custom -CongestionProvider CTCP;}"
		netsh int tcp set supplemental Custom congestionprovider=ctcp
		netsh int tcp set supplemental InternetCustom congestionprovider=ctcp
		
	:: Enable ECN.
	call :main.showProgress "ECN" 1 2
		netsh int tcp set global ecn=enabled
		
	:: Disable Scaling Heuristics to prevent it from changing the Window Auto-Tuning Level.
	call :main.showProgress "Scaling Heuristics" 1 2
		netsh int tcp set heuristics disabled
		
	:: Set Window Auto-Tuning Level to Normal.
	call :main.showProgress "Window Auto-Tuning Level" 1 2
		netsh int tcp set global autotuninglevel=normal
		
	:: Disable TCP Chimney Offload.
	call :main.showProgress "TCP Chimney Offload" 1 2
		netsh int tcp set global chimney=disabled
	
	:: Enable RSS or Receive-Side Scaling State.
	call :main.showProgress "Receive-Side Scaling State" 1 2
		netsh int tcp set global rss=enabled
		netsh interface tcp set heuristics wsh=enabled
		
	:: Enable Direct Cache Access.
	call :main.showProgress "Direct Cache Access" 1 2
		netsh int tcp set global dca=enabled
		
	:: Enable Non SACK RTT Resiliency.
	call :main.showProgress "Non SACK RTT Resiliency" 1 2
		netsh int tcp set global nonsackrttresiliency=enabled >nul
	
	:: Set Max SYN Retransmissions to 2.
	call :main.showProgress "Max SYN Retransmissions" 1 2
		netsh int tsp set global maxsynretransmissions=2 >nul
		
	:: Set Initial Congestion Window to 10.
	call :main.showProgress "Initial Congestion Window" 1 2
		powershell -Command "& {Set-NetTCPSetting -SettingName InternetCustom -InitialCongestionWindow 10;}"
		netsh int tcp set supplemental template=custom icw=10
		netsh int tcp set supplemental template=InternetCustom icw=10
		
	:: Disable Memory Pressure Protection.
	call :main.showProgress "Memory Pressure Protection" 1 2
		netsh int tcp set security mpp=disabled
		netsh int tcp set security profiles=disabled
		
	:: Enable Auto-Tuning.
	call :main.showProgress "Auto-Tuning" 1 2
		netsh winsock set autotuning on
		
	:: Set Maximum Transmission Unit to 1492. This has to be done on every interfaces.
	call :main.showProgress "Maximum Transmission Unit" 1 2
		set checkInterfaceMode=1
		call :progress.getInterfaceName
		
	:: Set DefaultTTL to 64.
	call :main.showProgress "DefaultTTL" 1 2
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DefaultTTL /t REG_DWORD /d "64" /f > NUL 2>&1
		
	:: Set MaxUserPort to 65534.
	call :main.showProgress "MaxUserPort" 1 2
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MaxUserPort /t REG_DWORD /d "65534" /f > NUL 2>&1
		
	:: Set TCPTimedWaitDelay to 30.
	call :main.showProgress "TCPTimedWaitDelay" 1 2
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpTimedWaitDelay /t REG_DWORD /d "30" /f > NUL 2>&1
		
	:: Set Host Resolution Priorities.
	call :main.showProgress "Host Resolution Priority" 1 2
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v LocalPriority /t REG_DWORD /d "4" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v HostPriority /t REG_DWORD /d "5" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v DnsPriority /t REG_DWORD /d "6" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v NetbtPriority /t REG_DWORD /d "7" /f > NUL 2>&1
		
	:: Set QoS Reserved Bandwidth to 0 [In reality it's 10 due to Microsoft doesn't allow it].
	call :main.showProgress "QoS Reserved Bandwidth" 1 2
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /t REG_DWORD /d "0" /f > NUL 2>&1
		
	:: Disable QoS Policy NLA.
	call :main.showProgress "QoS Policy NLA" 1 2
		reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_SZ /d "1" /f > NUL 2>&1
		
	:: Set Network Memory Allocation.
	call :main.showProgress "Network Memory Allocation" 1 2
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v Size /t REG_DWORD /d "3" /f > NUL 2>&1
		
	:: Set Network Throttling Index to 4294967295 [2^32-1].
	call :main.showProgress "Network Throttling Index" 1 2
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d "4294967295" /f > NUL 2>&1
		
	:: Set SystemResponsiveness to 0 [This is a network tweak].
	call :main.showProgress "System Responsiveness" 1 2
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d "0" /f > NUL 2>&1
	
	:: Disable Scaling Heuristics in registry.
	call :main.showProgress "Scaling Heuristics Registry" 1 2
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableHeuristics" /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t REG_DWORD /d "0" /f > NUL 2>&1
		
	:: Enable RFC 1323 Window Scaling.
	call :main.showProgress "RFC 1323 Window Scaling" 1 2
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d "1" /f > NUL 2>&1
		
	:: Set UDP Packet Size to 1280.
	call :main.showProgress "UDP Packet Size" 1 2
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DNS\Parameters" /v "MaximumUdpPacketSize" /t REG_DWORD /d "1280" /f > NUL 2>&1
		
	:: Set options in DNS Error Caching.
	call :main.showProgress "DNS Error Caching" 1 2
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeSOACacheTime" /t REG_DWORD /d "0" /f > NUL 2>&1
		
	:: Set options in MMCSS.
	call :main.showProgress "MMCSS" 1 2
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t REG_DWORD /d "2710" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d "8" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d "6" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f > NUL 2>&1
		
	:: Set Nagle's Algorithms. This has to be done on every interfaces.
	call :main.showProgress "Nagle's Algorithms" 1 2
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSMQ\Parameters" /v TCPNoDelay /t REG_DWORD /d "1" /f > NUL 2>&1
		for /f "tokens=2* delims=_" %%H in ('getmac.exe') do (call :progress.setNagle %%H)
		
	:: Gettings every Device Number ID in the Registry to set the Network Adapters settings.
		for /F "delims=" %%I in ('%SystemRoot%\System32\reg.exe query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}" /s /v ProviderName 2^>nul') do call :progress.setAdapters "%%I"
		set noPhaseChanged=0
	goto progress.browsers
:: /************************************************************************************/


:: Tweaking the adapters settings. These have to be done on every adapters.
:: /************************************************************************************/
:progress.setAdapters
	:: Processing the informations got from the above commands.
	set "RegistryLine=%~1"
	if "%RegistryLine:~0,5%" == "HKEY_" set "RegistryKey=%~1" & goto :EOF
	for /F "tokens=2*" %%A in ("%RegistryLine%") do set "ProviderName=%%B"
	:: Skip the finding results those contain Microsoft or "search".
	echo %ProviderName% | findstr "search"
	if %errorlevel%==1 (
		if "%ProviderName%" == "Microsoft" goto :EOF
		:: Disable Flow Control.
		call :main.showProgress "Flow Control" 1 7
			reg add "%RegistryKey%" /v "*FlowControl" /t REG_SZ /d "0" /f >NUL 2>&1
			
		:: Disable Interrupt Moderation.
		call :main.showProgress "Interrupt Moderation" 1 7
			reg add "%RegistryKey%" /v "*InterruptModeration" /t REG_SZ /d "0" /f >NUL 2>&1
			
		:: Disable Speed Duplex.
		call :main.showProgress "Speed Duplex" 1 7
			reg add "%RegistryKey%" /v "*SpeedDuplex" /t REG_SZ /d "0" /f >NUL 2>&1
			
		:: Disable Auto Disable Gigabit.
		call :main.showProgress "Auto Disable Gigabit" 1 7
			reg add "%RegistryKey%" /v "AutoDisableGigabit" /t REG_SZ /d "0" /f >NUL 2>&1
			
		:: Disable Energy Efficient Ethernet.
		call :main.showProgress "Energy Efficient Ethernet" 1 7
			reg add "%RegistryKey%" /v "EEE" /t REG_SZ /d "0" /f >NUL 2>&1
		
		:: Disable Priority and VLAN.
		call :main.showProgress "Priority and VLAN" 1 7
			reg add "%RegistryKey%" /v "*PriorityVLANTag" /t REG_SZ /d "0" /f >NUL 2>&1
			
		:: Disable Green Ethernet.
		call :main.showProgress "Green Ethernet" 1 7
			reg add "%RegistryKey%" /v "EnableGreenEthernet" /t REG_SZ /d "0" /f >NUL 2>&1
			
		:: Disable Large Send Offload.
		call :main.showProgress "Large Send Offload v2" 1 7
			reg add "%RegistryKey%" /v "*LsoV2IPv4" /t REG_SZ /d "0" /f >NUL 2>&1
			
		:: Set AP Compatibility Mode to Higher Performance.
		call :main.showProgress "AP Compatibility Mode" 1 7
			reg add "%RegistryKey%" /v "ApCompatMode" /t REG_SZ /d "0" /f >NUL 2>&1
			
		:: Disable "Allow the computer to turn off this device to save power" option in the Power Management tabs in Device Manager.
		call :main.showProgress "Permit turning off the adapters" 1 7
			reg add "%RegistryKey%" /v "PnPCapabilities" /t REG_DWORD /d "24" /f >NUL 2>&1
	)
	set noPhaseChanged=2
goto :EOF
:: /************************************************************************************/


:: Check the Name of the Network Interfaces.
:: /************************************************************************************/
:progress.getInterfaceName
	for /f "skip=4 tokens=5* delims= " %%H in ('netsh int ipv4 show subinterface') do (call :progress.useInterfaceName %%H %%I)
goto :EOF
:: /************************************************************************************/


:: Define what needs to use the interface names.
:: /************************************************************************************/
:progress.useInterfaceName
	set interfaceName=%*
	if %checkInterfaceMode%==2 (
		netsh interface set interface name="!interfaceName!" admin="disabled" >nul
		netsh interface set interface name="!interfaceName!" admin="enabled" >nul
	)
	if %checkInterfaceMode%==1 (
		netsh int ipv4 set subinterface "!interfaceName!" mtu=1492 store=persistent >nul
	)
goto :EOF
:: /************************************************************************************/


:: Set the Nagle's Algorithms of the Network Interfaces.
:: /************************************************************************************/
:progress.setNagle
	set nicID=%1
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%nicID%" /v TcpAckFrequency /t REG_DWORD /d "1" /f > NUL 2>&1
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%nicID%" /v TCPNoDelay /t REG_DWORD /d "1" /f > NUL 2>&1
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%nicID%" /v TcpDelAckTicks /t REG_DWORD /d "0" /f > NUL 2>&1
goto :EOF
:: /************************************************************************************/


:: Run SpeedyFox - a safe browser optimization tool by CrystalIdea.
:: /************************************************************************************/
:progress.SpeedyFox
	if !lang!==0 (
		call :main.showProgress "Running SpeedyFox - a safe optimization tool" 1 3
	) else (
		call :main.showProgress "Chạy SpeedyFox - Công cụ tối ưu an toàn" 1 3
	)
	start "SPI | %percent%%% %now%/%end% - SpeedyFox [!splitTitle!]" /MIN cmd /c ""%~dp0tools\speedyfox.exe" "/Chrome:all" "/Firefox:all" "/Opera:all" "/Microsoft Edge:all" "/Vivaldi:all" "/Thunderbird:all""
	:: Deleting Chrome caches.
	for /d %%b in (%SystemDrive%\Users\*) do del /Q "%%b\AppData\Local\Google\User Data\Default\cache\*"
	
goto :EOF
:: /************************************************************************************/


:: Run browsers tweaks.
:: /************************************************************************************/
:progress.browsers
	:: Tweaking Internet Explorer options [Someone in the world is still using this].
	call :main.showProgress "Internet Explorer" 1 3
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v explorer.exe /t REG_DWORD /d "8" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER" /v explorer.exe /t REG_DWORD /d "8" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v iexplore.exe /t REG_DWORD /d "8" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER" /v iexplore.exe /t REG_DWORD /d "8" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\MAIN" /V DNSPreresolution /t REG_DWORD /d "8" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\MAIN" /V Use_Async_DNS /t REG_SZ /d "yes" /f > NUL 2>&1
		reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /V DnsCacheEnabled /t REG_DWORD /d "1" /f > NUL 2>&1
		reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /V DnsCacheEntries /t REG_DWORD /d "200" /f > NUL 2>&1
		reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /V DnsCacheTimeout /t REG_DWORD /d "15180" /f > NUL 2>&1
		reg add "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main" /V EnablePreBinding /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext" /V DisableAddonLoadTimePerformanceNotifications /t REG_DWORD /d "1" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext" /V NoFirsttimeprompt /t REG_DWORD /d "1" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Safety\PrivacIE" /V DisableInPrivateBlocking /t REG_DWORD /d "00000000" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Safety\PrivacIE" /V StartMode /t REG_DWORD /d "00000001" /f > NUL 2>&1
		start "" rundll32.exe InetCpl.cpl,ClearMyTracksByProcess 4351
		regsvr32 /s actxprxy
		del /q /s /f "%HomeDrive%\Users\%USERNAME%\AppData\Local\Microsoft\Intern~1" >nul
		rd /s /q "%HomeDrive%\Users\%USERNAME%\AppData\Local\Microsoft\Intern~1" >nul
		del /q /s /f "%HomeDrive%\Users\%USERNAME%\AppData\Local\Microsoft\Windows\History" >nul
		rd /s /q "%HomeDrive%\Users\%USERNAME%\AppData\Local\Microsoft\Windows\History" >nul
		del /q /s /f "%HomeDrive%\Users\%USERNAME%\AppData\Local\Microsoft\Windows\Tempor~1" >nul
		rd /s /q "%HomeDrive%\Users\%USERNAME%\AppData\Local\Microsoft\Windows\Tempor~1" >nul
		
	
	:: Use Large Pages on Chrome to improve performance.
	call :main.showProgress "Chrome" 1 3
		reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\chrome.exe" /V UseLargePages /t REG_DWORD /d "00000001" /f > NUL 2>&1
		
	goto progress.telemetry
:: /************************************************************************************/


:: Disable the Telemetry services.
:: Most of the tweaks came from Tron (r/TronScript). Thanks!
:: /************************************************************************************/
:progress.telemetry
	call :main.showProgress "Services" 1 4
		sc stop dmwappushservice > NUL 2>&1
		sc config dmwappushservice start= disabled > NUL 2>&1
		sc stop RetailDemo > NUL 2>&1
		sc delete RetailDemo > NUL 2>&1
		sc stop Diagtrack > NUL 2>&1
		sc delete Diagtrack > NUL 2>&1
		sc config RemoteRegistry start= disabled > NUL 2>&1
		sc stop RemoteRegistry > NUL 2>&1
		sc stop Wecsvc > NUL 2>&1
		sc config Wecsvc start= disabled > NUL 2>&1
		
	call :main.showProgress "Xbox Services" 1 4
		sc stop XblAuthManager > NUL 2>&1
		sc stop XblGameSave > NUL 2>&1
		sc stop XboxNetApiSvc > NUL 2>&1
		sc stop XboxGipSvc > NUL 2>&1
		sc stop xbgm > NUL 2>&1
		sc config XblAuthManager start= manual > NUL 2>&1
		sc config XblGameSave start= manual > NUL 2>&1
		sc config XboxNetApiSvc start= manual > NUL 2>&1
		sc config XboxGipSvc start= manual > NUL 2>&1
		sc config xbgm start= manual > NUL 2>&1
		
	call :main.showProgress "Registries Telemetry" 1 4
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKLM\software\microsoft\wcmsvc\wifinetworkmanager" /v "wifisensecredshared" /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKLM\software\microsoft\wcmsvc\wifinetworkmanager" /v "wifisenseopen" /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKLM\software\microsoft\windows defender\spynet" /v "spynetreporting" /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKLM\software\microsoft\windows defender\spynet" /v "submitsamplesconsent" /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKLM\software\policies\microsoft\windows\skydrive" /v "disablefilesync" /t REG_DWORD /d "1" /f > NUL 2>&1
		reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
		reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
		reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "00000000" /f > NUL 2>&1
		reg load HKEY_LOCAL_MACHINE\defuser %USERPROFILES%\default\ntuser.dat >NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\defuser\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /V RotatingLockScreenOverlayEnabled /T REG_DWORD /D 00000000 /F >NUL 2>&1
		reg unload HKEY_LOCAL_MACHINE\defuser >NUL 2>&1
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f > NUL 2>&1
		REG add "HKLM\software\microsoft\wcmsvc\wifinetworkmanager" /v "wifisensecredshared" /t REG_DWORD /d "0" /f
		REG add "HKLM\software\microsoft\wcmsvc\wifinetworkmanager" /v "wifisenseopen" /t REG_DWORD /d "0" /f
		REG add "HKLM\software\microsoft\windows defender\spynet" /v "spynetreporting" /t REG_DWORD /d "0" /f
		REG add "HKLM\software\microsoft\windows defender\spynet" /v "submitsamplesconsent" /t REG_DWORD /d "0" /f
		REG add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /v "Start" /t REG_DWORD /d "4" /f
		REG add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /v "Start" /t REG_DWORD /d "4" /f
		
	call :main.showProgress "Scheduler Tasks Telemetry" 1 4
		schtasks /delete /F /TN "\Microsoft\Windows\Application Experience\AitAgent"
		schtasks /delete /F /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" > NUL 2>&1
		schtasks /delete /F /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" > NUL 2>&1
		schtasks /delete /F /TN "\Microsoft\Windows\Autochk\Proxy" > NUL 2>&1
		schtasks /delete /F /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" > NUL 2>&1
		schtasks /delete /F /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" > NUL 2>&1
		schtasks /delete /F /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" > NUL 2>&1
		schtasks /delete /F /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" > NUL 2>&1
		schtasks /delete /F /TN "\Microsoft\Windows\PI\Sqm-Tasks" > NUL 2>&1
		schtasks /delete /F /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" > NUL 2>&1
		schtasks /delete /F /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\application experience\Microsoft compatibility appraiser" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\application experience\aitagent" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\application experience\programdataupdater" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\autochk\proxy" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\customer experience improvement program\consolidator" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\customer experience improvement program\kernelceiptask" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\customer experience improvement program\usbceip" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\diskdiagnostic\Microsoft-Windows-diskdiagnosticdatacollector" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\maintenance\winsat" > NUL 2>&1
		
	call :main.showProgress "Media Center Telemetry" 1 4
		schtasks /delete /f /tn "\Microsoft\Windows\media center\activateWindowssearch" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\configureinternettimeservice" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\dispatchrecoverytasks" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\ehdrminit" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\installplayready" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\mcupdate" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\mediacenterrecoverytask" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\objectstorerecoverytask" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\ocuractivate" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\ocurdiscovery" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\pbdadiscovery">nul 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\pbdadiscoveryw1" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\pbdadiscoveryw2" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\pvrrecoverytask" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\pvrscheduletask" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\registersearch" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\reindexsearchroot" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\sqlliterecoverytask" > NUL 2>&1
		schtasks /delete /f /tn "\Microsoft\Windows\media center\updaterecordpath" > NUL 2>&1
		
	call :main.showProgress "Auto-Logger" 1 4
		if not exist %ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\ mkdir %ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\ >NUL 2>&1
		reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d "0" /f
		echo. > %ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl 2>NUL
		echo y | cacls.exe "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl" /d SYSTEM >NUL 2>&1
	
	call :main.showProgress "Explorer Registries" 1 5
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f > NUL 2>&1
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f > NUL 2>&1
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f > NUL 2>&1
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f > NUL 2>&1
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f > NUL 2>&1
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f > NUL 2>&1
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f > NUL 2>&1
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f > NUL 2>&1
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f > NUL 2>&1
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f > NUL 2>&1
		reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f > NUL 2>&1
		reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d "1" /f > NUL 2>&1
		reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d "0" /f > NUL 2>&1
		reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d "1" /f > NUL 2>&1
		reg delete "HKEY_CLASSES_ROOT\CABFolder\CLSID" /f > NUL 2>&1
		reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.cab\CLSID" /f > NUL 2>&1
		reg delete "HKEY_CLASSES_ROOT\CompressedFolder\CLSID" /f > NUL 2>&1
		reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.zip\CLSID" /f > NUL 2>&1
:: /************************************************************************************/


:: Check if OneDrive is installed.
:: /************************************************************************************/
:progress.checkOneDrive
	if !lang!==0 (call :main.showProgress "Prompt to Uninstall OneDrive" 2 6) else (call :main.showProgress "Xác nhận Gỡ cài đặt OneDrive" 2 6)
	set x86="%SYSTEMROOT%\System32\OneDriveSetup.exe"
	set x64="%SYSTEMROOT%\SysWOW64\OneDriveSetup.exe"
	if exist %x64% goto progress.OneDrive
	if exist %x86% goto progress.OneDrive
	call :main.showProgress "..." 1 8
	goto progress.fileHosts
:: /************************************************************************************/


:: Prompt users to uninstall OneDrive and uninstall it if the users accepted.
:: /************************************************************************************/
:progress.OneDrive
	if !lang!==0 (
		echo  Do you want to uninstall OneDrive/OneNote?
		echo  You should uninstall OneDrive/OneNote if you don't need it. It will free up
		echo  some RAM and improve your Internet connection.
	) else (
		echo  Bạn có muốn gỡ cài đặt OneDrive/OneNote?
		echo  Bạn nên gỡ cài đặt OneDrive/OneNote nếu không cần sử dụng. Nó sẽ giúp giải
		echo  phóng RAM và cải thiện kết nối Internet của bạn.
	)
	echo.
	echo %autoDeclineMsg%
	choice /c yn /n /t %autoChoose% /d n /m "%optYn%"
		if %errorlevel%==2 (
			call :main.showProgress "..." 1 8
			goto progress.fileHosts
		)
	call :main.showProgress "OneDrive" 1 6
		taskkill /f /im OneDrive.exe > NUL 2>&1
		powershell -Command "& {Get-AppxPackage -allusers *OneNote* | Remove-AppxPackage;}"
		REG add "HKLM\software\policies\microsoft\windows\skydrive" /v "disablefilesync" /t REG_DWORD /d "1" /f
		if exist %x64% (%x64% /uninstall) else (%x86% /uninstall)
		reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f
		reg add "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f
		rd "%USERPROFILE%\OneDrive" /Q /S > NUL 2>&1
		rd "%HomeDrive%\OneDriveTemp" /Q /S > NUL 2>&1
		rd "%LOCALAPPDATA%\Microsoft\OneDrive" /Q /S > NUL 2>&1
		rd "%PROGRAMDATA%\Microsoft OneDrive" /Q /S > NUL 2>&1
:: /************************************************************************************/


:: Edit the Hosts to stop Telemetry.
:: /************************************************************************************/
:progress.fileHosts
	:: Adding the addresses from the config file to Hosts file.
	call :main.showProgress "Hosts File" 1 4
		for /f "delims= skip=%configLineSkip%" %%i in (config.txt) do (
			findstr /c:"%%i" %WINDIR%\system32\drivers\etc\hosts > NUL 2>&1
			IF !ERRORLEVEL! NEQ 0 echo 0.0.0.0 %%i>>%WINDIR%\System32\drivers\etc\hosts
		)
	
	:: Set the DNS to the DNS set in the config file.
	call :main.showProgress "DNS" 1 2
		wmic nicconfig where (IPEnabled=TRUE) call SetDNSServerSearchOrder ("!dns1!", "!dns2!")
		
	:: Waiting for the Internet Connection to estabilshed.
	if !lang!==0 (call :main.showProgress "Internet Connection" 1 1) else (call :main.showProgress "Kết nối Internet" 1 1)
	if %internetStatus%==0 goto progress.checkLatency2	
:: /************************************************************************************/


:: Wait until the Internet connection is estabilshed.
:: /************************************************************************************/
:progress.waitInternet
	call :main.checkConnection 0
	set /a retryTime+=1
	if !internetStatus! == 0 (
		if !retryTime! LSS 1000 (
			goto progress.waitInternet
		) else (
			goto progress.checkLatency2
		)
	) else (
		goto progress.checkLatency2
	)
:: /************************************************************************************/


:: Check the latency after tweaking if the option is enabled.
:: /************************************************************************************/
:progress.checkLatency2
	if !lang!==0 (call :main.showProgress "Checking the Current Latency" 1 1) else (call :main.showProgress "Kiểm tra Độ trễ Hiện tại" 1 1)
	set pingBeforeBackup=!pingBefore!
	call :main.checkConnection 1
	set pingAfter=!pingBefore!
	set pingBefore=!pingBeforeBackup!
	if !checkPingEnable!==0 goto main.afterSetting
:: /************************************************************************************/


:: Check the latency checking results. If they are invaild, set the results to "?".
:: Also calculate the improvement rate.
:: /************************************************************************************/
:main.checkResults
	:: Set the result to "?" if the commands got some errors.
	if !failedPingCheckBackup!==1 (
		if !failedPingCheck!==1 (
			set pingBefore=?
			set pingAfter=?
			set pingRate=?
			goto main.afterSetting
		) else (
			set pingBefore=?
			set pingRate=?
			goto main.afterSetting
		)
	)
	if !failedPingCheckBackup!==0 (
		if !failedPingCheck!==0 (
			if %pingAfter% GEQ %pingBefore% (
				set pingAfter=%pingBefore%
				set connectionStatus=!pingBefore!ms
				set connectionStatusLength=!connectionStatusLengthBackup!
			) else (
				set /a connectionStatusLength-=2
			)
		) else (
			set pingAfter=?
			set pingRate=?
			goto main.afterSetting
		)
	) else (
		goto main.afterSetting
	)
	set /a pingRate=((%pingBefore%*100)/%pingAfter%)-100
:: /************************************************************************************/


:: Commands to do after running the tweaks.
:: /************************************************************************************/
:main.afterSetting
	call :main.setInternetStatus
	set /a now-=1
	set timerEnd=%time%
	call :main.timer
	set counterb=10000
:: /************************************************************************************/


:: Give advices to users and exit after running the script.
:: /************************************************************************************/
:main.finish
	if !lang!==0 (
		call :main.showProgress "Completed" 1 8
		echo  The script was executed. [%totalsecs%.%ms% seconds]
		echo.
		set label=Advice&call :main.label 6
		echo  1/ Restart your PC to fully applied the tweaks.
		echo  2/ Always use a LAN connection to have a better ping.
		echo  3/ Running this script frequently.
	) else (
		call :main.showProgress "Hoàn thành" 1 8
		echo  Công cụ đã được thực thi. [%totalsecs%,%ms% giây]
		echo.
		set label=Lời khuyên&call :main.label 10
		echo  1/ Khởi động lại máy tính để các tinh chỉnh có đầy đủ hiệu lực.
		echo  2/ Luôn sử dụng mạng LAN để có độ trễ tốt hơn.
		echo  3/ Thường xuyên chạy công cụ này.
	)
	echo.
	if %checkPingEnable%==1 (
		if !lang!==0 (
			set label=Latency Checking Results&call :main.label 24
			echo     URL            : %pingURL%
			echo     Latency Before : %pingBefore%ms
			echo     Latency After  : %pingAfter%ms
			echo     Improved       : %pingRate%%%
		) else (
			set label=Kết quả Kiểm tra Độ trễ Mạng&call :main.label 28
			echo     URL          : %pingURL%
			echo     Độ trễ Trước : %pingBefore%ms
			echo     Độ trễ Sau   : %pingAfter%ms
			echo     Cải thiện    : %pingRate%%%
		)
	)
	echo.
	if !lang!==0 (echo  Press any key to exit.) else (echo  Nhấn phím bất kỳ để thoát.)
	endlocal
	pause >nul
	exit
:: /************************************************************************************/