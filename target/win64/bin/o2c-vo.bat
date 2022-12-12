@ECHO OFF
CD ..\obj
SET PATH=..\..\win32\bin;%PATH%
SET OBERON=.;..\sym;..\..\..\src

:: VO_Base

ofront+ -sO48 ^
  VO_Base_DragDrop.ob2 VO_Base_Util.ob2 VO_Base_Event.ob2
IF errorlevel 1 PAUSE

FOR %%i IN (*.sym) DO MOVE /Y %%i ..\sym >NUL
