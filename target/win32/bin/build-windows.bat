@ECHO OFF
CD ..\obj
SET PATH=..\bin;%PATH%
SET OBERON=.;..\sym;..\..\..\src\Windows

ofront+ -s -48 Windows.ob2 Example1.ob2 -m Example2.ob2 -m Example3.ob2 -m Example4.ob2 -m
IF errorlevel 1 PAUSE

FOR %%i IN (*.sym) DO MOVE /Y %%i ..\sym >NUL
