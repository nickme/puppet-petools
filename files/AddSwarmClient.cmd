REM
REM Install Java and the Swarm client into the winpe image.
REM

@echo on
REM BASEDIR=%1
set BASEDIR=C:\winpe
set WINPEDIR=%BASEDIR%
set BUILDDIR=%WINPEDIR%\build
set MOUNTDIR=%WINPEDIR%\build\mount
set INST=%WINPEDIR%\src

set ARCH=amd64
set ADKDIR=C:\Program Files (x86)\Windows Kits\8.0\Assessment and Deployment Kit
set ADKSOURCE=%ADKDIR%\Windows Preinstallation Environment\%ARCH%\WinPE_OCs

set JRE_URL=http://javadl.sun.com/webapps/download/AutoDL?BundleId=81821
set JAVA_FILE=jre-7u45-windows-x64.exe

set SWARM_VERSION=1.10
set SWARM_CLIENT_URL=http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/%SWARM_VERSION%
set SWARM_CLIENT_DEP=swarm-client-%SWARM_VERSION%-jar-with-dependencies.jar

set WRAPPERSOURCE=C:\ProgramData\PuppetLabs\puppet\etc\modules\extra_files\jenkins\wrapper
set VNCSOURCE=C:\ProgramData\PuppetLabs\puppet\etc\modules\extra_files\TightVNC

set TEMPL=ISO
set ISO_FILE=winpe-%ARCH%-jenkins-swarm.iso

echo "cleanup previous wim mounts"
dism /Cleanup-Wim

echo "Mount Wim file for Advanced configuration" ;
dism /Mount-Wim /WimFile:%BUILDDIR%\winpe.TightVNC.wim /index:1 /MountDir:%MOUNTDIR%

REM
REM Load some additional drivers
REM 
dism /image:%MOUNTDIR% /Add-Driver /driver:%INST%\Drivers\ /recurse /forceunsigned

REM
REM ### JENKINS Slave Installation ###
REM
echo "Create jenkins folders in WinPE image"
if EXIST "%MOUNTDIR%\jenkins\" goto DoJava
  mkdir %MOUNTDIR%\jenkins
  mkdir %MOUNTDIR%\jenkins\workspace
  mkdir %MOUNTDIR%\jenkins\bin
  mkdir %MOUNTDIR%\jenkins\userContent
  mkdir %MOUNTDIR%\jenkins\jre
  REM cd %MOUNTDIR%\jenkins\bin

REM
REM Download and install Java
REM Also put a copy of java.exe in the system dir
REM so it is in the path.
REM
:DoJava
echo "Start Java Download"
if EXIST %INST%\%JAVA_FILE% Goto :InstallJava
  echo "Download jre from web"
  powershell -command "(new-object net.webclient).DownloadFile('%JRE_URL%', '%INST%\%JAVA_FILE%')"
:InstallJava
echo "Start install of Java"
if EXIST %MOUNTDIR%\jenkins\jre\bin Goto :AddJavaToWinpeReg
  %INST%\%JAVA_FILE% /s INSTALLDIR=%MOUNTDIR%\jenkins\jre WEB_JAVA=0 STATIC=1

copy %MOUNTDIR%\jenkins\jre\bin\java.exe %MOUNTDIR%\Windows\System32\

Rem
Rem Now add the Java registry keys into the registry in the winpe image
Rem
:AddJavaToWinpeReg
reg load HKLM\winpe %MOUNTDIR%\Windows\System32\config\SOFTWARE
reg add HKLM\winpe\JavaSoft
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment"
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment" /v CurrentVersion /t REG_SZ /d "1.7"

reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7"
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7" /v JavaHome /t REG_SZ /d %MOUNTDIR%\jenkins\jre
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7" /v MicroVersion /t REG_SZ /d 0
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7" /v RuntimeLib /t REG_SZ /d %MOUNTDIR%\jenkins\jre\bin\client\jvm.dll

reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45"
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45" /v JavaHome /t REG_SZ /d %MOUNTDIR%\jenkins\jre
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45" /v MicroVersion /t REG_SZ /d 0
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45" /v RuntimeLib /t REG_SZ /d %MOUNTDIR%\jenkins\jre\bin\client\jvm.dll

reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI"
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v AUTODATECHECK /t REG_SZ /d 1
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v AUTODATEDELAY /t REG_SZ
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v EULA /t REG_SZ /d 0
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v FROMVERSION /t REG_SZ /d NA
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v FROMVERSIONFULL /t REG_SZ
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v FullVersion /t REG_SZ /d 1.7.0_45-b18
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v IEXPLORER /t REG_SZ
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v ImageCkSum /t REG_SZ /d 3475724115
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v INSTALLDIR /t REG_SZ /d %MOUNTDIR%\jenkins\jre\
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v JAVAUPDATE /t REG_SZ /d 1
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v JQS /t REG_SZ
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v JU /t REG_SZ /d 1
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v MODE /t REG_SZ /d S
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v MOZILLA	/t REG_SZ /d 0
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v OEMUPDATE /t REG_SZ
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v PATCHDIR /t REG_SZ
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v PRODUCTVERSION /t REG_SZ /d 7.0.450
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v WEB_JAVA /t REG_SZ /d 0
reg add "HKLM\winpe\JavaSoft\Java Runtime Environment\1.7.0_45\MSI" /v WEB_JAVA_SECURITY_LEVEL /t REG_SZ

reg unload HKLM\winpe


REM
REM ### DOWNLOAD SWARM CLIENT
REM
echo "Downloading Swarm Client" ;
powershell -command "(new-object net.webclient).DownloadFile('%SWARM_CLIENT_URL%/%SWARM_CLIENT_DEP%', '%MOUNTDIR%\jenkins\bin\%SWARM_CLIENT_DEP%')

REM
REM Copy files required to run swarm client as a Windows service
REM
copy "%WRAPPERSOURCE%\*" "%MOUNTDIR%\jenkins\bin\"

REM
REM Setup swarm client as a Windows service
REM
reg load HKLM\winpe %MOUNTDIR%\Windows\System32\config\SYSTEM
reg add HKLM\winpe\ControlSet001\Services\JenkinsSlave
reg add HKLM\winpe\ControlSet001\Services\JenkinsSlave /v DisplayName /t REG_SZ /d "Jenkins Slave"
reg add HKLM\winpe\ControlSet001\Services\JenkinsSlave /v ErrorControl /t REG_DWORD /d 0x00000001
reg add HKLM\winpe\ControlSet001\Services\JenkinsSlave /v ImagePath /t REG_EXPAND_SZ /d C:\jenkins\bin\jenkins-slave.exe
reg add HKLM\winpe\ControlSet001\Services\JenkinsSlave /v ObjectName /t REG_SZ /d LocalSystem
reg add HKLM\winpe\ControlSet001\Services\JenkinsSlave /v Start /t REG_DWORD /d 0x00000002
reg add HKLM\winpe\ControlSet001\Services\JenkinsSlave /v Type /t REG_DWORD /d 0x00000010 
reg unload HKLM\winpe



REM
REM ### finalize IMAGE
REM
echo "finalize and commit changes to winpe"
dism /Unmount-Wim /MountDir:%MOUNTDIR% /commit
