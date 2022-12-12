MODULE SysClockTest; IMPORT Out := Console, SysClock;
VAR
  dt: SysClock.DateTime;
BEGIN
  Out.String("CanGetClock: "); Out.Bool(SysClock.CanGetClock()); Out.Ln;
  Out.String("CanSetClock: "); Out.Bool(SysClock.CanSetClock()); Out.Ln;
  SysClock.GetClock(dt);
  Out.String("IsValidDateTime: "); Out.Bool(SysClock.IsValidDateTime(dt)); Out.Ln;
  Out.String("year = "); Out.Int(dt.year, 0); Out.Char(" ");
  Out.String("month = "); Out.Int(dt.month, 0); Out.Char(" ");
  Out.String("day = "); Out.Int(dt.day, 0); Out.Ln;
  Out.String("hour = "); Out.Int(dt.hour, 0); Out.Char(" ");
  Out.String("minute = "); Out.Int(dt.minute, 0); Out.Char(" ");
  Out.String("second = "); Out.Int(dt.second, 0); Out.Ln;
  Out.String("summerTimeFlag = "); Out.Int(dt.summerTimeFlag, 0); Out.Char(" ");
  Out.String("fractions = "); Out.Int(dt.fractions, 0); Out.Char(" ");
  Out.String("zone = "); Out.Int(dt.zone, 0); Out.Ln;
  dt.year := -1;  Out.String("IsValidDateTime for year = -1 : "); 
  Out.Bool(SysClock.IsValidDateTime(dt)); Out.Ln;
END SysClockTest.
