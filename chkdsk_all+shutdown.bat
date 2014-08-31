:: BatchGotAdmin <https://sites.google.com/site/eneerge/scripts/batchgotadmin>
:-------------------------------------
@echo off
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
    @echo on	
:--------------------------------------

:: ScanDisk All <v.arribas.urjc@gmail.com (c) 2014 BSD-Clause 3>
:--------------------------------------
@echo off
REM The System Drive must be specially treated.
SET SYSTEM_DRIVE=C:

REM ^, -- ^ is the escape character for declarations  between '
for /f "skip=1 tokens=1,2 delims= " %%a in ('wmic logicaldisk get caption^,filesystem') do (
	if "%%a" == "%SYSTEM_DRIVE%" (
		echo Read-Only ScanDisk of System Drive %%a
		chkdsk /scan /perf /forceofflinefix %%a
		REM Force boot-scandisk by setting as dirty (option B)
		rem fsutil dirty set C:
	) else if "%%b" == "NTFS" (
		REM http://www.minasi.com/newsletters/nws1305.htm (chkdsk Win 8+ features)
		echo Two-steps ScanDisk of %%b unit %%a
		chkdsk /scan /perf /forceofflinefix %%a
		chkdsk /X /offlinescanandfix %%a
		REM Options /scan /perf /forceofflinefix /offlinescanandfix requires Win 8+
		REM Old scan (backward compatibility <Win 8)
		rem chkdsk /F /X %%a
		rem chkdsk /F /X /R /B %%a
	) else if "%%b" == "FAT32" (
		echo Two-steps ScanDisk of %%b unit %%a
		chkdsk /F /X %%a
		chkdsk /F /X /R %%a
	)
)
:--------------------------------------

:: Power off routine <v.arribas.urjc@gmail.com (c) 2014 BSD-Clause 3>
:--------------------------------------
@echo off
echo Preparing to shutdown..."
shutdown /s /t 120

echo Press enter to abort shutdown
pause > nul
shutdown /a

echo Shutdown aborted
pause
:--------------------------------------