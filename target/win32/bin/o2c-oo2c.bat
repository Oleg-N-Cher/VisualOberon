@ECHO OFF
CD ..\obj
SET PATH=..\..\win32\bin;%PATH%
SET OBERON=.;..\sym;..\..\..\src\OO2C

ofront+ -s48 Ascii.cp C.cp CharClass.cp ConvTypes.cp HashCode.cp IntConv.cp ^
  IntStr.cp LongStrings.cp LRealMath.cp Msg.cp RealMath.cp Strings.cp ^
  SysClock.cp Time.cp Channel.cp

IF errorlevel 1 PAUSE

FOR %%i IN (*.sym) DO MOVE /Y %%i ..\sym >NUL
