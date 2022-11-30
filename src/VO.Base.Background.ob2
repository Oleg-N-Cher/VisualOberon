MODULE VO:Base:Background;

  (**
    Implements different background objects.
  *)

  (*
    Implements some classes for drawing object backgrounds in various ways.
    Copyright (C) 1998 Tim Teulings (rael@edge.ping.de)

    This file is part of VisualOberon.

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
       U  := VO:Base:Util,

       I   := VO:Image:Image,
              VO:Image:Loader,
  <*PUSH; Warnings:=FALSE; *>
              VO:Image:Loader:All,
  <* POP *>

       PP := VO:Prefs:Parser,

       G  := VO:Object,

             Err;

CONST
  relativeMode* = 0; (** Draw image background relative to base object *)
  absoluteMode* = 1; (** Draw image background by scaling it to the draw area *)

  normal*   = 0; (** Normal background *)
  selected* = 1; (** Selected background *)

  size      = 2;

TYPE
  Name                   = ARRAY 20 OF CHAR;

  Fill*                  = POINTER TO FillDesc;
  FillDesc               = RECORD [ABSTRACT]
                           END;

  PlainFill              = POINTER TO PlainFillDesc;
  PlainFillDesc          = RECORD (FillDesc)
                             (**
                               Draw background using a plain color.
                             *)
                             color  : D.Color;
                             index  : LONGINT;
                             inited : BOOLEAN;
                           END;

  ImageFill*             = POINTER TO ImageFillDesc;
  ImageFillDesc*         = RECORD (FillDesc)
                             image    : I.Image;
                             filename : U.Text;
                             bitmap   : D.Bitmap;
                             mode     : LONGINT;
                             x,y,w,h  : LONGINT;
                           END;

  TileFill*              = POINTER TO TileFillDesc;
  TileFillDesc*          = RECORD (FillDesc)
                             (**
                               Draw background by tiling an image.
                             *)
                             image    : I.Image;
                             filename : U.Text;
                             x,y,w,h  : LONGINT;
                           END;

  PatternFill*           = POINTER TO PatternFillDesc;
  PatternFillDesc*       = RECORD (FillDesc)
                             (**
                               Draw background by using a two color chess pattern.
                             *)
                             bitmap  : D.Bitmap;
                             (*index   : LONGINT;*) (* Not used yet *)
                             fg      : D.Color;
                             fgIndex : LONGINT;
                             bg      : D.Color;
                             bgIndex : LONGINT;
                             inited  : BOOLEAN;
                           END;

  Background*            = POINTER TO BackgroundDesc;
  BackgroundDesc*        = RECORD (G.BackgroundDesc)
                             fills : ARRAY size OF Fill;
                           END;

VAR
  names : ARRAY size OF Name;

  PROCEDURE (f : Fill) [ABSTRACT] Draw*(draw : D.DrawInfo;
                                        xOff,yOff,width,height,
                                        x,y,w,h : LONGINT);
  END Draw;

  PROCEDURE (f : Fill) [ABSTRACT] Copy*():Fill;
  END Copy;

  PROCEDURE (f : Fill) [ABSTRACT] Free*;
  END Free;

  (* --------- *)

  PROCEDURE (b : Background) Init*;

  VAR
    x : LONGINT;

  BEGIN
    FOR x:=0 TO size-1 DO
      b.fills[x]:=NIL;
    END;
  END Init;

  PROCEDURE (b : Background) CanDraw*(draw : D.DrawInfo):BOOLEAN;

  BEGIN
    IF D.selected IN draw.mode THEN
      RETURN b.fills[selected]#NIL;
    ELSE
      RETURN b.fills[normal]#NIL;
    END;
  END CanDraw;

  PROCEDURE (b : Background) Copy*():G.Background;

  VAR
    copy : Background;
    x    : LONGINT;

  BEGIN
    NEW(copy);
    copy^:=b^;

    FOR x:=0 TO size-1 DO
      IF b.fills[x]#NIL THEN
        copy.fills[x]:=b.fills[x].Copy();
      ELSE
        copy.fills[x]:=NIL;
      END;
    END;

    RETURN copy;
  END Copy;

  PROCEDURE (b : Background) Draw*(draw : D.DrawInfo;
                                   relX,relY,relWidth,relHeight,
                                   x,y,w,h : LONGINT);

  BEGIN
    IF ~((w>0) & (h>0)) THEN
      RETURN;
    END;

    IF D.selected IN draw.mode THEN
      IF b.fills[selected]#NIL THEN
        b.fills[selected].Draw(draw,
                               relX,relY,relWidth,relHeight,
                               x,y,w,h);
      ELSE
        draw.PushForeground(D.fillColor);
        draw.FillRectangle(x,y,w,h);
        draw.PopForeground;
      END;
    ELSE
      IF b.fills[normal]#NIL THEN
        b.fills[normal].Draw(draw,
                             relX,relY,relWidth,relHeight,
                             x,y,w,h);
      ELSE
        draw.PushForeground(D.backgroundColor);
        draw.FillRectangle(x,y,w,h);
        draw.PopForeground;
      END;
    END;
  END Draw;

  PROCEDURE (b: Background) Free*;

  VAR
    x : LONGINT;

  BEGIN
    FOR x:=0 TO size-1 DO
      b.fills[x].Free;
      b.fills[x]:=NIL;
    END;
  END Free;

  PROCEDURE CreateBackground*():G.Background;

  VAR
    background : Background;

  BEGIN
    NEW(background);
    background.Init;

    RETURN background;
  END CreateBackground;

  PROCEDURE (b : Background) SetFill*(mode : LONGINT; fill : Fill);

  BEGIN
    IF b.fills[mode]#NIL THEN
      b.fills[mode].Free;
    END;
    b.fills[mode]:=fill;
  END SetFill;

  PROCEDURE CreateBackgroundByFill*(fill : Fill):G.Background;

  VAR
    background : Background;

  BEGIN
    NEW(background);
    background.Init;
    background.fills[normal]:=fill;

    RETURN background;
  END CreateBackgroundByFill;

  (* --------- *)

  PROCEDURE (p : PlainFill) Init*;

  BEGIN
    p.index:=D.backgroundColorIndex;
    p.inited:=FALSE;
  END Init;

  PROCEDURE (p : PlainFill) SetColorIndex*(index : LONGINT);

  BEGIN
    p.index:=index;
  END SetColorIndex;

  PROCEDURE (p : PlainFill) SetColorName*(colorName : ARRAY OF CHAR);

  BEGIN
    p.index:=D.GetColorIndexByName(colorName);
  END SetColorName;

  PROCEDURE (p : PlainFill) Draw*(draw : D.DrawInfo;
                                  xOff,yOff,width,height,
                                  x,y,w,h : LONGINT);

  BEGIN
    IF ~p.inited THEN
      IF p.index>=0 THEN
        p.color:=D.GetColorByIndex(p.index);
      END;

      p.inited:=TRUE;
    END;

    draw.PushForeground(p.color);
    draw.FillRectangle(x,y,w,h);
    draw.PopForeground;
  END Draw;

  PROCEDURE (p : PlainFill) Copy*():Fill;

  VAR
    copy : PlainFill;

  BEGIN
    NEW(copy);
    copy^:=p^;

    RETURN copy;
  END Copy;

  PROCEDURE (f : PlainFill) Free*;

  BEGIN
  END Free;

  PROCEDURE CreatePlainFillByColorName*(color : ARRAY OF CHAR):PlainFill;

  VAR
    p : PlainFill;

  BEGIN
    NEW(p);
    p.Init;
    p.SetColorName(color);
    RETURN p;
  END CreatePlainFillByColorName;

  PROCEDURE CreatePlainFillByColorIndex*(color : LONGINT):PlainFill;

  VAR
    p : PlainFill;

  BEGIN
    NEW(p);
    p.Init;
    p.SetColorIndex(color);
    RETURN p;
  END CreatePlainFillByColorIndex;

  (* --------- *)

  PROCEDURE (i : ImageFill) Init*;

  BEGIN
    i.image:=I.factory.CreateImage();
    i.mode:=relativeMode;
    i.x:=-1;
    i.y:=-1;
    i.w:=-1;
    i.h:=-1;
  END Init;

  PROCEDURE (i : ImageFill) SetFilename*(filename : ARRAY OF CHAR);

  VAR
    tmp : I.Image;

  BEGIN
    i.filename:=U.StringToText(filename);
    IF ~Loader.manager.LoadThemed(filename,i.image) THEN
      Err.String("Error loading "); Err.String(filename); Err.Ln;
    ELSIF (i.x>=0) & (i.y>=0) & (i.w>0) & (i.h>0) THEN
      tmp:=i.image.CloneRegion(i.x,i.y,i.w,i.h);
      i.image.Free;
      i.image:=tmp;
    END;
  END SetFilename;

  PROCEDURE (i : ImageFill) GetBitmap(width,height : LONGINT);

  BEGIN
    IF (i.bitmap=NIL) OR (i.bitmap.width#width) OR (i.bitmap.height#height) THEN
      IF i.bitmap#NIL THEN
        D.display.FreeBitmap(i.bitmap);
      END;

      i.bitmap:=D.display.CreateBitmap(width,height);
    END;
  END GetBitmap;

  PROCEDURE (i : ImageFill) Draw*(draw : D.DrawInfo;
                                  xOff,yOff,width,height,
                                  x,y,w,h : LONGINT);

  BEGIN
    IF i.mode=relativeMode THEN
(*      IF i.image.alpha THEN
        object.DrawParentBackgroundWithDrawInfo(draw,x,y,w,h);
      END;*)
      i.image.Resize(width,height);
      i.image.DrawSubCliped(draw,x-xOff,y-yOff,w,h,x,y);
    ELSE
      i.image.Resize(w,h);
      i.image.DrawSubCliped(draw,0,0,w,h,x,y);
    END;
  END Draw;

  PROCEDURE (b : ImageFill) Copy*():Fill;

  VAR
    copy : ImageFill;

  BEGIN
    NEW(copy);
    copy^:=b^;
    copy.bitmap:=NIL; (* There can only be one owner ;-) *)

    RETURN copy;
  END Copy;

  PROCEDURE (i : ImageFill) Free*;

  BEGIN
    IF i.image#NIL THEN
      i.image.Free;
      i.image:=NIL;
    END;

    IF i.bitmap#NIL THEN
      D.display.FreeBitmap(i.bitmap);
      i.bitmap:=NIL;
    END;
  END Free;

  PROCEDURE CreateImageFillByFile*(file : ARRAY OF CHAR; x,y,w,h : LONGINT):Fill;

  VAR
    i : ImageFill;

  BEGIN
    NEW(i);
    i.Init;
    i.x:=x;
    i.y:=y;
    i.w:=w;
    i.h:=h;
    i.SetFilename(file);
    RETURN i;
  END CreateImageFillByFile;

  (* --------- *)

  PROCEDURE (t : TileFill) Init*;

  BEGIN
    t.image:=I.factory.CreateImage();
    t.x:=-1;
    t.y:=-1;
    t.w:=-1;
    t.h:=-1;
  END Init;

  PROCEDURE (t : TileFill) SetFilename*(filename : ARRAY OF CHAR);

  VAR
    tmp : I.Image;

  BEGIN
    t.filename:=U.StringToText(filename);
    IF ~Loader.manager.LoadThemed(filename,t.image) THEN
      Err.String("Error loading "); Err.String(filename); Err.Ln;
    ELSIF (t.x>=0) & (t.y>=0) & (t.w>0) & (t.h>0) THEN
      tmp:=t.image.CloneRegion(t.x,t.y,t.w,t.h);
      t.image.Free;
      t.image:=tmp;
    END;
  END SetFilename;

  PROCEDURE (t : TileFill) Draw*(draw : D.DrawInfo;
                                 xOff,yOff,width,height,
                                 x,y,w,h : LONGINT);

  BEGIN
    t.image.DrawTiled(draw,x,y,w,h,0,0);
  END Draw;

  PROCEDURE (t : TileFill) Copy*():Fill;

  VAR
    copy : TileFill;

  BEGIN
    NEW(copy);
    copy^:=t^;

    RETURN copy;
  END Copy;

  PROCEDURE (t : TileFill) Free*;

  BEGIN
    IF t.image#NIL THEN
      t.image.Free;
      t.image:=NIL;
    END;
  END Free;

  PROCEDURE CreateTileFillByFile*(file : ARRAY OF CHAR; x,y,w,h : LONGINT):TileFill;

  VAR
    t : TileFill;

  BEGIN
    NEW(t);
    t.Init;
    t.x:=x;
    t.y:=y;
    t.w:=w;
    t.h:=h;
    t.SetFilename(file);
    RETURN t;
  END CreateTileFillByFile;

  (* --------- *)

  PROCEDURE (p : PatternFill) Init*;

  BEGIN
    p.bitmap:=D.smallChess;
    p.fgIndex:=D.backgroundColorIndex;
    p.bgIndex:=D.backgroundColorIndex;
    p.inited:=FALSE;
  END Init;

  PROCEDURE (p : PatternFill) SetPatternByName*(pattern,fg,bg : ARRAY OF CHAR);

  BEGIN
    IF pattern="smallChess" THEN
      p.bitmap:=D.smallChess;
    ELSE
      p.bitmap:=D.bigChess;
    END;

    p.fgIndex:=D.GetColorIndexByName(fg);
    p.bgIndex:=D.GetColorIndexByName(bg);
  END SetPatternByName;

  PROCEDURE (p : PatternFill) SetPatternByIndex*(bitmap : D.Bitmap; fg,bg : LONGINT);

  BEGIN
    p.bitmap:=bitmap;
    p.fgIndex:=fg;
    p.bgIndex:=bg;
  END SetPatternByIndex;

  PROCEDURE (p : PatternFill)Draw*(draw : D.DrawInfo;
                                   xOff,yOff,width,height,
                                   x,y,w,h : LONGINT);

  BEGIN
    IF ~p.inited THEN
      IF p.fgIndex>=0 THEN
        p.fg:=D.GetColorByIndex(p.fgIndex);
      END;

      IF p.bgIndex>=0 THEN
        p.bg:=D.GetColorByIndex(p.bgIndex);
      END;

      p.inited:=TRUE;
    END;

    draw.PushForeground(p.fg);
    draw.PushBackground(p.bg);
    draw.PushBitmap(p.bitmap,D.fbPattern);
    draw.FillRectangle(x,y,w,h);
    draw.PopBitmap;
    draw.PopForeground;
    draw.PopBackground;
  END Draw;

  PROCEDURE (p : PatternFill) Copy*():Fill;

  VAR
    copy : PatternFill;

  BEGIN
    NEW(copy);
    copy^:=p^;

    RETURN copy;
  END Copy;

  PROCEDURE (f : PatternFill) Free*;

  BEGIN
  END Free;

  PROCEDURE CreatePatternFillByName*(pattern,fg,bg : ARRAY OF CHAR):PatternFill;

  VAR
    p : PatternFill;

  BEGIN
    NEW(p);
    p.Init;
    p.SetPatternByName(pattern,fg,bg);
    RETURN p;
  END CreatePatternFillByName;

  PROCEDURE CreatePatternFillByIndex*(pattern : D.Bitmap; fg,bg : LONGINT):PatternFill;

  VAR
    p : PatternFill;

  BEGIN
    NEW(p);
    p.Init;
    p.SetPatternByIndex(pattern,fg,bg);
    RETURN p;
  END CreatePatternFillByIndex;

  (* --------- *)

  PROCEDURE LoadBackground*(top : PP.Item; name : ARRAY OF CHAR;
                            VAR background : G.Background);

  VAR
    x    : LONGINT;
    sub,
    item : PP.Item;
    fill : Fill;
    type,
    data,
    data2,
    data3 : ARRAY 256 OF CHAR;
    d1,d2,
    d3,d4 : LONGINT;

  BEGIN
    sub:=top.GetSubEntry("Background","name",name);
    IF sub=NIL THEN
      RETURN;
    END;

    background:=CreateBackground();

    FOR x:=0 TO size-1 DO
      item:=sub.GetSubEntry("Fill","name",names[x]);
      fill:=NIL;

      IF item#NIL THEN
        IF item.GetStringEntry("type",type) THEN
          IF type="image" THEN
            IF item.GetStringEntry("normal",data) THEN
              d1:=item.GetIntEntry("x",-1);
              d2:=item.GetIntEntry("y",-1);
              d3:=item.GetIntEntry("w",-1);
              d4:=item.GetIntEntry("h",-1);

              fill:=CreateImageFillByFile(data,d1,d2,d3,d4);
              IF item.GetStringEntry("mode",data) THEN
                IF data="absolute" THEN
                  fill(ImageFill).mode:=absoluteMode;
                END;
              END;
            END;
          ELSIF type="inherit" THEN
            fill:=NIL;
          ELSIF type="imageTile" THEN
            IF item.GetStringEntry("normal",data) THEN
              d1:=item.GetIntEntry("x",-1);
              d2:=item.GetIntEntry("y",-1);
              d3:=item.GetIntEntry("w",-1);
              d4:=item.GetIntEntry("h",-1);
              fill:=CreateTileFillByFile(data,d1,d2,d3,d4);
            END;
          ELSIF type="plain" THEN
            IF item.GetStringEntry("color",data) THEN
              fill:=CreatePlainFillByColorName(data);
            END;
          ELSIF type="pattern" THEN
            IF item.GetStringEntry("pattern",data)
              & item.GetStringEntry("fg",data2)
              & item.GetStringEntry("bg",data3) THEN
              fill:=CreatePatternFillByName(data,data2,data3);
            END;
          END;
        END;
      END;
      background(Background).fills[x]:=fill;
    END;
  END LoadBackground;

  PROCEDURE SaveBackground*(top : PP.BlockItem; name : ARRAY OF CHAR;
                            background : G.Background);

  VAR
    block,
    sub   : PP.BlockItem;
    fill  : Fill;
    x     : LONGINT;

  BEGIN
    block:=PP.CreateBlockItem("Background");
    top.AddItem(block);
    block.AddItemValue("name",name);

    IF background#NIL THEN
      FOR x:=0 TO size-1 DO
        sub:=PP.CreateBlockItem("Fill");
        block.AddItem(sub);

        WITH
          background : Background DO

          sub.AddItemValue("name",names[x]);

          fill:=background.fills[x];

          IF fill#NIL THEN
            WITH
              fill : PlainFill DO
              sub.AddItemValue("type","plain");
              sub.AddItemValue("color",D.colorNames[fill.index]);
            | fill : ImageFill DO
              sub.AddItemValue("type","image");
              sub.AddItemValue("normal",fill.filename^);
              IF fill.mode=absoluteMode THEN
                sub.AddItemValue("mode","absolute");
              END;
              IF (fill.x>=0) & (fill.y>=0) & (fill.w>0) & (fill.h>0) THEN
                sub.AddItemInt("x",fill.x);
                sub.AddItemInt("y",fill.y);
                sub.AddItemInt("w",fill.w);
                sub.AddItemInt("h",fill.h);
              END;
            | fill : TileFill DO
              sub.AddItemValue("type","imageTile");
              sub.AddItemValue("normal",fill.filename^);
              IF (fill.x>=0) & (fill.y>=0) & (fill.w>0) & (fill.h>0) THEN
                sub.AddItemInt("x",fill.x);
                sub.AddItemInt("y",fill.y);
                sub.AddItemInt("w",fill.w);
                sub.AddItemInt("h",fill.h);
              END;
            | fill : PatternFill DO
              sub.AddItemValue("type","pattern");
              IF fill.bitmap=D.bigChess THEN
                sub.AddItemValue("pattern","bigChess");
              ELSE
                sub.AddItemValue("pattern","smallChess");
              END;

              sub.AddItemValue("fg",D.colorNames[fill.fgIndex]);
              sub.AddItemValue("bg",D.colorNames[fill.bgIndex]);
            END;
          ELSE
            sub.AddItemValue("type","inherit");
          END;
        END;
      END;
    END;
  END SaveBackground;

BEGIN
  names[normal]:="normal";
  names[selected]:="selected";
END VO:Base:Background.