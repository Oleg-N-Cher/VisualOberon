@ECHO OFF
IF NOT "%XDev%"=="" SET PATH=%XDev%\WinDev\Bin\MinGW\bin
CD ..\obj

SET CC=gcc.exe -m32 -fPIC -Os -g0 -I..\..\..\src\Ofront -fomit-frame-pointer -finline-small-functions -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -ffunction-sections -Wfatal-errors -c
SET AR=ar.exe -rc ..\Ofront.a
IF EXIST ..\Ofront.a DEL ..\Ofront.a

%CC% ..\..\..\src\Ofront\SYSTEM.c Heap.c Platform.c Console.c Kernel.c
IF errorlevel 1 PAUSE
%AR% SYSTEM.o Heap.o Platform.o Console.o Kernel.o

DEL /Q *.o
