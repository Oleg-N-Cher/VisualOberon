@ECHO OFF
CD ..\obj
SET PATH=..\..\win32\bin;%PATH%
SET OBERON=.;..\sym;..\..\..\src\OO2C

ofront+ -sC -48 Strings.ob2 LongStrings.ob2
IF errorlevel 1 PAUSE

FOR %%i IN (*.sym) DO MOVE /Y %%i ..\sym >NUL
