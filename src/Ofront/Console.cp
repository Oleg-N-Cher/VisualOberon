MODULE Console;  (* J. Templ, 29-June-96 *)

  (* output to Unix/Windows standard output device StdOut *)

  IMPORT SYSTEM, Platform;

  VAR line: ARRAY 128 OF SHORTCHAR;
    pos: INTEGER;

  PROCEDURE Flush*;
  VAR error: Platform.ErrorCode;
  BEGIN
    error := Platform.Write(Platform.StdOut, SYSTEM.ADR(line), pos);
    pos := 0;
  END Flush;

  PROCEDURE Char*(ch: SHORTCHAR);
  BEGIN
    IF pos = LEN(line) THEN Flush() END ;
    line[pos] := ch;  INC(pos);
    IF ch = 0AX THEN Flush() END
  END Char;

  PROCEDURE String*(IN s: ARRAY OF SHORTCHAR);
    VAR i: INTEGER;
  BEGIN i := 0;
    WHILE s[i] # 0X DO Char(s[i]); INC(i) END
  END String;

  PROCEDURE Int*(i, n: INTEGER);
    VAR s: ARRAY 16 OF SHORTCHAR; i1, k: INTEGER;
  BEGIN
    IF i = SYSTEM.LSH(SYSTEM.VAL(INTEGER, 1), SIZE(INTEGER)*8 - 1) THEN
      IF SIZE(INTEGER) = 4 THEN s := "8463847412"; k := 10
      ELSE s := "86723"; k := 5
      END
    ELSE
      i1 := ABS(i);
      s[0] := SHORT(CHR(i1 MOD 10 + ORD("0"))); i1 := i1 DIV 10; k := 1;
      WHILE i1 > 0 DO s[k] := SHORT(CHR(i1 MOD 10 + ORD("0"))); i1 := i1 DIV 10; INC(k) END
    END ;
    IF i < 0 THEN s[k] := "-"; INC(k) END ;
    WHILE n > k DO Char(" "); DEC(n) END ;
    WHILE k > 0 DO  DEC(k); Char(s[k]) END
  END Int;

  PROCEDURE LongInt*(i: LONGINT; n: INTEGER);
    VAR s: ARRAY 24 OF SHORTCHAR; i1: LONGINT; k: INTEGER;
  BEGIN
    IF i = SYSTEM.LSH(SYSTEM.VAL(LONGINT, 1), SIZE(LONGINT)*8 - 1) THEN
      IF SIZE(LONGINT) = 8 THEN s := "8085774586302733229"; k := 19
      ELSE s := "8463847412"; k := 10
      END
    ELSE
      i1 := ABS(i);
      s[0] := SHORT(CHR(i1 MOD 10 + ORD("0"))); i1 := i1 DIV 10; k := 1;
      WHILE i1 > 0 DO s[k] := SHORT(CHR(i1 MOD 10 + ORD("0"))); i1 := i1 DIV 10; INC(k) END
    END ;
    IF i < 0 THEN s[k] := "-"; INC(k) END ;
    WHILE n > k DO Char(" "); DEC(n) END ;
    WHILE k > 0 DO  DEC(k); Char(s[k]) END
  END LongInt;

  PROCEDURE Ln*;
  BEGIN String(Platform.NewLine)  (* Unix/Windows end-of-line *)
  END Ln;

  PROCEDURE Bool*(b: BOOLEAN);
  BEGIN IF b THEN String("TRUE") ELSE String("FALSE") END
  END Bool;

  PROCEDURE Hex*(i: INTEGER);
    VAR k, n: INTEGER;
  BEGIN
    IF SIZE(INTEGER) = 4 THEN k := -28 ELSE k := -12 END;
    WHILE k <= 0 DO
      n := ASH(i, k) MOD 16;
      IF n <= 9 THEN Char(SHORT(CHR(ORD("0") + n))) ELSE Char(SHORT(CHR(ORD("A") - 10 + n))) END ;
      INC(k, 4)
    END
  END Hex;

  PROCEDURE LongHex*(i: LONGINT);
    VAR k, n: INTEGER;
  BEGIN
    IF SIZE(LONGINT) = 8 THEN k := -60 ELSE k := -28 END;
    WHILE k <= 0 DO
      n := SHORT(ASH(i, k)) MOD 16;
      IF n <= 9 THEN Char(SHORT(CHR(ORD("0") + n))) ELSE Char(SHORT(CHR(ORD("A") - 10 + n))) END ;
      INC(k, 4)
    END
  END LongHex;

  PROCEDURE Read*(VAR ch: SHORTCHAR);
    VAR n: INTEGER; error: Platform.ErrorCode;
  BEGIN Flush();
    error := Platform.ReadBuf(Platform.StdIn, SYSTEM.THISARR(SYSTEM.ADR(ch), 1), n);
    IF n # 1 THEN ch := 0X END
  END Read;

  PROCEDURE ReadLine*(VAR line: ARRAY OF SHORTCHAR);
    VAR i: INTEGER; ch: SHORTCHAR;
  BEGIN Flush();
    i := 0; Read(ch);
    WHILE (i < LEN(line) - 1) & (ch # 0AX) & (ch # 0X) DO line[i] := ch; INC(i); Read(ch) END ;
    line[i] := 0X
  END ReadLine;

BEGIN pos := 0;
END Console.
