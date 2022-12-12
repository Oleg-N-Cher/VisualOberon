@ECHO OFF
CD ..\obj
SET PATH=..\..\win32\bin;%PATH%
SET OBERON=.;..\sym;..\..\..\src\OO2C

ofront+ -s48m SysClockTest.cp
IF errorlevel 1 PAUSE
