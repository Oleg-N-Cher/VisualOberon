@ECHO OFF
CD ..\obj
SET PATH=..\bin;%PATH%
SET OBERON=.;..\sym;..\..\..\src\Windows

ofront+ -s -48 Windows.ob2
IF errorlevel 1 PAUSE

FOR %%i IN (*.sym) DO MOVE /Y %%i ..\sym >NUL
