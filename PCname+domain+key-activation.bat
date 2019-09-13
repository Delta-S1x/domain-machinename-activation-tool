@echo off
REM FILL IN THE INFORMATION HERE TO USE THE FUNCTIONS THAT REQUIRE THESE VARIABLES 
set domainName=domain
set adminUser=PUT ADMIN USER NAME HERE
set adminPass=PUT ADMIN PASSWORD HERE
set windowsKey=PUT WINDOWS KEY HERE



echo Current PC name =  %computername%
set /p text="do you want to change the name of the pc? y or n "
set newname=%computername%

if %text% == y (
	GOTO namechange
	
)else (goto query)
:namechange
	echo Current PC name =  %computername%
	set /p newname="What is the new name? "
	WMIC computersystem where caption='%computername%' rename %newname%
	echo PC name =  %computername%, this will ussally change after reboot
	pause
:query
	echo current domain:	
	systeminfo | findstr /B /C:"Domain"
	set /P domainq="Do you Wish to join %domainName% Domain? y or n "
	IF %domainq% == y (
		goto domainchange
	)else ( goto query2)


:domainchange 
	netdom /domain: %domainName% /user:%adminUser% /passowrd:%adminPass% <newname> /joindomain
	echo please wait...
	timeout /t 10 /nobreak > NUL
	systeminfo | findstr /B /C:"Domain"
	pause
	
:query2
	set /p keyq= "do you want to set the windows key and push activation? y or n "
	IF %keyq% == y (
	goto keychange
	)else ( goto end)

:keychange
	SLMGR /IPK %windowsKey%
	slmgr.vbs /ato


:end
echo You have arrived at the end. Godspeed.
pause