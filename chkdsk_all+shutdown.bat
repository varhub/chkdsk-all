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


:: WindowsVersionChecker (detect OS) <v.arribas.urjc@gmail.com (c) 2014 BSD-Clause 3>
:--------------------------------------
@ECHO off
REM http://msdn.microsoft.com/en-us/library/windows/desktop/ms724832(v=vs.85).aspx
REM 6.3 -- Win 8.1, Win Server 2012 R2
REM 6.2 -- Win 8, Win Server 2012
REM 6.1 -- Win 7, Win Server 2008 R2
REM 6.0 -- Win Vista, Win Server 2008
REM 5.2 -- Win Server 2003, Win Server 2003 R2, Win XP 64-Bit Edition
REM 5.1 -- Win XP
REM 5.0 -- Win 2000

FOR /f "tokens=4,5,6 delims=[]. " %%a IN ('ver') DO (
	SET WVer=%%a.%%b.%%c
	SET WMajor=%%a
	SET WMinor=%%b
	SET WRev=%%c
)
:--------------------------------------


:: ScanDisk All <v.arribas.urjc@gmail.com (c) 2014 BSD-Clause 3>
:--------------------------------------
@echo off
REM The System Drive must be specially treated.
SET SYSTEM_DRIVE=C:

REM check Win8+ capabilities (requires WindowsVersionChecker)
set Win8=0
if 6 LEQ %WMajor% if 2 LEQ %WMinor% (set Win8=1)

REM ^, -- ^ is the escape character for declarations  between '
for /f "skip=1 tokens=1,2 delims= " %%a in ('wmic logicaldisk get caption^,filesystem') do (
	if "%%a" == "%SYSTEM_DRIVE%" (
		if %Win8% == 1 (
			echo ### Read-Only ScanDisk of System Drive %%a
			chkdsk /scan /perf /forceofflinefix %%a
			echo ### Run System File Checker on System Drive %%a
			sfc /scannow
		) else (
			echo Set ### System Drive %%a as dirty to force boot-scandisk scan
			fsutil dirty set %%a
		)
	) else if "%%b" == "NTFS" (
		echo ### Two-steps ScanDisk of %%b unit %%a
		if %Win8% == 1 (
			REM http://www.minasi.com/newsletters/nws1305.htm (chkdsk Win 8+ features)
			chkdsk /scan /perf /forceofflinefix %%a
			chkdsk /X /offlinescanandfix %%a
		) else (
			REM Old scan (backward compatibility <Win 8)
			chkdsk /F /X %%a
			chkdsk /F /X /R /B %%a
		)
	) else if "%%b" == "FAT32" (
		echo ### Two-steps ScanDisk of %%b unit %%a
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
