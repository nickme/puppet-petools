
@echo on
set MOUNTDIR=C:\winpe\build\mount
set VNCSOURCE=C:\ProgramData\PuppetLabs\puppet\etc\modules\scratch\tightVNC

REM
REM Install the Tight VNC Server
REM
mkdir "%MOUNTDIR%\Program Files\TightVNC"
copy "%VNCSOURCE%\*" "%MOUNTDIR%\Program Files\TightVNC\"

reg load HKLM\winpe %MOUNTDIR%\Windows\System32\config\SYSTEM

reg add HKLM\winpe\ControlSet001\Services\tvnserver
reg add HKLM\winpe\ControlSet001\Services\tvnserver /v DisplayName    /t REG_SZ        /d "TightVNC Server"
reg add HKLM\winpe\ControlSet001\Services\tvnserver /v ErrorControl   /t REG_DWORD     /d 0x00000001
reg add HKLM\winpe\ControlSet001\Services\tvnserver /v FailureActions /t REG_BINARY    /d "00000000000000000000000001000000140000000100000088130000"
reg add HKLM\winpe\ControlSet001\Services\tvnserver /v ImagePath      /t REG_EXPAND_SZ /d "\"C:\Program Files\TightVNC\tvnserver.exe\" -service"
reg add HKLM\winpe\ControlSet001\Services\tvnserver /v ObjectName     /t REG_SZ        /d "LocalSystem"
reg add HKLM\winpe\ControlSet001\Services\tvnserver /v Start          /t REG_DWORD     /d 0x00000002
reg add HKLM\winpe\ControlSet001\Services\tvnserver /v Type           /t REG_DWORD     /d 0x00000010

reg unload HKLM\winpe


REM
REM Update the Software key
REM
reg load HKLM\winpe %MOUNTDIR%\Windows\System32\config\SOFTWARE

reg add HKLM\winpe\TightVNC
reg add HKLM\winpe\TightVNC\Server
reg add HKLM\winpe\TightVNC\Server /v AcceptHttpConnections       /t REG_DWORD /d 0x1
reg add HKLM\winpe\TightVNC\Server /v AcceptRfbConnections        /t REG_DWORD /d 0x1
reg add HKLM\winpe\TightVNC\Server /v AllowLoopback               /t REG_DWORD /d 0x0
reg add HKLM\winpe\TightVNC\Server /v AlwaysShared                /t REG_DWORD /d 0x0
reg add HKLM\winpe\TightVNC\Server /v BlockLocalInput             /t REG_DWORD /d 0x0
reg add HKLM\winpe\TightVNC\Server /v BlockRemoteInput            /t REG_DWORD /d 0x0
reg add HKLM\winpe\TightVNC\Server /v DisconnectAction            /t REG_DWORD /d 0x0
reg add HKLM\winpe\TightVNC\Server /v DisconnectClients           /t REG_DWORD /d 0x1
reg add HKLM\winpe\TightVNC\Server /v EnableFileTransfers         /t REG_DWORD /d 0x1
reg add HKLM\winpe\TightVNC\Server /v EnableUrlParams             /t REG_DWORD /d 0x1
reg add HKLM\winpe\TightVNC\Server /v ExtraPorts                  /t REG_SZ
reg add HKLM\winpe\TightVNC\Server /v GrabTransparentWindows      /t REG_DWORD /d 0x1
reg add HKLM\winpe\TightVNC\Server /v HttpPort                    /t REG_DWORD /d 0x16a8
reg add HKLM\winpe\TightVNC\Server /v IpAccessControl             /t REG_SZ
reg add HKLM\winpe\TightVNC\Server /v LocalInputControl           /t REG_DWORD /d 0x0
reg add HKLM\winpe\TightVNC\Server /v LocalInputPriorityTimeout   /t REG_DWORD /d 0x3
reg add HKLM\winpe\TightVNC\Server /v LogLevel                    /t REG_DWORD /d 0x0
reg add HKLM\winpe\TightVNC\Server /v LoopbacksOnly               /t REG_DWORD /d 0x0
reg add HKLM\winpe\TightVNC\Server /v NeverShared                 /t REG_DWORD /d 0x0
reg add HKLM\winpe\TightVNC\Server /v PollingInterval             /t REG_DWORD /d 0x3e8
reg add HKLM\winpe\TightVNC\Server /v QueryAcceptOnTimeout        /t REG_DWORD /d 0x0
reg add HKLM\winpe\TightVNC\Server /v QueryTimeout                /t REG_DWORD /d 0x1e
reg add HKLM\winpe\TightVNC\Server /v RemoveWallpaper             /t REG_DWORD /d 0x1
reg add HKLM\winpe\TightVNC\Server /v RepeatControlAuthentication /t REG_DWORD /d 0x0
reg add HKLM\winpe\TightVNC\Server /v RfbPort                     /t REG_DWORD /d 0x170c
reg add HKLM\winpe\TightVNC\Server /v RunControlInterface         /t REG_DWORD /d 0x1
reg add HKLM\winpe\TightVNC\Server /v SaveLogToAllUsersPath       /t REG_DWORD /d 0x0
reg add HKLM\winpe\TightVNC\Server /v UseControlAuthentication    /t REG_DWORD /d 0x0
reg add HKLM\winpe\TightVNC\Server /v UseMirrorDriver             /t REG_DWORD /d 0x1
reg add HKLM\winpe\TightVNC\Server /v UseVncAuthentication        /t REG_DWORD /d 0x0
reg add HKLM\winpe\TightVNC\Server /v VideoClasses                /t REG_SZ
reg add HKLM\winpe\TightVNC\Server /v VideoRecognitionInterval    /t REG_DWORD /d 0xbb8

reg unload HKLM\winpe

