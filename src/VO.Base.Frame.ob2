MODULE VO:Base:Frame;

  (**
   Implements @otype{Frame}.
  *)

(*
    Frames.
    Copyright (C) 1997  Tim Teulings (rael@edge.ping.de)

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
       IB := VO:Base:Image,
       U  := VO:Base:Util,

       I  := VO:Image:Image,
             VO:Image:Loader,

       PP := VO:Prefs:Parser,Err;

CONST

  (* Internal Frames *)

  none              * =  0;
  noneSingle        * =  1;
  noneDouble        * =  2;
  single3DIn        * =  3;
  single3DOut       * =  4;
  single            * =  5;
  double            * =  6;
  double3DIn        * =  7;
  double3DOut       * =  8;
  double3DTool      * =  9;
  group3D           * = 10;
  ridge             * = 11;
  doubleFocus       * = 12; (* A thicker frame for motif-like focus  *)
  dottedFocus       * = 13; (* A dotted-line focus frame             *)
  w95BO             * = 14; (* Win95 button, released                *)
  w95BI             * = 15; (* Win95 button, pressed                 *)
  w95IO             * = 16; (* Win95 image button, released          *)
  w95II             * = 17; (* Win95 image button, pressed           *)
  w95CI             * = 18; (* Container in w95 look                 *)
  w95CO             * = 19; (* Container in w95 look                 *)
  BBBI              * = 20; (* BeBox Button in                       *)
  BBBO              * = 21; (* BeBox Button out                      *)
  tabRider          * = 22; (* "normal" tab rider                    *)
  tab               * = 23; (* "Normal" frame for complete tab       *)
  textButton        * = 24; (* Textual frame for buttons and similar *)

  internalFrameCount* = 25;

  left        = 0;
  leftTop     = 1;
  top         = 2;
  rightTop    = 3;
  right       = 4;
  rightBottom = 5;
  bottom      = 6;
  leftBottom  = 7;

  maxPos      = 7;


TYPE
  FrameName           = ARRAY 30 OF CHAR;

  Frame*              = POINTER TO FrameDesc;
  FrameDesc*          = RECORD [ABSTRACT]
                          topBorder-,
                          bottomBorder-,
                          leftBorder-,
                          rightBorder-,
                          gx-,gy-,gw-,gh-,
                          minWidth-,
                          minHeight-     : LONGINT;
                          alpha-         : BOOLEAN;
                          type-          : LONGINT;
                        END;


  InternalFrame *     = POINTER TO InternalFrameDesc;
  InternalFrameDesc * = RECORD (FrameDesc)
                          (**
                            A class that implements a number of frames. Use the frames
                            implemented here everywhere where possible. Do @emph{not} implement
                            your own frames, add them here. Add your frames also here, when you
                            want to implement another look.
                          *)
                        END;

  FrameImageDesc      = RECORD
                          normal,
                          selected : U.Text;
                          image    : IB.Image;
                        END;

  FrameImageSetDesc   = ARRAY 8 OF FrameImageDesc;

  ImageFrame*         = POINTER TO ImageFrameDesc;
  ImageFrameDesc*     = RECORD (FrameDesc)
                          (**
                            This class implements frame drawing based
                            on external images.
                          *)
                          images    : FrameImageSetDesc;
                          x,y,w,h   : LONGINT;
                          normal,
                          selected  : U.Text;
                          iNormal,
                          iSelected : I.Image;
                        END;

VAR
  internalFrames- : ARRAY internalFrameCount OF FrameName;

  PROCEDURE (f : Frame) Init*;

  BEGIN
    f.gx:=0;
    f.gy:=0;
    f.gw:=0;
    f.gh:=0;
    f.type:=none;
  END Init;

  PROCEDURE (f : Frame) SetGap*(width,height : LONGINT);

  BEGIN
    f.gw:=width;
    f.gh:=height;
  END SetGap;

  PROCEDURE (f : Frame) HasGap*():BOOLEAN;

  BEGIN
    RETURN (f.gw>0) & (f.gh>0);
  END HasGap;

  PROCEDURE (f : Frame) [ABSTRACT] Draw*(draw : D.DrawInfo; x,y,w,h : LONGINT);
  END Draw;

  PROCEDURE (f : Frame) Free*;

  BEGIN
  END Free;

  PROCEDURE (f : InternalFrame) SetFrame(type : LONGINT);

    (**
      Set the frame to be used.

      NOTE
      The frame can be changed at runtime.
    *)

  BEGIN
    f.type:=type;
    f.alpha:=FALSE;

    CASE f.type OF
      none:
      f.topBorder:=0;
      f.bottomBorder:=0;
      f.leftBorder:=0;
      f.rightBorder:=0;
    | single3DIn,
      single3DOut,
      noneSingle,
      single:
      f.topBorder:=1;
      f.bottomBorder:=1;
      f.leftBorder:=1;
      f.rightBorder:=1;
    | noneDouble,
      double,
      double3DIn,
      double3DOut,
      double3DTool,
      ridge:
      f.topBorder:=2;
      f.bottomBorder:=2;
      f.leftBorder:=2;
      f.rightBorder:=2;
    | group3D:
      IF f.HasGap() THEN
        f.topBorder:=f.gh;
        f.gx:=2*D.display.spaceWidth;
        f.gy:=0;
      ELSE
        f.topBorder:=2;
      END;
      f.bottomBorder:=2;
      f.leftBorder:=2;
      f.rightBorder:=2;
    | doubleFocus:
      f.topBorder:=2;
      f.bottomBorder:=2;
      f.leftBorder:=2;
      f.rightBorder:=2;
    | dottedFocus:
      f.topBorder:=1;
      f.bottomBorder:=1;
      f.leftBorder:=1;
      f.rightBorder:=1;
    | w95BO,
      w95BI:
      f.topBorder:=2;
      f.bottomBorder:=2;
      f.leftBorder:=2;
      f.rightBorder:=2;
    | w95CI,
      w95CO:
      f.topBorder:=2;
      f.bottomBorder:=2;
      f.leftBorder:=2;
      f.rightBorder:=2;
    | w95II,
      w95IO:
      f.topBorder:=2;
      f.bottomBorder:=2;
      f.leftBorder:=2;
      f.rightBorder:=2;
    | BBBI,
      BBBO:
      f.topBorder:=4;
      f.bottomBorder:=4;
      f.leftBorder:=4;
      f.rightBorder:=4;
    | tabRider:
      f.topBorder:=2;
      f.bottomBorder:=0;
      f.leftBorder:=2;
      f.rightBorder:=2;
    | tab:
      f.topBorder:=0;
      f.bottomBorder:=2;
      f.leftBorder:=2;
      f.rightBorder:=2;
    | textButton:
      (* This is a hack and does only work in text modus! *)
      f.topBorder:=0;
      f.bottomBorder:=0;
      f.leftBorder:=1;
      f.rightBorder:=1;
    ELSE
      f.topBorder:=0;
      f.bottomBorder:=0;
      f.leftBorder:=0;
      f.rightBorder:=0;
    END;

    f.minWidth:=f.leftBorder+f.rightBorder;
    f.minHeight:=f.topBorder+f.bottomBorder;

    IF f.HasGap() THEN
      INC(f.minWidth,f.gw+4*8);
    END;
  END SetFrame;

  PROCEDURE (f : InternalFrame) SetGap*(width,height : LONGINT);

  BEGIN
    f.SetGap^(width,height);
    (* recalculate sizes *)
    f.SetFrame(f.type);
  END SetGap;

  PROCEDURE (f : InternalFrame) Draw*(draw : D.DrawInfo; x,y,w,h : LONGINT);

  VAR
    shine,
    shadow,
    halfShadow,
    halfShine,
    top,type    : LONGINT;
    set         : BOOLEAN;

  BEGIN
    shine:=D.shineColor;
    shadow:=D.shadowColor;
    halfShadow:=D.halfShadowColor;
    halfShine:=D.halfShineColor;

    set:=FALSE;

    type:=f.type;

    IF D.selected IN draw.mode THEN
      IF type=double3DOut THEN
        type:=double3DIn;
      ELSIF type=single3DOut THEN
        type:=single3DIn;
      ELSIF type=w95BO THEN
        type:=w95BI;
      ELSIF type=BBBO THEN
        type:=BBBI;
      ELSIF type=w95IO THEN
        type:=w95II;
      END;
    END;

    CASE type OF
      none,
      noneSingle,
      noneDouble:

    | double:
        draw.PushForeground(shadow);
        draw.DrawLine(x,y+h-1,x,y+1);
        draw.DrawLine(x,y,x+w-1,y);
        draw.DrawLine(x+1,y+h-2,x+1,y+2);
        draw.DrawLine(x+1,y+1,x+w-2,y+1);

        draw.DrawLine(x+w-1,y+1,x+w-1,y+h-1);
        draw.DrawLine(x+w-1,y+h-1,x,y+h-1);
        draw.DrawLine(x+w-2,y+2,x+w-2,y+h-2);
        draw.DrawLine(x+w-2,y+h-2,x+1,y+h-2);
        draw.PopForeground;

    | double3DIn,
      double3DOut:
        IF type=double3DIn THEN
          draw.PushForeground(shadow);
        ELSE
          draw.PushForeground(shine);
        END;
        draw.DrawLine(x,y+h-1,x,y+1);
        draw.DrawLine(x,y,x+w-1,y);
        draw.DrawLine(x+1,y+h-2,x+1,y+2);
        draw.DrawLine(x+1,y+1,x+w-2,y+1);
        draw.PopForeground;

        IF type=double3DIn THEN
          draw.PushForeground(shine);
        ELSE
          draw.PushForeground(shadow);
        END;
        draw.DrawLine(x+w-1,y+1,x+w-1,y+h-1);
        draw.DrawLine(x+w-1,y+h-1,x,y+h-1);
        draw.DrawLine(x+w-2,y+2,x+w-2,y+h-2);
        draw.DrawLine(x+w-2,y+h-2,x+1,y+h-2);
        draw.PopForeground;

    | double3DTool:
        IF draw.mode={} THEN
          draw.PushForeground(D.backgroundColor);
        ELSIF draw.mode={D.selected} THEN
          draw.PushForeground(shadow);
        ELSE
          draw.PushForeground(shine);
        END;

        draw.DrawLine(x,y+h-1,x,y+1);
        draw.DrawLine(x,y,x+w-1,y);
        draw.DrawLine(x+1,y+h-2,x+1,y+2);
        draw.DrawLine(x+1,y+1,x+w-2,y+1);
        draw.PopForeground;


        IF draw.mode={} THEN
          draw.PushForeground(D.backgroundColor);
        ELSIF draw.mode={D.selected} THEN
          draw.PushForeground(shine);
        ELSE
          draw.PushForeground(shadow);
        END;
        draw.DrawLine(x+w-1,y+1,x+w-1,y+h-1);
        draw.DrawLine(x+w-1,y+h-1,x,y+h-1);
        draw.DrawLine(x+w-2,y+2,x+w-2,y+h-2);
        draw.DrawLine(x+w-2,y+h-2,x+1,y+h-2);
        draw.PopForeground;

    | single3DIn,
      single3DOut :
        IF type=single3DIn THEN
          draw.PushForeground(shadow);
        ELSE
          draw.PushForeground(shine);
        END;
        draw.DrawLine(x,y+h-1,x,y+1);
        draw.DrawLine(x,y,x+w-1,y);
        draw.PopForeground;

        IF type=single3DIn THEN
          draw.PushForeground(shine);
        ELSE
          draw.PushForeground(shadow);
        END;
        draw.DrawLine(x+w-1,y+1,x+w-1,y+h-1);
        draw.DrawLine(x+w-1,y+h-1,x,y+h-1);
        draw.PopForeground;

    | single:
      draw.PushForeground(shadow);
      draw.PushBackground(D.backgroundColor);
      draw.DrawRectangle(x,y,w,h);
      draw.PopBackground;
      draw.PopForeground;

    | group3D:
        IF f.HasGap() THEN
          top:=y+f.gh DIV 2;
        ELSE
          top:=y;
        END;
        draw.PushForeground(shadow);
        draw.DrawLine(x,y+h-1,x,top);
        draw.DrawLine(x+w-2,top+1,x+w-2,y+h-2);
        draw.DrawLine(x+1,y+h-2,x+w-2,y+h-2);
        IF f.HasGap() THEN
          draw.DrawLine(x,top,x+D.display.spaceWidth-1,top);
          draw.DrawLine(x+3*D.display.spaceWidth+f.gw+1,top,x+w-1,top);
          draw.DrawLine(x+3*D.display.spaceWidth+f.gw,top,
                        x+3*D.display.spaceWidth+f.gw,top+1);
        ELSE
          draw.DrawLine(x,top,x+w-1,top);
        END;
        draw.PopForeground;

        draw.PushForeground(shine);
        draw.DrawLine(x+1,y+h-2,x+1,top+1);
        draw.DrawLine(x+w-1,top+1,x+w-1,y+h-1);
        draw.DrawLine(x+1,y+h-1,x+w-2,y+h-1);
        IF f.HasGap() THEN
          draw.DrawLine(x+2,top+1,x+D.display.spaceWidth-1,top+1);
          draw.DrawLine(x+3*D.display.spaceWidth+f.gw+1,top+1,x+w-2,top+1);
          draw.DrawLine(x+D.display.spaceWidth,top,x+D.display.spaceWidth,top+1);
        ELSE
          draw.DrawLine(x+2,top+1,x+w-2,top+1);
        END;
        draw.PopForeground;

    | ridge:
        draw.PushForeground(shine);
        draw.DrawLine(x,y,x+w-2,y);
        draw.DrawLine(x+2,y+h-2,x+w-2,y+h-2);
        draw.DrawLine(x,y+h-1,x,y);
        draw.DrawLine(x+w-2,y+2,x+w-2,y+h-2);
        draw.PopForeground;

        draw.PushForeground(shadow);
        draw.DrawLine(x+w-1,y,x+w-1,y+h-1);
        draw.DrawLine(x+1,y+h-2,x+1,y+1);
        draw.DrawLine(x+1,y+h-1,x+w-1,y+h-1);
        draw.DrawLine(x+1,y+1,x+w-2,y+1);
        draw.PopForeground;

    | doubleFocus:
        draw.PushForeground(D.focusColor);

        draw.DrawLine(x,y+h-1,x,y+1);
        draw.DrawLine(x,y,x+w-1,y);
        draw.DrawLine(x+1,y+h-2,x+1,y+2);
        draw.DrawLine(x+1,y+1,x+w-2,y+1);
        draw.DrawLine(x+w-1,y+1,x+w-1,y+h-1);
        draw.DrawLine(x+w-1,y+h-1,x,y+h-1);
        draw.DrawLine(x+w-2,y+2,x+w-2,y+h-2);
        draw.DrawLine(x+w-2,y+h-2,x+1,y+h-2);
        draw.PopForeground;
    | dottedFocus:
        draw.PushForeground(D.textColor);

        draw.PushDash(D.sPointLine,D.fMode);
        draw.DrawLine(x          ,y,      x+w-1,y);
        draw.DrawLine(x+w-1,y,            x+w-1,y+h-1);
        draw.DrawLine(x+w-1,y+h-1,x,            y+h-1);
        draw.DrawLine(x          ,y+h-1,x,      y);
        draw.PopDash;
        draw.PopForeground;
    | w95BO,
      w95BI:
        IF type=w95BI THEN
          draw.PushForeground(shadow);
        ELSE
          draw.PushForeground(shine);
        END;
        draw.DrawLine(x,y+h-1,x,y+1);
        draw.DrawLine(x,y,x+w-2,y);
        draw.PopForeground;

        IF type=w95BI THEN
          draw.PushForeground(halfShadow);
        ELSE
          draw.PushForeground(D.backgroundColor);
        END;
        draw.DrawLine(x+1,y+h-2,x+1,y+2);
        draw.DrawLine(x+1,y+1,x+w-3,y+1);
        draw.PopForeground;

        IF type=w95BI THEN
          draw.PushForeground(shadow);
        ELSE
          draw.PushForeground(shadow);
        END;
        draw.DrawLine(x+w-1,y,x+w-1,y+h-1);
        draw.DrawLine(x+w-1,y+h-1,x,y+h-1);
        draw.PopForeground;

        IF type=w95BI THEN
          draw.PushForeground(halfShadow);
        ELSE
          draw.PushForeground(halfShadow);
        END;
        draw.DrawLine(x+w-2,y+1,x+w-2,y+h-2);
        draw.DrawLine(x+w-2,y+h-2,x+1,y+h-2);
        draw.PopForeground;
    | w95CI,
      w95CO:
        IF type=w95CI THEN
          draw.PushForeground(halfShadow);
        ELSE
          draw.PushForeground(halfShine);
        END;
        draw.DrawLine(x,y+h-1,x,y+1);
        draw.DrawLine(x,y,x+w-2,y);
        draw.PopForeground;

        IF type=w95CI THEN
          draw.PushForeground(shadow);
        ELSE
          draw.PushForeground(shine);
        END;
        draw.DrawLine(x+1,y+h-2,x+1,y+2);
        draw.DrawLine(x+1,y+1,x+w-3,y+1);
        draw.PopForeground;

        IF type=w95CI THEN
          draw.PushForeground(shine);
        ELSE
          draw.PushForeground(shadow);
        END;
        draw.DrawLine(x+w-1,y,x+w-1,y+h-1);
        draw.DrawLine(x+w-1,y+h-1,x,y+h-1);
        draw.PopForeground;

        IF type=w95CI THEN
          draw.PushForeground(D.backgroundColor);
        ELSE
          draw.PushForeground(halfShadow);
        END;
        draw.DrawLine(x+w-2,y+1,x+w-2,y+h-2);
        draw.DrawLine(x+w-2,y+h-2,x+1,y+h-2);
        draw.PopForeground;
    | w95II,
      w95IO:
        IF type=w95II THEN
          draw.PushForeground(halfShadow);
        ELSE
          draw.PushForeground(D.backgroundColor);
        END;
        draw.DrawLine(x,y+h-1,x,y+1);
        draw.DrawLine(x,y,x+w-2,y);
        draw.PopForeground;

        IF type=w95II THEN
          draw.PushForeground(shadow);
        ELSE
          draw.PushForeground(shine);
        END;
        draw.DrawLine(x+1,y+h-2,x+1,y+2);
        draw.DrawLine(x+1,y+1,x+w-3,y+1);
        draw.PopForeground;

        IF type=w95II THEN
          draw.PushForeground(shine);
        ELSE
          draw.PushForeground(shadow);
        END;
        draw.DrawLine(x+w-1,y,x+w-1,y+h-1);
        draw.DrawLine(x+w-1,y+h-1,x,y+h-1);
        draw.PopForeground;

        IF type=w95II THEN
          draw.PushForeground(D.backgroundColor);
        ELSE
          draw.PushForeground(halfShadow);
        END;
        draw.DrawLine(x+w-2,y+1,x+w-2,y+h-2);
        draw.DrawLine(x+w-2,y+h-2,x+1,y+h-2);
        draw.PopForeground;
    | BBBI,
      BBBO:
        (* outest frame *)
        draw.PushForeground(D.blackColor);

        draw.DrawLine(x+1,y,x+w-2,y);
        draw.DrawLine(x+1,y+h-1,x+w-2,y+h-1);
        draw.DrawLine(x,y+1,x,y+h-2);
        draw.DrawLine(x+w-1,y+1,x+w-1,y+h-2);
        draw.PopForeground;

        (* 2nd frame *)

        draw.PushForeground(D.backgroundColor);
        draw.DrawLine(x+1,y+1,x+w-2,y+1);
        draw.DrawLine(x+1,y+2,x+1,y+h-2);
        draw.PopForeground;

        IF type=BBBI THEN
          draw.PushForeground(shine);
        ELSE
          draw.PushForeground(shadow);
        END;
        draw.DrawLine(x+w-2,y+2,x+w-2,y+h-2);
        draw.DrawLine(x+2,y+h-2,x+w-2,y+h-2);
        draw.PopForeground;

        (* 3rd frame *)

        IF type=BBBI THEN
          draw.PushForeground(halfShadow);
        ELSE
          draw.PushForeground(halfShine);
        END;
        draw.DrawLine(x+2,y+2,x+w-3,y+2);
        draw.DrawLine(x+2,y+3,x+2,y+h-3);
        draw.PopForeground;

        IF type=BBBI THEN
          draw.PushForeground(halfShine);
        ELSE
          draw.PushForeground(halfShadow);
        END;
        draw.DrawLine(x+w-3,y+3,x+w-3,y+h-3);
        draw.DrawLine(x+4,y+h-3,x+w-4,y+h-3);
        draw.PopForeground;

        (* 4th frame *)

        IF type=BBBI THEN
          draw.PushForeground(shadow);
        ELSE
          draw.PushForeground(shine);
        END;
        draw.DrawLine(x+3,y+3,x+w-4,y+3);
        draw.DrawLine(x+3,y+4,x+3,y+h-4);
        draw.PopForeground;
    | tabRider:
      IF D.selected IN draw.mode THEN
        draw.PushForeground(D.shadowColor);
      ELSE
        draw.PushForeground(D.shineColor);
      END;
      draw.DrawLine(x+3,y  ,x+w-4,y);
      draw.DrawLine(x+1,y+1,x+w-3,y+1);
      draw.DrawLine(x  ,y+3,x    ,y+h-1);
      draw.DrawLine(x+1,y+1,x+1  ,y+h-1);
      draw.PopForeground;

      IF D.selected IN draw.mode THEN
        draw.PushForeground(D.shineColor);
      ELSE
        draw.PushForeground(D.shadowColor);
      END;
      draw.DrawLine(x+w-1,y+3,x+w-1,y+h-1);
      draw.DrawLine(x+w-2,y+1,x+w-2,y+h-1);
      draw.PopForeground;
    | tab:
      draw.PushForeground(D.shadowColor);

      (* right line *)
      draw.DrawLine(x+w-2,y,x+w-2,y+h-1-2);
      draw.DrawLine(x+w-1,y,x+w-1,y+h-1-2);

      (* bottom line *)
      draw.DrawLine(x+1,y+h-2,x+w-1,y+h-2);
      draw.DrawLine(x,  y+h-1,x+w-1,y+h-1);
      draw.PopForeground;

      draw.PushForeground(D.shineColor);

      (* left line *)
      draw.DrawLine(x  ,y,x  ,y+h-1);
      draw.DrawLine(x+1,y,x+1,y+h-1-1);
      draw.PopForeground;
    | textButton:
      draw.PushForeground(D.shineColor);
      draw.PushBackground(D.backgroundColor);
      draw.DrawFillString(x,y,"[",1);
      draw.DrawFillString(x+w-1,y+h-1,"]",1);
      draw.PopBackground;
      draw.PopForeground;
    END;
  END Draw;

  PROCEDURE CreateFrame*(type : LONGINT):Frame;

  VAR
    frame : InternalFrame;

  BEGIN
    NEW(frame);
    frame.Init;
    frame.SetFrame(type);

    RETURN frame;
  END CreateFrame;

  PROCEDURE (f : ImageFrame) Init*;

  VAR
    x : LONGINT;

  BEGIN
    f.Init^;

    f.normal:=NIL;
    f.selected:=NIL;
    f.iNormal:=NIL;
    f.iSelected:=NIL;

    f.x:=-1;
    f.y:=-1;
    f.w:=-1;
    f.h:=-1;

    f.alpha:=FALSE;

    FOR x:=0 TO LEN(f.images)-1 DO
      f.images[x].image:=NIL;
      f.images[x].normal:=NIL;
      f.images[x].selected:=NIL;
    END;
  END Init;

  PROCEDURE (f : ImageFrame) CalcSize;

  VAR
    normal,
    selected : I.Image;
    x        : LONGINT;

  BEGIN
    IF f.normal#NIL THEN
      f.iNormal:=I.factory.CreateImage();
      IF ~Loader.manager.LoadThemed(f.normal^,f.iNormal) THEN
        Err.String("Error loading "); Err.String(f.normal^); Err.Ln;
      ELSE
        IF (f.selected#NIL) THEN
          f.iSelected:=I.factory.CreateImage();
          IF ~Loader.manager.LoadThemed(f.selected^,f.iSelected) THEN
            Err.String("Error loading "); Err.String(f.selected^); Err.Ln;
          END;
        END;

        (* top *)
        IF (f.y>0) & (f.w>0) THEN
          normal:=f.iNormal.CloneRegion(f.x,0,f.w,f.y);
          IF f.iSelected#NIL THEN
            selected:=f.iSelected.CloneRegion(f.x,0,f.w,f.y);
          ELSE
            selected:=NIL;
          END;
          f.images[top].image:=IB.CreateBitmapImage(normal,selected);
        END;

        (* bottom *)
        IF (f.y+f.h<f.iNormal.oHeight) & (f.w>0) THEN
          normal:=f.iNormal.CloneRegion(f.x,f.y+f.h,f.w,f.iNormal.oHeight-f.y-f.h);
          IF f.iSelected#NIL THEN
            selected:=f.iSelected.CloneRegion(f.x,f.y+f.h,f.w,f.iNormal.oHeight-f.y-f.h);
          ELSE
            selected:=NIL;
          END;
          f.images[bottom].image:=IB.CreateBitmapImage(normal,selected);
        END;

        (* left *)
        IF (f.x>0) & (f.h>0) THEN
          normal:=f.iNormal.CloneRegion(0,f.y,f.x,f.h);
          IF f.iSelected#NIL THEN
            selected:=f.iSelected.CloneRegion(0,f.y,f.x,f.h);
          ELSE
            selected:=NIL;
          END;
          f.images[left].image:=IB.CreateBitmapImage(normal,selected);
        END;

        (* right *)
        IF (f.x+f.w<f.iNormal.oWidth) & (f.h>0) THEN
          normal:=f.iNormal.CloneRegion(f.x+f.w,f.y,f.iNormal.oWidth-f.x-f.w,f.h);
          IF f.iSelected#NIL THEN
            selected:=f.iSelected.CloneRegion(f.x+f.w,f.y,f.iSelected.oWidth-f.x-f.w,f.h);
          ELSE
            selected:=NIL;
          END;
          f.images[right].image:=IB.CreateBitmapImage(normal,selected);
        END;

        (* top left *)
        IF (f.x>0) & (f.y>0) THEN
          normal:=f.iNormal.CloneRegion(0,0,f.x,f.y);
          IF f.iSelected#NIL THEN
            selected:=f.iSelected.CloneRegion(0,0,f.x,f.y);
          ELSE
            selected:=NIL;
          END;
          f.images[leftTop].image:=IB.CreateBitmapImage(normal,selected);
        END;

        (* bottom left *)
        IF (f.x>0) & (f.y+f.h<f.iNormal.oHeight) THEN
          normal:=f.iNormal.CloneRegion(0,f.y+f.h,f.x,f.iNormal.oHeight-f.y-f.h);
          IF f.iSelected#NIL THEN
            selected:=f.iSelected.CloneRegion(0,f.y+f.h,f.x,f.iNormal.oHeight-f.y-f.h);
          ELSE
            selected:=NIL;
          END;
          f.images[leftBottom].image:=IB.CreateBitmapImage(normal,selected);
        END;

        (* top right *)
        IF (f.x+f.w<f.iNormal.oWidth) & (f.y>0) THEN
          normal:=f.iNormal.CloneRegion(f.x+f.w,0,f.iNormal.oWidth-f.x-f.w,f.y);
          IF f.iSelected#NIL THEN
            selected:=f.iSelected.CloneRegion(f.x+f.w,0,f.iNormal.oWidth-f.x-f.w,f.y);
          ELSE
            selected:=NIL;
          END;
          f.images[rightTop].image:=IB.CreateBitmapImage(normal,selected);
        END;

        (* bottom right *)
        IF (f.x+f.w<f.iNormal.oWidth) & (f.y+f.h<f.iNormal.oHeight) THEN
          normal:=f.iNormal.CloneRegion(f.x+f.w,f.y+f.h,
                                        f.iNormal.oWidth-f.x-f.w,
                                        f.iNormal.oHeight-f.y-f.h);
          IF f.iSelected#NIL THEN
            selected:=f.iSelected.CloneRegion(f.x+f.w,f.y+f.h,
                                              f.iNormal.oWidth-f.x-f.w,
                                              f.iNormal.oHeight-f.y-f.h);
          ELSE
            selected:=NIL;
          END;
          f.images[rightBottom].image:=IB.CreateBitmapImage(normal,selected);
        END;

      END;
    END;

    f.topBorder:=0;
    IF f.images[top].image#NIL THEN
      f.topBorder:=U.MaxLong(f.topBorder,f.images[top].image.height);
    END;
    IF f.images[leftTop].image#NIL THEN
      f.topBorder:=U.MaxLong(f.topBorder,f.images[leftTop].image.height);
    END;
    IF f.images[rightTop].image#NIL THEN
      f.topBorder:=U.MaxLong(f.topBorder,f.images[rightTop].image.height);
    END;

    f.bottomBorder:=0;
    IF f.images[bottom].image#NIL THEN
      f.bottomBorder:=U.MaxLong(f.bottomBorder,f.images[bottom].image.height);
    END;
    IF f.images[leftBottom].image#NIL THEN
      f.bottomBorder:=U.MaxLong(f.bottomBorder,f.images[leftBottom].image.height);
    END;
    IF f.images[rightBottom].image#NIL THEN
      f.bottomBorder:=U.MaxLong(f.bottomBorder,f.images[rightBottom].image.height);
    END;

    f.leftBorder:=0;
    IF f.images[left].image#NIL THEN
      f.leftBorder:=U.MaxLong(f.leftBorder,f.images[left].image.width);
    END;
    IF f.images[leftTop].image#NIL THEN
      f.leftBorder:=U.MaxLong(f.leftBorder,f.images[leftTop].image.width);
    END;
    IF f.images[leftBottom].image#NIL THEN
      f.leftBorder:=U.MaxLong(f.leftBorder,f.images[leftBottom].image.width);
    END;

    f.rightBorder:=0;
    IF f.images[right].image#NIL THEN
      f.rightBorder:=U.MaxLong(f.rightBorder,f.images[right].image.width);
    END;
    IF f.images[rightTop].image#NIL THEN
      f.rightBorder:=U.MaxLong(f.rightBorder,f.images[rightTop].image.width);
    END;
    IF f.images[rightBottom].image#NIL THEN
      f.rightBorder:=U.MaxLong(f.rightBorder,f.images[rightBottom].image.width);
    END;

    FOR x:=0 TO maxPos DO
      IF (f.images[x].image#NIL) & f.images[x].image.alpha THEN
        f.alpha:=TRUE;
      END;
    END;

    f.minWidth:=f.leftBorder+f.rightBorder;
    f.minHeight:=f.topBorder+f.bottomBorder;
  END CalcSize;

  PROCEDURE (f : ImageFrame) Draw*(draw : D.DrawInfo; x,y,w,h : LONGINT);

  VAR
    a,b : LONGINT;

  BEGIN
    a:=x; (* current x position *)

    IF f.images[leftTop].image#NIL THEN
      f.images[leftTop].image.Draw(draw,
                                   a,y,
                                   f.images[leftTop].image.width,
                                   f.images[leftTop].image.height);
      INC(a,f.images[leftTop].image.width);
    END;

    IF f.images[top].image#NIL THEN
      b:=w;
      IF f.images[leftTop].image#NIL THEN
        DEC(b,f.images[leftTop].image.width);
      END;
      IF f.images[rightTop].image#NIL THEN
        DEC(b,f.images[rightTop].image.width);
      END;
      IF b>0 THEN
        f.images[top].image.Draw(draw,a,y,b,f.images[top].image.height);
        INC(a,b);
      END;
    END;

    IF f.images[rightTop].image#NIL THEN
      f.images[rightTop].image.Draw(draw,a,y,
                                    f.images[rightTop].image.width,
                                    f.images[rightTop].image.height);
    END;

    a:=x;
    IF f.images[leftBottom].image#NIL THEN
      f.images[leftBottom].image.Draw(draw,
                                      a,y+h-f.images[leftBottom].image.height,
                                      f.images[leftBottom].image.width,
                                      f.images[leftBottom].image.height);
      INC(a,f.images[leftBottom].image.width);
    END;

    IF f.images[bottom].image#NIL THEN
      b:=w;
      IF f.images[leftBottom].image#NIL THEN
        DEC(b,f.images[leftBottom].image.width);
      END;
      IF f.images[rightBottom].image#NIL THEN
        DEC(b,f.images[rightBottom].image.width);
      END;
      IF b>0 THEN
        f.images[bottom].image.Draw(draw,
                                    a,y+h-f.images[bottom].image.height,
                                    b,f.images[bottom].image.height);
        INC(a,b);
      END;
    END;

    IF f.images[rightBottom].image#NIL THEN
      f.images[rightBottom].image.Draw(draw,
                                       a,y+h-f.images[rightBottom].image.height,
                                       f.images[rightBottom].image.width,
                                       f.images[rightBottom].image.height);
    END;

    a:=y;
    IF f.images[left].image#NIL THEN
      b:=h;
      IF f.images[leftTop].image#NIL THEN
        DEC(b,f.images[leftTop].image.height);
        INC(a,f.images[leftTop].image.height);
      END;
      IF f.images[leftBottom].image#NIL THEN
        DEC(b,f.images[leftBottom].image.height);
      END;
      IF b>0 THEN
        f.images[left].image.Draw(draw,x,a,f.images[left].image.width,b);
      END;
    END;

    a:=y;
    IF f.images[right].image#NIL THEN
      b:=h;
      IF f.images[rightTop].image#NIL THEN
        DEC(b,f.images[rightTop].image.height);
        INC(a,f.images[rightTop].image.height);
      END;
      IF f.images[rightBottom].image#NIL THEN
        DEC(b,f.images[rightBottom].image.height);
      END;
      IF b>0 THEN
        f.images[right].image.Draw(draw,
                                   x+w-f.images[right].image.width,a,
                                   f.images[right].image.width,b);
      END;
    END;
  END Draw;

  PROCEDURE (f : ImageFrame) Free*;

  VAR
    x : LONGINT;

  BEGIN
    FOR x:=0 TO LEN(f.images)-1 DO
      f.images[x].image.Free;
      f.images[x].image:=NIL;
    END;
  END Free;


  PROCEDURE GetFrameEntry(name : ARRAY OF CHAR):LONGINT;

  VAR
    x : LONGINT;

  BEGIN
    FOR x:=0 TO internalFrameCount-1 DO
      IF name=internalFrames[x] THEN
        RETURN x;
      END;
    END;
    RETURN -1;
  END GetFrameEntry;

  PROCEDURE LoadFrame*(name : ARRAY OF CHAR; top : PP.Item; VAR frame : Frame);

  VAR
    buffer : ARRAY 256 OF CHAR;
    pos    : LONGINT;
    iFrame : ImageFrame;

  BEGIN
    top:=top.GetSubEntry("Frame","name",name);
    IF top=NIL THEN
      RETURN;
    END;

    IF top.GetStringEntry("type",buffer) THEN
      IF buffer="external" THEN
        NEW(iFrame);
        iFrame.Init;

        IF top.GetStringEntry("normal",buffer) THEN
          iFrame.normal:=U.StringToText(buffer);
          IF top.GetStringEntry("selected",buffer) THEN
            iFrame.selected:=U.StringToText(buffer);
          END;
          iFrame.x:=top.GetIntEntry("x",-1);
          iFrame.y:=top.GetIntEntry("y",-1);
          iFrame.w:=top.GetIntEntry("w",-1);
          iFrame.h:=top.GetIntEntry("h",-1);
        END;

        iFrame.CalcSize;
        frame:=iFrame;
      ELSE
        pos:=GetFrameEntry(buffer);
        IF pos>=0 THEN
          frame:=CreateFrame(pos);
        END;
      END;
    END;
  END LoadFrame;

  PROCEDURE SaveFrame*(name : ARRAY OF CHAR; top : PP.Item; frame : Frame);

  VAR
    block : PP.BlockItem;

  BEGIN
    IF frame#NIL THEN
      WITH
        frame : ImageFrame DO
        block:=PP.CreateBlockItem("Frame");
        block.AddItemValue("name",name);
        block.AddItemValue("type","external");
        IF frame.normal#NIL THEN
          block.AddItemValue("normal",frame.normal^);
          IF frame.selected#NIL THEN
            block.AddItemValue("selected",frame.selected^);
          END;
          IF (frame.x>=0) & (frame.y>=0) & (frame.w>=0) & (frame.h>=0) THEN
            block.AddItemInt("x",frame.x);
            block.AddItemInt("y",frame.y);
            block.AddItemInt("w",frame.w);
            block.AddItemInt("h",frame.h);
          END;
        END;
        top.AddItem(block);
      | frame : InternalFrame DO
        block:=PP.CreateBlockItem("Frame");
        block.AddItemValue("name",name);
        block.AddItemValue("type",internalFrames[frame.type]);
        top.AddItem(block);
      END;
    END;
  END SaveFrame;

BEGIN
  internalFrames[none]        :="none";
  internalFrames[noneSingle]  :="noneSingle";
  internalFrames[noneDouble]  :="noneDouble";
  internalFrames[single3DIn]  :="single3DIn";
  internalFrames[single3DOut] :="single3DOut";
  internalFrames[single]      :="single";
  internalFrames[double]      :="double";
  internalFrames[double3DIn]  :="double3DIn";
  internalFrames[double3DOut] :="double3DOut";
  internalFrames[double3DTool]:="double3DTool";
  internalFrames[group3D]     :="group3D";
  internalFrames[ridge]       :="ridge";
  internalFrames[doubleFocus] :="doubleFocus";
  internalFrames[dottedFocus] :="dottedFocus";
  internalFrames[w95BO]       :="w95BO";
  internalFrames[w95BI]       :="w95BI";
  internalFrames[w95IO]       :="w95IO";
  internalFrames[w95II]       :="w95II";
  internalFrames[w95CI]       :="w95CI";
  internalFrames[w95CO]       :="w95CO";
  internalFrames[BBBI]        :="BBBI";
  internalFrames[BBBO]        :="BBBO";
  internalFrames[tabRider]    :="tabRider";
  internalFrames[tab]         :="tab";
  internalFrames[textButton]  :="textButton";
END VO:Base:Frame.