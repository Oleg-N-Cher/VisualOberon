@ECHO OFF
IF NOT "%XDev%"=="" SET PATH=%XDev%\WinDev\Bin\MinGW\bin
CD ..\obj

SET CC=gcc.exe -m32 -fPIC -Os -g0 -I..\..\..\src\Ofront -I..\..\..\src\OO2C -I. -fomit-frame-pointer -finline-small-functions -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -ffunction-sections -Wfatal-errors -c
SET AR=ar.exe -rc ..\VO.a
IF EXIST ..\VO.a DEL ..\VO.a

%CC% VO_Base_DragDrop.c VO_Base_Object.c VO_Base_Util.c VO_Base_Event.c
IF errorlevel 1 PAUSE

%AR% VO_Base_DragDrop.o VO_Base_Object.o VO_Base_Util.o VO_Base_Event.o

DEL /Q *.o
