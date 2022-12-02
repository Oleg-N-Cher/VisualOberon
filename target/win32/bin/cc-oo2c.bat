@ECHO OFF
IF NOT "%XDev%"=="" SET PATH=%XDev%\WinDev\Bin\MinGW\bin
CD ..\obj

SET CC=gcc.exe -m32 -fPIC -Os -g0 -I..\..\..\src\Ofront -fomit-frame-pointer -finline-small-functions -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -ffunction-sections -Wfatal-errors -c
SET AR=ar.exe -rc ..\OO2C.a
IF EXIST ..\OO2C.a DEL ..\OO2C.a

%CC% Strings.c LongStrings.c
IF errorlevel 1 PAUSE
%AR% Strings.o LongStrings.o

DEL /Q *.o
