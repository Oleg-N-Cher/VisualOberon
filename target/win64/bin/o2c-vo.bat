@ECHO OFF
CD ..\obj
SET PATH=..\..\win32\bin;%PATH%
SET OBERON=.;..\sym;..\..\..\src

:: VO_Base

ofront+ -s88 ^
  VO_Base_DragDrop.cp VO_Base_Object.cp VO_Base_Util.cp VO_Base_Event.cp
IF errorlevel 1 PAUSE

FOR %%i IN (*.sym) DO MOVE /Y %%i ..\sym >NUL
