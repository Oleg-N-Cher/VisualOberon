(*	$Id: Time.cp,v 1.2 2022/12/12 4:57:14 mva Exp $	*)
MODULE Time;
(*  Time - time and time interval manipulation.       
    Copyright (C) 1996 Michael Griebling
 
    This module is free software; you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as 
    published by the Free Software Foundation; either version 2 of the
    License, or (at your option) any later version.
 
    This module is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.
 
    You should have received a copy of the GNU Lesser General Public
    License along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

*)

IMPORT SysClock;

CONST
  msecPerSec*  = 1000;
  (**Number of millseconds in a second.  *)
  msecPerMin*  = msecPerSec*60;
  (**Number of millseconds in a minute.  *)
  msecPerHour* = msecPerMin*60;
  (**Number of millseconds in an hour.  *)
  msecPerDay * = msecPerHour*24;
  (**Number of millseconds in a day.  *)
       
TYPE    
  TimeStamp* =
    RECORD
      (**The TimeStamp is a compressed date/time format with the advantage over
         the Unix time stamp of being able to represent any date/time in the
         @otype{SysClock.DateTime} type.  @emph{Note}: @otype{TimeStamp} is in
         UTC or local time when time zones are not supported by the local
         operating system.  *)
      
      days-:  INTEGER;
      (**Modified Julian days since @samp{17 Nov 1858}.  This quantity can be
         negative to represent dates occuring before day zero.  *)
      msecs-: INTEGER;
      (**Milliseconds since @samp{00:00}.  *)
    END;
  
  Interval* =
    RECORD
      (**The Interval is a delta time measure which can be used to increment
         a @otype{TimeStamp} or find the time difference between two
         @otype{TimeStamp}s.  The maximum number of milliseconds in an interval
         will be the value @oconst{msecPerDay}.  *)
      dayInt-:  INTEGER;
      (**Number of days in this interval.  *)
      msecInt-: INTEGER
      (**The number of milliseconds in this interval.  This number
         is from [0, @oconst{msecPerDay}[.  *)
    END; 
     

(* ------------------------------------------------------------- *)
(* TimeStamp functions *)

PROCEDURE InitTimeStamp* (OUT t: TimeStamp; days, msecs: INTEGER);
(**Initialize the TimeStamp @oparam{t} with @oparam{days} days and
   @oparam{msecs} mS.

   @precond
   msecs>=0
   @end precond *)
BEGIN
  t.msecs:=msecs MOD msecPerDay;
  t.days:=days + msecs DIV msecPerDay
END InitTimeStamp;

PROCEDURE GetTime* (OUT t: TimeStamp);
(**Set @oparam{t} to the current time of day.  In case of failure (that is, if
   SysClock.CanGetClock() is @code{FALSE}) the time @samp{00:00 UTC} on
   @samp{Jan 1 1970} is returned.  This procedure is typically much faster than
   doing @oproc{SysClock.GetClock} followed by @oproc{*Calendar.SetTimeStamp}.  *)
  VAR
    res, sec, usec: INTEGER;
  BEGIN
    res := SysClock.GetTimeOfDay (sec, usec);
    t. days := 40587+sec DIV 86400;
    t. msecs := (sec MOD 86400)*msecPerSec + usec DIV 1000
  END GetTime;


PROCEDURE (VAR a: TimeStamp) Add* (IN b: Interval), NEW;
(**Adds the interval @oparam{b} to the time stamp @oparam{a}. *) 
BEGIN
  INC(a.msecs, b.msecInt);
  INC(a.days, b.dayInt);
  IF a.msecs>=msecPerDay THEN 
    DEC(a.msecs, msecPerDay); INC(a.days) 
  END
END Add;

PROCEDURE (VAR a: TimeStamp) Sub* (IN b: Interval), NEW;
(**Subtracts the interval @oparam{b} from the time stamp @oparam{a}. *) 
BEGIN
  DEC(a.msecs, b.msecInt);
  DEC(a.days, b.dayInt);
  IF a.msecs<0 THEN INC(a.msecs, msecPerDay); DEC(a.days) END
END Sub;

PROCEDURE (IN a: TimeStamp) Delta* (IN b: TimeStamp; OUT c: Interval), NEW;
(**@postcond
   c = a - b
   @end postcond *) 
BEGIN
  c.msecInt:=a.msecs-b.msecs;
  c.dayInt:=a.days-b.days;
  IF c.msecInt<0 THEN 
    INC(c.msecInt, msecPerDay); DEC(c.dayInt)
  END
END Delta;

PROCEDURE (IN a: TimeStamp) Cmp* (IN b: TimeStamp) : BYTE, NEW;
(**Compares @oparam{a} to @oparam{b}.  Result:

   @table @code
   @item -1
   a<b
   @item 0
   a=b
   @item 1
   a>b
   @end table

   This means the comparison can be directly extrapolated to a comparison
   between the two numbers, for example,

   @example
   Cmp(a,b)<0  then a<b
   Cmp(a,b)=0  then a=b
   Cmp(a,b)>0  then a>b
   Cmp(a,b)>=0 then a>=b
   @end example  *)
BEGIN
  IF (a.days>b.days) OR (a.days=b.days) & (a.msecs>b.msecs) THEN RETURN 1
  ELSIF (a.days=b.days) & (a.msecs=b.msecs) THEN RETURN 0
  ELSE RETURN -1
  END
END Cmp;


(* ------------------------------------------------------------- *)
(* Interval functions *)

PROCEDURE InitInterval* (OUT int: Interval; days, msecs: INTEGER);
(**Initialize the Interval @oparam{int} with @oparam{days} days and
   @oparam{msecs} mS.

   @precond
   msecs>=0
   @end precond  *)
BEGIN
  int.dayInt:=days + msecs DIV msecPerDay;
  int.msecInt:=msecs MOD msecPerDay
END InitInterval;

PROCEDURE (VAR a: Interval) Add* (IN b: Interval), NEW;
(**@postcond
   a = a + b
   @end postcond *) 
BEGIN
  INC(a.msecInt, b.msecInt);
  INC(a.dayInt, b.dayInt);
  IF a.msecInt>=msecPerDay THEN 
    DEC(a.msecInt, msecPerDay); INC(a.dayInt)
  END
END Add;

PROCEDURE (VAR a: Interval) Sub* (IN b: Interval), NEW;
(**@postcond
   a = a - b
   @end postcond *) 
BEGIN
  DEC(a.msecInt, b.msecInt);
  DEC(a.dayInt, b.dayInt);
  IF a.msecInt<0 THEN 
    INC(a.msecInt, msecPerDay); DEC(a.dayInt)
  END
END Sub;

PROCEDURE (IN a: Interval) Cmp* (IN b: Interval) : BYTE, NEW;
(**Compares @oparam{a} to @oparam{b}.  Result:

   @table @code
   @item -1
   a<b
   @item 0
   a=b
   @item 1
   a>b
   @end table

   This means the comparison can be directly extrapolated to a comparison
   between the two numbers, for example,

   @example
   Cmp(a,b)<0  then a<b
   Cmp(a,b)=0  then a=b
   Cmp(a,b)>0  then a>b
   Cmp(a,b)>=0 then a>=b
   @end example  *)
BEGIN
  IF (a.dayInt>b.dayInt) OR (a.dayInt=b.dayInt)&(a.msecInt>b.msecInt) THEN RETURN 1
  ELSIF (a.dayInt=b.dayInt) & (a.msecInt=b.msecInt) THEN RETURN 0
  ELSE RETURN -1
  END
END Cmp;

PROCEDURE (VAR a: Interval) Scale* (b: REAL), NEW;
(**@precond
   b>=0;
   @end precond
   
   @postcond
   a := a*b
   @end postcond *) 
VAR
  si: REAL;
BEGIN
  si:=(a.dayInt+a.msecInt/msecPerDay)*b;
  a.dayInt:=SHORT( ENTIER(si) );
  a.msecInt:=SHORT( ENTIER((si-a.dayInt)*msecPerDay+0.5E0) )
END Scale;

PROCEDURE (IN a: Interval) Fraction* (IN b: Interval) : REAL, NEW;
(**@precond
   b<>0
   @end precond
   
   @postcond
   RETURN a/b
   @end postcond *) 
BEGIN
  RETURN (a.dayInt+a.msecInt/msecPerDay)/(b.dayInt+b.msecInt/msecPerDay)
END Fraction;

END Time.
