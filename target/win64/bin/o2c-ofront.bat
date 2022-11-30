@ECHO OFF
CD ..\obj
SET PATH=..\..\win32\bin;%PATH%
SET OBERON=.;..\sym;..\..\..\src\Ofront

ofront+ -sC -88 Heap.cp -apx Platform.Windows.cp -atpx Console.cp Kernel.cp -atpx
IF errorlevel 1 PAUSE

FOR %%i IN (*.sym) DO MOVE /Y %%i ..\sym >NUL
