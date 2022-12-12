@ECHO OFF
IF NOT "%XDev%"=="" SET PATH=%XDev%\WinDev\Bin\MinGW64\bin
CD ..\obj
SET StripExe=-nostartfiles ..\..\..\src\Ofront\crt1.c -Wl,-eWinMain
SET CC=gcc.exe %StripExe% -I..\..\..\src\Ofront -m64 -s -Os -g0 -fvisibility=hidden -fomit-frame-pointer -finline-small-functions -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wl,--gc-sections -Wfatal-errors
SET Lib=..\Ofront.a ..\OO2C.a -lgdi32 -static-libgcc

%CC% SysClockTest.c %Lib% -o..\SysClockTest.exe
IF errorlevel 1 PAUSE
