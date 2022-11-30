MODULE VO:Base:Size;

(*
    Module for abstracting of size.
    Copyright (C) 2000  Tim Teulings (rael@edge.ping.de)

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

IMPORT D  := VO:Base:Display,
       PP := VO:Prefs:Parser;


CONST
  pixel        * = 0; (* The size is given in pixel, you should avoid this for all costs *)
  screenHRel   * = 1; (* The size is given in procent of screensize (1..100) *)
  screenVRel   * = 2; (* The size is given in procent of screensize (1..100) *)
  unit         * = 3; (* The size is given in relativ units calculated evaluating the screen size *)
  unitP        * = 4; (* The size is given like sizeDefaultRel but in percent *)
  softUnit     * = 5; (* The size is given in relativ units calculated evaluating the screen size - can be zero! *)
  softUnitP    * = 6; (* The size is given like sizeDefaultRel but in percent - can be zero! *)
  stdCharWidth * = 7; (* Average width of the standard font *)

  maxMode      * = 8;

  unknown        = 9; (* No size set *)

   (*
     TODO:

     units which handle aspect ratio correct: aspectUnitHoriz, aspectUnitVert
   *)

TYPE
  Size*     = POINTER TO SizeDesc;
  SizeDesc* = RECORD
                mode- : LONGINT; (* the type of size given *)
                size- : LONGINT; (* the amount of size in units given in mode *)

                pixel : LONGINT; (* the resulting size in pixel *)
              END;

VAR
  valueUnit,
  valueSUnit,
  charWidth : LONGINT;

  PROCEDURE CalculateUnits;

  BEGIN
    valueUnit:=D.display.scrWidth DIV 300;
    valueSUnit:=valueUnit;
    IF valueUnit=0 THEN
      valueUnit:=1;
    END;

    charWidth:=(D.normalFont.TextWidth("m",1,{})+D.normalFont.TextWidth("E",1,{})) DIV 2;
  END CalculateUnits;

  PROCEDURE GetSize*(mode, value : LONGINT):LONGINT;

  VAR
    help : LONGINT;

  BEGIN
    IF valueUnit=-1 THEN
      CalculateUnits;
    END;

    CASE mode OF
      unknown:
    | pixel:
      RETURN value;
    | screenHRel:
      RETURN (value*D.display.scrWidth) DIV 100;
    | screenVRel:
      RETURN (value*D.display.scrHeight) DIV 100;
    | unit:
      RETURN (value*valueUnit);
    | unitP:
      help:=(value*valueUnit) DIV 100;
      IF help=0 THEN
        RETURN 1;
      ELSE
        RETURN help;
      END;
    | softUnit:
      RETURN (value*valueSUnit);
    | softUnitP:
      RETURN (value*valueSUnit) DIV 100;
    | stdCharWidth:
      RETURN value*charWidth;
    ELSE
      ASSERT(FALSE);
    END;

    RETURN 0;
  END GetSize;

  PROCEDURE (VAR s : SizeDesc) Init*();

  BEGIN
    s.mode:=unknown;
    s.size:=0;
    s.pixel:=-1;
  END Init;

  PROCEDURE (VAR s : SizeDesc) SetSize*(mode, size: LONGINT);

  BEGIN
    s.mode:=mode;
    s.size:=size;
    s.pixel:=-1;
  END SetSize;

  PROCEDURE (VAR s: SizeDesc) IsSizeSet*():BOOLEAN;

  BEGIN
    RETURN s.mode#unknown;
  END IsSizeSet;

  PROCEDURE (VAR s : SizeDesc) CalculateSize;

  BEGIN
    s.pixel:=GetSize(s.mode,s.size);
  END CalculateSize;

  PROCEDURE (VAR s : SizeDesc) GetSize*():LONGINT;

  BEGIN
    IF s.pixel=-1 THEN
      s.CalculateSize;
    END;

    RETURN s.pixel;
  END GetSize;

  PROCEDURE CreateSize*():Size;

  VAR
    size : Size;

  BEGIN
    NEW(size);
    size.Init;

    RETURN size;
  END CreateSize;

  PROCEDURE LoadSize*(name : ARRAY OF CHAR; top : PP.Item; VAR size : SizeDesc);

  VAR
    value : ARRAY 256 OF CHAR;
    found : BOOLEAN;

  BEGIN
    top:=top.GetEntry(name);
    IF top=NIL THEN
      RETURN;
    END;

    found:=FALSE;
    IF top.GetStringEntry("mode",value) THEN
      IF value="pixel" THEN
        found:=TRUE;
        size.mode:=pixel;
      ELSIF value="screenHRel" THEN
        found:=TRUE;
        size.mode:=screenHRel;
      ELSIF value="screenVRel" THEN
        found:=TRUE;
        size.mode:=screenVRel;
      ELSIF value="unit" THEN
        found:=TRUE;
        size.mode:=unit;
      ELSIF value="unitP" THEN
        found:=TRUE;
        size.mode:=unitP;
      ELSIF value="softUnit" THEN
        found:=TRUE;
        size.mode:=softUnit;
      ELSIF value="softUnitP" THEN
        found:=TRUE;
        size.mode:=softUnitP;
      ELSIF value="stdCharWidth" THEN
        found:=TRUE;
        size.mode:=stdCharWidth;
      ELSE
      END;
    END;

    IF found THEN
      size.size:=top.GetIntEntry("size",size.size);
    END;
  END LoadSize;

  PROCEDURE SaveSize*(name : ARRAY OF CHAR; top : PP.BlockItem; size : SizeDesc);

  VAR
    block : PP.BlockItem;
    value : PP.ValueItem;

  BEGIN
    IF ~size.IsSizeSet() THEN
      RETURN;
    END;

    block:=PP.CreateBlockItem(name);
    top.AddItem(block);

      NEW(value);
      value.Init;
      CASE size.mode OF
       pixel:
        block.AddItemValue("mode","pixel");
      | screenHRel:
        block.AddItemValue("mode","screenHRel");
      | screenVRel:
        block.AddItemValue("mode","screenVRel");
      | unit:
        block.AddItemValue("mode","unit");
      | unitP:
        block.AddItemValue("mode","unitP");
      | softUnit:
        block.AddItemValue("mode","softUnit");
      | softUnitP:
        block.AddItemValue("mode","softUnitP");
      | stdCharWidth:
        block.AddItemValue("mode","stdCharWidth");
      END;

    block.AddItemInt("size",size.size);
  END SaveSize;

BEGIN
  valueUnit:=-1;
  valueSUnit:=-1;
END VO:Base:Size.