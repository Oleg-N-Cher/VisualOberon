MODULE VO:Base:VecImage;

  (**
    Implements @otype{VecImage}.
  *)

  (*
    Implements some vector images.
    Copyright (C) 2003 Tim Teulings (rael@edge.ping.de)

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
       U  := VO:Base:Util;


CONST

  motifCheck * =  0;
  amigaRadio * =  1;
  simpleCycle* =  2;
  cycle3D    * =  3;
  w95Radio   * =  4;
  w95Check   * =  5;
  arrowLeft  * =  6;
  arrowRight * =  7;
  arrowUp    * =  8;
  arrowDown  * =  9;
  knob       * = 10;
  hSlider    * = 11;
  vSlider    * = 12;
  return     * = 13;
  escape     * = 14;
  default    * = 15;
  w95Knob    * = 16;
  w95Up      * = 17;
  w95Down    * = 18;
  w95Left    * = 19;
  w95Right   * = 20;
  info       * = 21;
  atention   * = 22;
  warning    * = 23;
  question   * = 24;
  hMover     * = 25;
  vMover     * = 26;
  hLineIn3D  * = 27;
  vLineIn3D  * = 28;
  w95HMover  * = 29;
  w95VMover  * = 30;
  w95Combo   * = 31;
  combo      * = 32;
  led        * = 33;
  simpleKnob * = 34;
  none       * = 35;
  simpleUp   * = 36;
  simpleDown * = 37;
  simpleLeft * = 38;
  simpleRight* = 39;
  simpleRadio* = 40;
  simpleCheck* = 41;
  simplePopup* = 42;

  imageCount * = 43;

  checkmark  * =  w95Check;
  radio      * =  w95Radio;
  cycle      * =  simpleCycle;


TYPE
  ImageName     = ARRAY 30 OF CHAR;

  VecImage*     = POINTER TO VecImageDesc;
  VecImageDesc* = RECORD
                    (**
                      Implements scaleable images. If you have a nice scaleable
                      image that maybe widly used, add it here.
                    *)
                    width-,
                    height-  : LONGINT;
                    alpha-   : BOOLEAN; (** The image has an alpha channel *)
                    type-    : LONGINT; (** The image type to be drawn *)
                    drawCap- : SET;
                  END;
VAR
  images- : ARRAY imageCount OF ImageName;

  PROCEDURE (v : VecImage) Init*;

  BEGIN
    v.width:=0;
    v.height:=0;
    v.alpha:=TRUE;
    v.type:=none;
    v.drawCap:={};
  END Init;

  PROCEDURE (v : VecImage) Set*(type : LONGINT);

  VAR
    unit    : LONGINT;
    extent,
    extent2 : D.FontExtentDesc;

  BEGIN
    v.type:=type;

    (* Setting flags depending of image type *)

    CASE v.type OF
      led,         (* Currently the LED image does not draw differently when disabled.
                      This is just a hack to ease use of VO:State *)
      w95Check,
      w95Radio,
      w95Up,
      w95Down,
      w95Left,
      w95Right:
        INCL(v.drawCap,D.canDrawDisabled);
    | hSlider,
      vSlider,
      simpleKnob,
      none:
        INCL(v.drawCap,D.canDrawFocused);
    ELSE
    END;

    CASE v.type OF
      motifCheck,
      amigaRadio,
      cycle3D,
      w95Radio,
      arrowLeft,
      arrowRight,
      arrowUp,
      arrowDown,
      knob,
      hSlider,
      vSlider,
      return,
      escape,
      default,
      w95Knob,
      w95Up,
      w95Down,
      w95Left,
      w95Right,
      info,
      atention,
      warning,
      question,
      w95HMover,
      w95VMover,
      w95Combo,
      combo,
      led,
      none,
      simpleUp,
      simpleDown,
      simpleLeft,
      simpleRight,
      simpleRadio,
      simpleCheck,
      simplePopup:
        v.alpha:=TRUE;
    ELSE
      v.alpha:=FALSE;
    END;

    IF D.display.spaceWidth>D.display.spaceHeight THEN
      unit:=D.display.spaceWidth;
    ELSE
      unit:=D.display.spaceHeight;
    END;

    CASE v.type OF
      simpleCycle:
        v.width:=3*unit;
        v.height:=3*unit;
    | cycle3D:
        v.width:=3*unit;
        v.height:=3*unit;
    | motifCheck:
        v.width:=2*unit+4;
        v.height:=2*unit+4;
    | w95Check:
        v.width:=2*unit+2;
        v.height:=2*unit+2;
    | amigaRadio:
        v.width:=U.RoundUpEven(5*unit DIV 2)-1;
        v.height:=U.RoundUpEven(5*unit DIV 2)-1;
    | w95Radio:
        v.width:=U.RoundUpEven(9*unit DIV 4);
        v.height:=U.RoundUpEven(9*unit DIV 4);
    | arrowLeft,
      arrowRight,
      arrowUp,
      arrowDown:
        v.width:=(3*unit) DIV 2;
        v.height:=(3*unit) DIV 2;
    | w95Left,
      w95Right,
      w95Up,
      w95Down:
        v.width:=unit;
        v.height:=unit;
    | knob,
      w95Knob:
        v.width:=(5*unit) DIV 2;
        v.height:=(5*unit) DIV 2;
    | return,
      escape,
      default:
        v.width:=unit+6;
        v.height:=unit+6;
    | info,
      atention:
        v.width:=2*unit;
        v.height:=6*unit;
    | warning:
        v.width:=6*unit;
        v.height:=4*unit;
    | question:
        v.width:=2*unit;
        v.height:=6*unit;
    | hMover:
        v.width:=unit;
        v.height:=3*unit;
    | vMover:
        v.width:=3*unit;
        v.height:=unit;
    | hSlider:
        v.width:=U.RoundUpEven(5*unit);
        v.height:=U.MaxLong(4,2*unit);
    | vSlider:
        v.width:=U.MaxLong(4,2*unit);
        v.height:=U.RoundUpEven(5*unit);
    | hLineIn3D:
        v.width:=4;
        v.height:=2;
    | vLineIn3D:
        v.width:=2;
        v.height:=4;
    | w95HMover:
        v.width:=U.MaxLong(4,unit);
        v.height:=U.MaxLong(4,3*unit);
    | w95VMover:
        v.width:=U.MaxLong(4,3*unit);
        v.height:=U.MaxLong(4,unit);
    | w95Combo,
      combo:
        v.width:=(5*unit) DIV 2;
        v.height:=(5*unit) DIV 2;
    | led:
      IF D.display.displayType=D.displayTypeTextual THEN
        D.normalFont.TextExtent("*",1,{},extent);
        v.height:=extent.height;
        v.width:=extent.width;
      ELSE
        v.width:=2*unit;
        v.height:=2*unit;
      END;
    | simpleKnob:
        v.width:=unit;
        v.height:=unit;
    | none:
        v.width:=0;
        v.height:=0;
    | simpleUp:
      D.normalFont.TextExtent("^",1,{},extent);
      v.height:=extent.height;
      v.width:=extent.width;
    | simpleDown:
      D.normalFont.TextExtent("v",1,{},extent);
      v.height:=extent.height;
      v.width:=extent.width;
    | simpleLeft:
      D.normalFont.TextExtent("<",1,{},extent);
      v.height:=extent.height;
      v.width:=extent.width;
    | simpleRight:
      D.normalFont.TextExtent(">",1,{},extent);
      v.height:=extent.height;
      v.width:=extent.width;
    | simpleRadio:
      D.normalFont.TextExtent("*",1,{},extent);
      D.normalFont.TextExtent(" ",1,{},extent2);
      v.height:=U.MaxLong(extent.height,extent2.height);
      v.width:=U.MaxLong(extent.width,extent2.width);
    | simpleCheck:
      D.normalFont.TextExtent("X",1,{},extent);
      D.normalFont.TextExtent(" ",1,{},extent2);
      v.height:=U.MaxLong(extent.height,extent2.height);
      v.width:=U.MaxLong(extent.width,extent2.width);
    | simplePopup:
      D.normalFont.TextExtent("^",1,{},extent);
      v.height:=extent.height;
      v.width:=extent.width;
    END;
  END Set;

  PROCEDURE (v : VecImage) DrawRectangle(draw : D.DrawInfo;
                                         x,y,w,h : LONGINT; in : BOOLEAN);

  BEGIN
    IF in THEN
      draw.PushForeground(D.shadowColor);
    ELSE
      draw.PushForeground(D.shineColor);
    END;
    draw.DrawLine(x,y+h-1,x,y);
    draw.DrawLine(x+1,y,x+w-1,y);
    draw.PopForeground;

    IF in THEN
      draw.PushForeground(D.shineColor);
    ELSE
      draw.PushForeground(D.shadowColor);
    END;
    draw.DrawLine(x+w-1,y+1,x+w-1,y+h-1);
    draw.DrawLine(x+w-2,y+h-1,x+1,y+h-1);
    draw.PopForeground;
  END DrawRectangle;

  PROCEDURE (v : VecImage) Draw* (draw : D.DrawInfo; x,y,width,height : LONGINT);

  VAR
    iy       : LONGINT;
    h,h4,h9,
    w,w6,w13,
    xs,ys    : LONGINT;
    points   : ARRAY 3 OF D.PointDesc;
    extent   : D.FontExtentDesc;

  BEGIN
    CASE v.type OF
      motifCheck:
        IF D.selected IN draw.mode THEN
          draw.PushForeground(D.shadowColor);
        ELSE
          draw.PushForeground(D.shineColor);
        END;
        draw.DrawLine(x,y+height-1,x,y+1);
        draw.DrawLine(x,y,x+width-1,y);
        draw.DrawLine(x+1,y+height-2,x+1,y+2);
        draw.DrawLine(x+1,y+1,x+width-2,y+1);
        draw.PopForeground;

        IF D.selected IN draw.mode THEN
          draw.PushForeground(D.shineColor);
        ELSE
          draw.PushForeground(D.shadowColor);
        END;
        draw.DrawLine(x+width-1,y+1,x+width-1,y+height-1);
        draw.DrawLine(x+width-1,y+height-1,x,y+height-1);
        draw.DrawLine(x+width-2,y+2,x+width-2,y+height-2);
        draw.DrawLine(x+width-2,y+height-2,x+1,y+height-2);
        draw.PopForeground;

        IF D.selected IN draw.mode THEN
          draw.PushForeground(D.halfShadowColor);
          draw.FillRectangle(x+4,y+4,width-8,height-8);
          draw.PopForeground;
        END;

    | w95Check:
        IF D.disabled IN draw.mode THEN
          draw.PushForeground(D.backgroundColor);
        ELSE
          draw.PushForeground(D.whiteColor);
        END;
        draw.FillRectangle(x,y,width,height);
        draw.PopForeground;

        draw.PushForeground(D.halfShadowColor);
        draw.DrawLine(x,y+height-1,x,y+1);
        draw.DrawLine(x,y,x+width-1,y);
        draw.PopForeground;

        draw.PushForeground(D.shadowColor);
        draw.DrawLine(x+1,y+height-2,x+1,y+2);
        draw.DrawLine(x+1,y+1,x+width-2,y+1);
        draw.PopForeground;

        draw.PushForeground(D.shineColor);
        draw.DrawLine(x+width-1,y+1,x+width-1,y+height-1);
        draw.DrawLine(x+width-1,y+height-1,x,y+height-1);
        draw.PopForeground;

        draw.PushForeground(D.backgroundColor(*v.background*)); (* TODO: *)
        draw.DrawLine(x+width-2,y+2,x+width-2,y+height-2);
        draw.DrawLine(x+width-2,y+height-2,x+1,y+height-2);
        draw.PopForeground;

        IF D.selected IN draw.mode THEN
          IF D.disabled IN draw.mode THEN
            draw.PushForeground(D.halfShadowColor);
          ELSE
            draw.PushForeground(D.shadowColor);
          END;
          draw.PushStyle(2,D.normalPen);
          draw.DrawLine(x+3,y+3,x+width-4,y+height-4);
          draw.DrawLine(x+width-4,y+3,x+3,y+height-4);
          draw.PopStyle;
          draw.PopForeground;
        END;

    | amigaRadio:
        draw.PushStyle(2,D.normalPen);
        IF D.selected IN draw.mode THEN
          draw.PushForeground(D.shadowColor);
          draw.DrawArc(x+1,y+1,width-2,height-2,45*64,180*64);
          draw.PopForeground;
          draw.PushForeground(D.shineColor);
          draw.DrawArc(x+1,y+1,width-2,height-2,226*64,180*64);
          draw.PopForeground;
          draw.PushForeground(D.halfShadowColor);
          draw.FillArc(x+4,y+4,width-8,height-8,0,360*64);
          draw.PopForeground;
        ELSE
          draw.PushForeground(D.shineColor);
          draw.DrawArc(x+1,y+1,width-2,height-2,45*64,180*64);
          draw.PopForeground;
          draw.PushForeground(D.shadowColor);
          draw.DrawArc(x+1,y+1,width-2,height-2,226*64,180*64);
          draw.PopForeground;
        END;
        draw.PopStyle;

    | w95Radio:
        IF D.disabled IN draw.mode THEN
          draw.PushForeground(D.backgroundColor(*v.background*)); (* TODO: *)
        ELSE
          draw.PushForeground(D.whiteColor);
        END;
        draw.FillArc(x,y,width,height,0,360*64);
        draw.PopForeground;

        draw.PushStyle(2,D.normalPen);
        draw.PushForeground(D.halfShadowColor);
        draw.DrawArc(x,y,width,height,45*64,180*64);
        draw.PopForeground;
        draw.PopStyle;

        draw.PushForeground(D.shadowColor);
        draw.DrawArc(x+1,y+1,width-2,height-2,45*64,180*64);
        draw.PopForeground;

        draw.PushStyle(2,D.normalPen);
        draw.PushForeground(D.shineColor);
        draw.DrawArc(x,y,width,height,225*64,180*64);
        draw.PopForeground;
        draw.PopStyle;

        draw.PushForeground(D.backgroundColor(*v.background*)); (* TODO: *)
        draw.DrawArc(x+1,y+1,width-2,height-2,225*64,180*64);
        draw.PopForeground;

        IF D.selected IN draw.mode THEN
          IF D.disabled IN draw.mode THEN
            draw.PushForeground(D.halfShadowColor);
          ELSE
            draw.PushForeground(D.shadowColor);
          END;
          draw.FillArc(x+4,y+4,width-8,height-8,0,360*64);
          draw.PopForeground;
        END;

    | simpleCycle:
        draw.PushForeground(D.textColor);
        draw.PushStyle(2,D.normalPen);

        w:=5*width DIV 10;
        h:=5*height DIV 10;
        h4:=4*h DIV 10;
        h9:=9*h DIV 10;
        w6:=6*w DIV 10;
        w13:=13*w DIV 10;
        xs:=x+width DIV 5;
        ys:=y+height DIV 4;
        draw.DrawArc(xs,ys,w,h,15*64,270*64);
        draw.DrawLine(xs+w,   ys+h9, xs+w6,  ys+h4);
        draw.DrawLine(xs+w6,  ys+h4, xs+w13, ys+h4);
        draw.DrawLine(xs+w13, ys+h4, xs+w,   ys+h9);

        draw.PopForeground;
        draw.PopStyle;

    | cycle3D:
        xs:=x+D.display.spaceWidth DIV 2;
        w:= width- 2*(D.display.spaceWidth DIV 2);
        ys:=y+D.display.spaceHeight;
        h:=height-2*D.display.spaceHeight;

        draw.PushForeground(D.shineColor);
        draw.DrawLine(xs,ys+h-1,xs,ys+1);
        draw.DrawLine(xs,ys,xs+w-1,ys);

        draw.DrawLine(xs+1,ys+h-2,xs+1,ys+2);
        draw.DrawLine(xs+1,ys+1,xs+w-2,ys+1);
        draw.PopForeground;

        draw.PushForeground(D.shadowColor);
        draw.DrawLine(xs+w-1,ys+1,xs+w-1,ys+h-1);
        draw.DrawLine(xs+w-1,ys+h-1,xs,ys+h-1);

        draw.DrawLine(xs+w-2,ys+2,xs+w-2,ys+h-2);
        draw.DrawLine(xs+w-2,ys+h-2,xs+1,ys+h-2);
        draw.PopForeground;

    | arrowLeft:
        IF D.selected IN draw.mode THEN
          draw.PushForeground(D.shineColor);
        ELSE
          draw.PushForeground(D.shadowColor);
        END;
        draw.DrawLine(x+width-1,y,x+width-1,y+height-1);
        draw.DrawLine(x+width-1,y+height-1,x,y+height DIV 2);
        draw.PopForeground;
        IF D.selected IN draw.mode THEN
          draw.PushForeground(D.shadowColor);
        ELSE
          draw.PushForeground(D.shineColor);
        END;
        draw.DrawLine(x+width-1,y,x,y+height DIV 2);
        draw.PopForeground;

    | arrowRight:
        IF D.selected IN draw.mode THEN
          draw.PushForeground(D.shineColor);
        ELSE
          draw.PushForeground(D.shadowColor);
        END;
        draw.DrawLine(x,y+height-1,x+width-1,y+height DIV 2);
        draw.PopForeground;
        IF D.selected IN draw.mode THEN
          draw.PushForeground(D.shadowColor);
        ELSE
          draw.PushForeground(D.shineColor);
        END;
        draw.DrawLine(x,y+height-1,x,y);
        draw.DrawLine(x,y,x+width-1,y+height DIV 2);
        draw.PopForeground;

    | arrowUp:
        IF D.selected IN draw.mode THEN
          draw.PushForeground(D.shineColor);
        ELSE
          draw.PushForeground(D.shadowColor);
        END;
        draw.DrawLine(x,y+height-1,x+width-1,y+height-1);
        draw.DrawLine(x+width-1,y+height-1,x+width DIV 2,y);
        draw.PopForeground;
        IF D.selected IN draw.mode THEN
          draw.PushForeground(D.shadowColor);
        ELSE
          draw.PushForeground(D.shineColor);
        END;
        draw.DrawLine(x,y+height-1,x+width DIV 2,y);
        draw.PopForeground;

    | arrowDown:
        IF D.selected IN draw.mode THEN
          draw.PushForeground(D.shadowColor);
        ELSE
          draw.PushForeground(D.shineColor);
        END;
        draw.DrawLine(x+width-1,y,x,y);
        draw.DrawLine(x,y,x+width DIV 2,y+height-1);
        draw.PopForeground;
        IF D.selected IN draw.mode THEN
          draw.PushForeground(D.shineColor);
        ELSE
          draw.PushForeground(D.shadowColor);
        END;
        draw.DrawLine(x+width-1,y,x+width DIV 2,y+height-1);
        draw.PopForeground;

    | knob:
        draw.PushForeground(D.shineColor);
        draw.DrawLine(x,  y+height-1,x,          y+1);
        draw.DrawLine(x,  y,           x+width-1,y);
        draw.DrawLine(x+1,y+height-2,x+1,        y+2);
        draw.DrawLine(x+1,y+1,         x+width-2,y+1);
        draw.PopForeground;

        draw.PushForeground(D.shadowColor);
        draw.DrawLine(x+width-1,y+1,         x+width-1,y+height-1);
        draw.DrawLine(x+width-1,y+height-1,x,          y+height-1);
        draw.DrawLine(x+width-2,y+2,         x+width-2,y+height-2);
        draw.DrawLine(x+width-2,y+height-2,x+1,        y+height-2);
        draw.PopForeground;

        IF (width>2*D.display.spaceWidth) & (height>2*D.display.spaceHeight) THEN
          draw.PushStyle(2,D.normalPen);
          draw.PushForeground(D.shadowColor);
          draw.DrawArc(x+(width-D.display.spaceWidth) DIV 2,y+(height-D.display.spaceHeight) DIV 2,
                       D.display.spaceWidth,D.display.spaceHeight,45*64,180*64);
          draw.PopForeground;

          draw.PushForeground(D.shineColor);
          draw.DrawArc(x+(width-D.display.spaceWidth) DIV 2,y+(height-D.display.spaceHeight) DIV 2,
                       D.display.spaceWidth,D.display.spaceHeight,226*64,180*64);
          draw.PopForeground;
          draw.PopStyle;
        END;

    | hSlider,
      vSlider:
        v.DrawRectangle(draw,x,y,width,height,FALSE);
        v.DrawRectangle(draw,x+1,y+1,width-2,height-2,FALSE);

        IF D.selected IN draw.mode THEN
          draw.PushForeground(D.fillColor);
          draw.FillRectangle(x+2,y+2,width-4,height-4);
          draw.PopForeground;
        ELSE
          draw.PushForeground(D.backgroundColor);
          draw.FillRectangle(x+2,y+2,width-4,height-4);
          draw.PopForeground;
        END;

        IF v.type=hSlider THEN
          draw.PushForeground(D.shadowColor);
          draw.DrawLine(x+width DIV 2,y+2,x+width DIV 2,y+height-3);
          draw.PopForeground;
          draw.PushForeground(D.shineColor);
          draw.DrawLine(x+width DIV 2+1,y+2,x+width DIV 2+1,y+height-3);
          draw.PopForeground;
        ELSE
          draw.PushForeground(D.shadowColor);
          draw.DrawLine(x+2,y+height DIV 2,x+width-3,y+height DIV 2);
          draw.PopForeground;
          draw.PushForeground(D.shineColor);
          draw.DrawLine(x+2,y+height DIV 2+1,x+width-3,y+height DIV 2+1);
          draw.PopForeground;
        END;

    | w95Knob:
        draw.PushForeground(D.backgroundColor(*v.background*)); (* TODO: *)
        draw.DrawLine(x,  y+height-1,x,          y+1);
        draw.DrawLine(x,  y,           x+width-2,y);
        draw.PopForeground;

        draw.PushForeground(D.shineColor);
        draw.DrawLine(x+1,y+height-2,x+1,        y+2);
        draw.DrawLine(x+1,y+1,         x+width-3,y+1);
        draw.PopForeground;

        draw.PushForeground(D.shadowColor);
        draw.DrawLine(x+width-1,y,           x+width-1,y+height-1);
        draw.DrawLine(x+width-1,y+height-1,x,          y+height-1);
        draw.PopForeground;

        draw.PushForeground(D.halfShadowColor);
        draw.DrawLine(x+width-2,y+1,         x+width-2,y+height-2);
        draw.DrawLine(x+width-2,y+height-2,x+1,        y+height-2);
        draw.PopForeground;

    | return:
        iy:=y+height;
        draw.PushForeground(D.shineColor);
        draw.DrawLine(x,iy-height DIV 2,x+width DIV 2,iy);
        draw.DrawLine(x+width DIV 2,iy,x+width DIV 2,iy-height DIV 3);
        draw.DrawLine(x+width DIV 2,iy-height DIV 3,x+width,iy-height DIV 3);
        draw.DrawLine(x+width,iy-height DIV 3,x+width,iy-height+height DIV 3);
        draw.PopForeground;

        draw.PushForeground(D.shadowColor);
        draw.DrawLine(x+width,iy-height+height DIV 3,x+width DIV 2,iy-height+height DIV 3);
        draw.DrawLine(x+width DIV 2,iy-height+height DIV 3,x+width DIV 2, iy-height);
        draw.DrawLine(x+width DIV 2,iy-height,x,iy-height DIV 2);
        draw.PopForeground;

    | escape:
        iy:=y+height;
        draw.PushForeground(D.shineColor);
        draw.DrawLine(x+width DIV 2, iy-height,x+width,iy-height DIV 2);
        draw.DrawLine(x+width,iy-height DIV 2,x+width-width DIV 3,iy-height DIV 2);
        draw.DrawLine(x+width-width DIV 3,iy-height DIV 2,x+width-width DIV 3, iy);
        draw.DrawLine(x+width-width DIV 3, iy,x+width DIV 3,iy);
        draw.PopForeground;

        draw.PushForeground(D.shadowColor);
        draw.DrawLine(x+width DIV 3,iy,x+width DIV 3,iy-height DIV 2);
        draw.DrawLine(x+width DIV 3,iy-height DIV 2,x,iy-height DIV 2);
        draw.DrawLine(x,iy-height DIV 2,x+width DIV 2,iy-height);
        draw.PopForeground;

    | default:
        v.DrawRectangle(draw,x,y,width,height,TRUE);

    | w95Left:
        IF D.disabled IN draw.mode THEN
          draw.PushForeground(D.halfShineColor);
        ELSE
          draw.PushForeground(D.shadowColor);
        END;
        points[0].x:=SHORT(x+width DIV 4);
        points[0].y:=SHORT(y+height DIV 2);
        points[1].x:=SHORT(x+width-width DIV 4);
        points[1].y:=SHORT(y+height DIV 4);
        points[2].x:=SHORT(x+width-width DIV 4);
        points[2].y:=SHORT(y+height-height DIV 4);
        draw.FillPolygon(points,3);
        draw.PopForeground;

    | w95Right:
        IF D.disabled IN draw.mode THEN
          draw.PushForeground(D.halfShineColor);
        ELSE
          draw.PushForeground(D.shadowColor);
        END;
        points[0].x:=SHORT(x+width-width DIV 4);
        points[0].y:=SHORT(y+height DIV 2);
        points[1].x:=SHORT(x+width DIV 4);
        points[1].y:=SHORT(y+height DIV 4);
        points[2].x:=SHORT(x+width DIV 4);
        points[2].y:=SHORT(y+height-height DIV 4);
        draw.FillPolygon(points,3);
        draw.PopForeground;

    | w95Up:
        IF D.disabled IN draw.mode THEN
          draw.PushForeground(D.halfShineColor);
        ELSE
          draw.PushForeground(D.shadowColor);
        END;
        points[0].x:=SHORT(x+width DIV 2);
        points[0].y:=SHORT(y+height DIV 4);
        points[1].x:=SHORT(x+width DIV 4);
        points[1].y:=SHORT(y+height-height DIV 4);
        points[2].x:=SHORT(x+width-width DIV 4);
        points[2].y:=SHORT(y+height-height DIV 4);
        draw.FillPolygon(points,3);
        draw.PopForeground;

    | w95Down:
        IF D.disabled IN draw.mode THEN
          draw.PushForeground(D.halfShineColor);
        ELSE
          draw.PushForeground(D.shadowColor);
        END;
        points[0].x:=SHORT(x+width DIV 4);
        points[0].y:=SHORT(y+height DIV 4);
        points[1].x:=SHORT(x+width-width DIV 4);
        points[1].y:=SHORT(y+height DIV 4);
        points[2].x:=SHORT(x+width DIV 2);
        points[2].y:=SHORT(y+height-height DIV 4);
        draw.FillPolygon(points,3);
        draw.PopForeground;

    | info:
        h:=height DIV 6;
        v.DrawRectangle(draw,x,y,width,h,FALSE);

        h4:=(2*height) DIV 3;
        v.DrawRectangle(draw,x,y+2*h,width,h4,FALSE);

    | atention:
        h:=(2*height) DIV 3;
        draw.PushForeground(D.warnColor);
        draw.FillRectangle(x+1,y+1,width-2,h-2);
        draw.PopForeground;
        v.DrawRectangle(draw,x,y,width,h,FALSE);

        h4:=height DIV 6;
        draw.PushForeground(D.warnColor);
        draw.FillRectangle(x+1,y+h+h4+1,width-2,h4-2);
        draw.PopForeground;
        v.DrawRectangle(draw,x,y+h+h4,width,h4,FALSE);

    | warning:
        h:=height DIV 3;
        w:=width DIV 4;

        draw.PushForeground(D.shadowColor);
        draw.DrawLine(x+3*w,y,x+4*w,y+h);
        draw.DrawLine(x+4*w,y+h,x+4*w,y+2*h);
        draw.DrawLine(x+4*w,y+2*h,x+3*w,y+3*h);
        draw.DrawLine(x+3*w,y+3*h,x+w,y+3*h);
        draw.DrawLine(x+w,y+3*h,x,y+2*h);
        draw.PopForeground;

        draw.PushForeground(D.shineColor);
        draw.DrawLine(x,y+2*h,x,y+h);
        draw.DrawLine(x,y+h,x+w,y);
        draw.DrawLine(x+w,y,x+3*w,y);
        draw.PopForeground;

        (* line *)

        v.DrawRectangle(draw,x+w,y+h,2*w,h,TRUE);

    | question:
        h:=height DIV 6;
        w:=width DIV 2;

        draw.PushForeground(D.shadowColor);
        draw.DrawLine(x+2*w,y,x+2*w,y+3*h);
        draw.DrawLine(x+2*w,y+3*h,x+w,y+3*h);
        draw.DrawLine(x+w,y+3*h,x+w,y+4*h);
        draw.DrawLine(x+w,y+4*h,x,y+4*h);
        draw.PopForeground;

        draw.PushForeground(D.shineColor);
        draw.DrawLine(x,y,x+2*w,y);

        draw.DrawLine(x,y+4*h,x,y+2*h);
        draw.DrawLine(x,y+2*h,x+w,y+2*h);
        draw.DrawLine(x+w,y+2*h,x+w,y+h);
        draw.PopForeground;

        draw.PushForeground(D.shadowColor);
        draw.DrawLine(x+w,y+h,x,y+h);
        draw.PopForeground;

        draw.PushForeground(D.shineColor);
        draw.DrawLine(x,y+h,x,y);
        draw.PopForeground;

        (* point *)

        v.DrawRectangle(draw,x,y+5*h,w,h,FALSE);

    | hMover:
        xs:=width DIV 2;
        ys:=2*D.display.spaceHeight;

        draw.PushForeground(D.shadowColor);
        draw.DrawLine(x+xs,y,x+xs,y+D.display.spaceHeight-1);
        draw.PopForeground;
        draw.PushForeground(D.shineColor);
        draw.DrawLine(x+xs+1,y,x+xs+1,y+D.display.spaceHeight-1);
        draw.PopForeground;

        v.DrawRectangle(draw,x+(width-D.display.spaceWidth) DIV 2+1,
                        y+D.display.spaceHeight,
                        D.display.spaceWidth,
                        D.display.spaceHeight,FALSE);

        draw.PushForeground(D.shadowColor);
        draw.DrawLine(x+xs,y+ys,x+xs,y+height-1);
        draw.PopForeground;
        draw.PushForeground(D.shineColor);
        draw.DrawLine(x+xs+1,y+ys,x+xs+1,y+height-1);
        draw.PopForeground;

    | vMover:
        xs:=2*D.display.spaceWidth;
        ys:=height DIV 2;

        draw.PushForeground(D.shadowColor);
        draw.DrawLine(x,y+ys,x+D.display.spaceWidth-1,y+ys);
        draw.PopForeground;
        draw.PushForeground(D.shineColor);
        draw.DrawLine(x,y+ys+1,x+D.display.spaceWidth-1,y+ys+1);
        draw.PopForeground;

        v.DrawRectangle(draw,x+D.display.spaceWidth,
                        y+(height-D.display.spaceHeight) DIV 2+1,
                        D.display.spaceWidth,
                        D.display.spaceHeight,FALSE);

        draw.PushForeground(D.shadowColor);
        draw.DrawLine(x+xs,y+ys,x+width-1,y+ys);
        draw.PopForeground;
        draw.PushForeground(D.shineColor);
        draw.DrawLine(x+xs,y+ys+1,x+width-1,y+ys+1);
        draw.PopForeground;

    | hLineIn3D:
       v.DrawRectangle(draw,x,y+(height-2) DIV 2,width,2,TRUE);

    | vLineIn3D:
       v.DrawRectangle(draw,x+(width-2) DIV 2,y,2,height,TRUE);

    | w95HMover,
      w95VMover:
        v.DrawRectangle(draw,x,y,width,height,FALSE);
        v.DrawRectangle(draw,x+1,y+1,width-2,height-2,FALSE);

    | w95Combo:
        draw.PushForeground(D.backgroundColor(*v.background*)); (* TODO: *)
        draw.DrawLine(x,  y+height-1,x,          y+1);
        draw.DrawLine(x,  y,           x+width-2,y);
        draw.PopForeground;

        draw.PushForeground(D.shineColor);
        draw.DrawLine(x+1,y+height-2,x+1,        y+2);
        draw.DrawLine(x+1,y+1,         x+width-3,y+1);
        draw.PopForeground;

        draw.PushForeground(D.shadowColor);
        draw.DrawLine(x+width-1,y,           x+width-1,y+height-1);
        draw.DrawLine(x+width-1,y+height-1,x,          y+height-1);
        draw.PopForeground;

        draw.PushForeground(D.halfShadowColor);
        draw.DrawLine(x+width-2,y+1,         x+width-2,y+height-2);
        draw.DrawLine(x+width-2,y+height-2,x+1,        y+height-2);
        draw.PopForeground;

        IF D.disabled IN draw.mode THEN
          draw.PushForeground(D.halfShineColor);
        ELSE
          draw.PushForeground(D.shadowColor);
        END;
        points[0].x:=SHORT(x+width DIV 4);
        points[0].y:=SHORT(y+height DIV 4);
        points[1].x:=SHORT(x+width-width DIV 4);
        points[1].y:=SHORT(y+height DIV 4);
        points[2].x:=SHORT(x+width DIV 2);
        points[2].y:=SHORT(y+height-height DIV 4);
        draw.FillPolygon(points,3);
        draw.PopForeground;

    | combo:
        IF D.disabled IN draw.mode THEN
          draw.PushForeground(D.halfShineColor);
        ELSE
          draw.PushForeground(D.shadowColor);
        END;

        points[0].x:=SHORT(x+width DIV 4);
        points[0].y:=SHORT(y+height DIV 4);
        points[1].x:=SHORT(x+width-width DIV 4);
        points[1].y:=SHORT(y+height DIV 4);
        points[2].x:=SHORT(x+width DIV 2);
        points[2].y:=SHORT(y+height-height DIV 4);
        draw.FillPolygon(points,3);
        draw.PopForeground;
    | led:
      IF D.display.displayType=D.displayTypeTextual THEN
        draw.PushFont(D.normalFont,{});
        draw.PushForeground(D.textColor);
        IF D.selected IN draw.mode THEN
          D.normalFont.TextExtent("*",1,{},extent);
          draw.DrawString(x+extent.lbearing,y+D.normalFont.ascent,"*",1);
        ELSE
          D.normalFont.TextExtent(" ",1,{},extent);
          draw.DrawString(x+extent.lbearing,y+D.normalFont.ascent," ",1);
        END;
        draw.PopForeground;
        draw.PopFont;
      ELSE
        IF D.selected IN draw.mode THEN
          IF D.display.colorMode=D.monochromeMode THEN
            draw.PushForeground(D.whiteColor);
          ELSE
            draw.PushForeground(D.warnColor);
          END;
          draw.FillArc(x,y,width-1,height-1,0*64,360*64);
          draw.PopForeground;
        ELSE
          draw.PushForeground(D.shadowColor);
          draw.FillArc(x,y,width-1,height-1,0*64,360*64);
          draw.PopForeground;
        END;

        draw.PushForeground(D.shineColor);
        draw.DrawArc(x+width DIV 4,y+height DIV 4,
                     width DIV 2,height DIV 2,90*64,60*64);
        draw.PopForeground;

        draw.PushForeground(D.shadowColor);
        draw.DrawArc(x,y,width,height,0*64,360*64);
        draw.PopForeground;
      END;
    | simpleKnob:
      IF D.display.displayType=D.displayTypeTextual THEN
        IF D.selected IN draw.mode THEN
          draw.PushForeground(D.fillTextColor);
          draw.PushBackground(D.fillColor);
        ELSE
          draw.PushForeground(D.textColor);
          draw.PushBackground(D.backgroundColor);
        END;
        FOR xs:=x TO x+width-1 DO
          FOR ys:=y TO y+height-1 DO
            draw.DrawString(xs,ys,"#",1);
          END;
        END;
        draw.PopBackground;
        draw.PopForeground;
      ELSE
        IF D.display.colorMode=D.monochromeMode THEN
          draw.PushForeground(D.fillColor);
        ELSE
          IF D.selected IN draw.mode THEN
            draw.PushForeground(D.fillColor);
          ELSE
            draw.PushForeground(D.buttonBackgroundColor);
          END;
        END;
        draw.FillRectangle(x,y,width,height);
        draw.PopForeground;
      END;
    | simpleLeft:
      draw.PushFont(D.normalFont,{});
      draw.PushForeground(D.textColor);
      D.normalFont.TextExtent("<",1,{},extent);
      draw.DrawString(x+extent.lbearing,y+D.normalFont.ascent,"<",1);
      draw.PopForeground;
      draw.PopFont;
    | simpleRight:
      draw.PushFont(D.normalFont,{});
      draw.PushForeground(D.textColor);
      D.normalFont.TextExtent(">",1,{},extent);
      draw.DrawString(x+extent.lbearing,y+D.normalFont.ascent,">",1);
      draw.PopForeground;
      draw.PopFont;
    | simpleUp:
      draw.PushFont(D.normalFont,{});
      draw.PushForeground(D.textColor);
      D.normalFont.TextExtent("^",1,{},extent);
      draw.DrawString(x+extent.lbearing,y+D.normalFont.ascent,"^",1);
      draw.PopForeground;
      draw.PopFont;
    | simpleDown:
      draw.PushFont(D.normalFont,{});
      draw.PushForeground(D.textColor);
      D.normalFont.TextExtent("v",1,{},extent);
      draw.DrawString(x+extent.lbearing,y+D.normalFont.ascent,"v",1);
      draw.PopForeground;
      draw.PopFont;
    | simpleRadio:
      draw.PushFont(D.normalFont,{});
      draw.PushForeground(D.textColor);
      draw.PushBackground(D.backgroundColor);
      IF D.selected IN draw.mode THEN
        D.normalFont.TextExtent("*",1,{},extent);
        draw.DrawFillString(x+extent.lbearing,y+D.normalFont.ascent,"*",1);
      ELSE
        D.normalFont.TextExtent(" ",1,{},extent);
        draw.DrawFillString(x+extent.lbearing,y+D.normalFont.ascent," ",1);
      END;
      draw.PopBackground;
      draw.PopForeground;
      draw.PopFont;
    | simpleCheck:
      draw.PushFont(D.normalFont,{});
      draw.PushForeground(D.textColor);
      IF D.selected IN draw.mode THEN
        D.normalFont.TextExtent("X",1,{},extent);
        draw.DrawFillString(x+extent.lbearing,y+D.normalFont.ascent,"X",1);
      ELSE
        D.normalFont.TextExtent(" ",1,{},extent);
        draw.DrawFillString(x+extent.lbearing,y+D.normalFont.ascent," ",1);
      END;
      draw.PopForeground;
      draw.PopFont;
    | simplePopup:
      draw.PushFont(D.normalFont,{});
      draw.PushForeground(D.textColor);
      D.normalFont.TextExtent("^",1,{},extent);
      draw.DrawFillString(x+extent.lbearing,
                          y+D.normalFont.ascent+ (height-D.normalFont.height) DIV 2,
                          "^",1);
      draw.PopForeground;
      draw.PopFont;
    | none:
    END;
  END Draw;

  PROCEDURE GetImageEntry*(name : ARRAY OF CHAR):LONGINT;

  VAR
    x : LONGINT;

  BEGIN
    FOR x:=0 TO imageCount-1 DO
      IF name=images[x] THEN
        RETURN x;
      END;
    END;
    RETURN -1;
  END GetImageEntry;

  PROCEDURE CreateVecImage*():VecImage;

  VAR
    vecImage : VecImage;

  BEGIN
    NEW(vecImage);
    vecImage.Init;

    RETURN vecImage;
  END CreateVecImage;

BEGIN
  images[motifCheck] :="motifCheck";
  images[amigaRadio] :="amigaRadio";
  images[simpleCycle]:="simpleCycle";
  images[cycle3D]    :="cycle3D";
  images[w95Radio]   :="w95Radio";
  images[w95Check]   :="w95Check";
  images[arrowLeft]  :="arrowLeft";
  images[arrowRight] :="arrowRight";
  images[arrowUp]    :="arrowUp";
  images[arrowDown]  :="arrowDown";
  images[knob]       :="knob";
  images[hSlider]    :="hSlider";
  images[vSlider]    :="vSlider";
  images[return]     :="return";
  images[escape]     :="escape";
  images[default]    :="default";
  images[w95Knob]    :="w95Knob";
  images[w95Up]      :="w95Up";
  images[w95Down]    :="w95Down";
  images[w95Left]    :="w95Left";
  images[w95Right]   :="w95Right";
  images[info]       :="info";
  images[atention]   :="atention";
  images[warning]    :="warning";
  images[question]   :="question";
  images[hMover]     :="hMover";
  images[vMover]     :="vMover";
  images[hLineIn3D]  :="hLineIn3D";
  images[vLineIn3D]  :="vLineIn3D";
  images[w95HMover]  :="w95HMover";
  images[w95VMover]  :="w95VMover";
  images[w95Combo]   :="w95Combo";
  images[combo]      :="combo";
  images[led]        :="led";
  images[simpleKnob] :="simpleKnob";
  images[none]       :="none";
  images[simpleUp]   :="simpleUp";
  images[simpleDown] :="simpleDown";
  images[simpleLeft] :="simpleLeft";
  images[simpleRight]:="simpleRight";
  images[simpleRadio]:="simpleRadio";
  images[simplePopup]:="simplePopup";
END VO:Base:VecImage.