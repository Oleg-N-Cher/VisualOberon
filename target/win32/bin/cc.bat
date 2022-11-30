@ECHO OFF
IF NOT "%XDev%"=="" SET PATH=%XDev%\WinDev\Bin\MinGW\bin
CD ..\Obj

SET CC=gcc.exe -m32 -fPIC -Os -g0 -I..\..\Mod -fomit-frame-pointer -finline-small-functions -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -ffunction-sections -Wfatal-errors -c
SET AR=ar.exe -rc ..\VO.a
IF EXIST ..\VO.a DEL ..\VO.a

:: OO2C

%CC% Object.c Strings.c ..\..\Mod\SysClock.c Time.c
IF errorlevel 1 PAUSE
%AR% Object.o Strings.o SysClock.o Time.o

:: VO_Prefs

%CC% VO_Prefs_Base.c
IF errorlevel 1 PAUSE
%AR% VO_Prefs_Base.o

:: VO_Base

%CC% VO_Base_DragDrop.c VO_Base_Object.c VO_Base_Event.c VO_Base_Util.c
IF errorlevel 1 PAUSE
%AR% VO_Base_DragDrop.o VO_Base_Object.o VO_Base_Event.o VO_Base_Util.o

DEL /Q *.o
