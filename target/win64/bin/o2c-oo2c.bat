@ECHO OFF
CD ..\obj
SET PATH=..\..\win32\bin;%PATH%
SET OBERON=.;..\sym;..\..\..\src\OO2C

ofront+ -s88 Ascii.cp C.cp CharClass.cp ConvTypes.cp IntConv.cp IntStr.cp ^
  LongStrings.cp Msg.cp Strings.cp SysClock.cp Time.cp

IF errorlevel 1 PAUSE

FOR %%i IN (*.sym) DO MOVE /Y %%i ..\sym >NUL
