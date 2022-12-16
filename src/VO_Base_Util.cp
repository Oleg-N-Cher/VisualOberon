MODULE VO_Base_Util (*OOC_EXTENSIONS*);

  (**
    A number of utility functions.
  *)

  (*
    Utility functions for VisualOberon.
    Copyright (C) 1997 Tim Teulings (rael@edge.ping.de)

    This module is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public License
    as published by the Free Software Foundation; either version 2 of
    the License, or (at your option) any later version.

    This module is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with VisualOberon. If not, write to the Free Software Foundation,
    59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *)

IMPORT      C;

TYPE
  Text* = POINTER TO ARRAY OF SHORTCHAR;
  LongText* = POINTER TO ARRAY OF CHAR;

  (* Some tool-functions *)

  PROCEDURE MaxInt*(a,b : INTEGER):INTEGER;

    (**
      Returns the maximum of @oparam{a} and @oparam{b}.
    *)

  BEGIN
    IF a>=b THEN
      RETURN a;
    ELSE
      RETURN b;
    END;
  END MaxInt;

  PROCEDURE MinInt*(a,b : INTEGER):INTEGER;

    (**
      Returns the minumum of @oparam{a} and @oparam{b}.
    *)

  BEGIN
    IF a<=b THEN
      RETURN a;
    ELSE
      RETURN b;
    END;
  END MinInt;

  PROCEDURE RoundRange*(x,a,b : INTEGER):INTEGER;

    (**
      If @oparam{x}>b then @oparam{b} will be returned.
      If @oparam{x}<a then @oparam{a} will be returned.
      Else @oparam{x} will be returned.
    *)

  BEGIN
    IF x<a THEN
      RETURN a;
    ELSIF x>b THEN
      RETURN b;
    ELSE
      RETURN x;
    END;
  END RoundRange;

  PROCEDURE UpDiv*(a,b : INTEGER):INTEGER;

  BEGIN
    IF a DIV b=0 THEN
      IF a<0 THEN
        RETURN -1;
      ELSIF a>0 THEN
        RETURN 1;
      ELSE
        RETURN 0;
      END;
    ELSE
      RETURN a DIV b;
    END;
  END UpDiv;

  PROCEDURE RoundDiv*(a,b :INTEGER):INTEGER;

    (**
      Rounds to the nearest integer number.
    *)

  VAR
    c : INTEGER;

  BEGIN
    c:=a DIV b;
    IF a MOD b>=b DIV 2 THEN
      INC(c);
    END;
    RETURN c;
  END RoundDiv;

  PROCEDURE RoundUpEven*(a : INTEGER):INTEGER;

    (**
      Rounds the number so that is is even. Currently only works correctly for
      numbers greater zero.
    *)

  BEGIN
    IF a DIV 2>0 THEN
      RETURN a+1;
    ELSE
      RETURN a;
    END;
  END RoundUpEven;

  PROCEDURE CStringToText*(string : C.string):Text;

  VAR
    length : INTEGER;
    text   : Text;

  BEGIN
    IF string=NIL THEN
      NEW(text,1);
      text[0]:=0X;
    ELSE
      length:=0;
      WHILE string[length]#0X DO
        INC(length);
      END;
      INC(length);
      NEW(text,length);
      DEC(length);
      WHILE length>=0 DO
        text[length]:=string[length];
        DEC(length);
      END;
    END;
    RETURN text;
  END CStringToText;

  PROCEDURE CStringToLongText*(string : C.string):LongText;

  VAR
    length : INTEGER;
    text   : LongText;

  BEGIN
    IF string=NIL THEN
      NEW(text,1);
      text[0]:=0X;
    ELSE
      length:=0;
      WHILE string[length]#0X DO
        INC(length);
      END;
      INC(length);
      NEW(text,length);
      DEC(length);
      WHILE length>=0 DO
        text[length]:=string[length];
        DEC(length);
      END;
    END;
    RETURN text;
  END CStringToLongText;

  PROCEDURE StringToText*(IN string : ARRAY OF SHORTCHAR):Text;

  VAR
    text : Text;

  BEGIN
    NEW(text,LEN(string$)+1);
    text^ := string$;

    RETURN text;
  END StringToText;

END VO_Base_Util.
