@ECHO OFF
IF NOT "%XDev%"=="" SET PATH=%XDev%\WinDev\Bin\MinGW64\bin
CD ..\obj

SET CC=gcc.exe -m64 -fPIC -Os -g0 -I..\..\..\src\Ofront -I..\..\..\src\OO2C -I. -fomit-frame-pointer -finline-small-functions -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -ffunction-sections -Wfatal-errors -c
SET AR=ar.exe -rc ..\OO2C.a
IF EXIST ..\OO2C.a DEL ..\OO2C.a

%CC% Ascii.c CharClass.c ConvTypes.c IntConv.c IntStr.c LongStrings.c ^
  Msg.c Strings.c ..\..\..\src\OO2C\SysClock.c Time.c

IF errorlevel 1 PAUSE
%AR% Ascii.o CharClass.o ConvTypes.o IntConv.o IntStr.o LongStrings.o ^
  Msg.o Strings.o SysClock.o Time.o

DEL /Q *.o
