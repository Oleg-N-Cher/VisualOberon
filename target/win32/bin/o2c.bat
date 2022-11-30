@ECHO OFF
CD ..\Obj
SET PATH=..\Bin;%PATH%
SET OBERON=.;..\Sym;..\..\Mod

SET oef=
::IF EXIST ..\..\oef.exe SET oef=^| oef

:: OO2C

ofront+ -s -48 C.ob2 Object.ob2 Strings.ob2 SysClock.ob2 Time.ob2 %oef%
IF errorlevel 1 PAUSE

:: VO_Prefs

ofront+ -s -48 VO_Prefs_Base.ob2 %oef%
IF errorlevel 1 PAUSE

:: VO_Base

ofront+ -sO -48 ^
  VO_Base_DragDrop.ob2 VO_Base_Object.ob2 VO_Base_Util.ob2 VO_Base_Event.ob2 ^
  VO_Base_Display.ob2 %oef%
IF errorlevel 1 PAUSE

:: VO_OS_Windows

ofront+ -sO -48 Windows.ob2 %oef%
IF errorlevel 1 PAUSE

FOR %%i IN (*.sym) DO MOVE /Y %%i ..\Sym >NUL
