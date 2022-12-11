@ECHO OFF
CD ..\obj
SET PATH=..\bin;%PATH%
SET OBERON=.;..\sym;..\..\..\src\Windows

ofront+ -s48 Windows.ob2 Example1.ob2 -m Example2.ob2 -m Example3.ob2 -m Example4.ob2 -m
IF errorlevel 1 PAUSE

FOR %%i IN (*.sym) DO MOVE /Y %%i ..\sym >NUL

IF NOT "%XDev%"=="" SET PATH=%XDev%\WinDev\Bin\MinGW\bin
SET StripExe=-nostartfiles ..\..\..\src\Ofront\crt1.c -Wl,-e_WinMain@16
SET CC=gcc.exe %StripExe% -I..\..\..\src\Ofront -m32 -s -Os -g0 -fvisibility=hidden -fomit-frame-pointer -finline-small-functions -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wl,--gc-sections -Wfatal-errors
SET Lib=..\Ofront.a ..\OO2C.a -lgdi32 -static-libgcc
%CC% Example1.c %Lib% -o..\Example1.exe
IF errorlevel 1 PAUSE
%CC% Example2.c %Lib% -o..\Example2.exe
IF errorlevel 1 PAUSE
%CC% Example3.c %Lib% -o..\Example3.exe
IF errorlevel 1 PAUSE
%CC% Example4.c %Lib% -o..\Example4.exe -mwindows
IF errorlevel 1 PAUSE
