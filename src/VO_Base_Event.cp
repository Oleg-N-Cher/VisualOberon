(**
  This class defines a number of events - based on userinteraction -
  a object (gadget, window) can get. These messages are OS-independant,
  but offer a way to interpret the underlying OS-specific events, however
  the interface to that part of the events is not portable.

  NOTE
  * Not all GUIs can name the qualifiers extactly. F.e. X11 does not make a
    destinction between shift_left and shift_right in the qualifier field
    of an event. use the qualifier mask for that or handle key up and down for
    qualifiers explicitely..
**)

MODULE VO_Base_Event (*OOC_EXTENSIONS*);

(*
    Classhierachie defining a number of OS-independend messgaes.
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

IMPORT U := VO_Base_Util(*,

       xk := X11:Xkeysymdef*);

CONST

  (* Special value for unknown keys or mouse buttons *)
  unknown       * = -1;

  (* type *)
  keyUp         * = 0;
  keyDown       * = 1;
  mouseUp       * = 2;
  mouseDown     * = 3;

  (* qualifiers *)

  button1       * =  1;
  button2       * =  2;
  button3       * =  3;
  button4       * =  4;
  button5       * =  5;

  dragDropButton * = button2;

  qShiftLeft    * =  6;
  qShiftRight   * =  7;
  qCapsLock     * =  8;
  qControlLeft  * =  9;
  qControlRight * = 10;
  qAltLeft      * = 11;
  qAltRight     * = 12;
  qMetaLeft     * = 13;
  qMetaRight    * = 14;
  qSuperLeft    * = 15;
  qSuperRight   * = 16;
  qHyperLeft    * = 17;
  qHyperRight   * = 18;

  (* qualifier masks *)

  shiftMask    * = {qShiftLeft,qShiftRight};
  altMask      * = {qAltLeft,qAltRight};
  controlMask  * = {qControlLeft,qControlRight};
  metaMask     * = {qMetaLeft,qMetaRight};          (** not yet supported *)
  superMask    * = {qSuperLeft,qSuperRight};        (** not yet supported *)
  hyperMask    * = {qHyperLeft,qHyperRight};        (** not yet supported *)

  buttonMask   * = {button1,button2,button3,button4,button5};
  keyMask      * = shiftMask+altMask+controlMask+metaMask+superMask+hyperMask;

  (* key constants *)

  (*Qualifiers *)
  shiftLeft    * = 100;
  shiftRight   * = 101;
  shiftLock    * = 102;
  capsLock     * = 103;
  scrollLock   * = 104;
  numLock      * = 105;
  controlLeft  * = 106;
  controlRight * = 107;
  altLeft      * = 108;
  altRight     * = 109;
  metaLeft     * = 110;
  metaRight    * = 111;
  superLeft    * = 112;
  superRight   * = 113;
  hyperLeft    * = 114;
  hyperRight   * = 115;

  (* Editing *)
  backspace    * = 200;
  delete       * = 201;

  (* Advanced editing *)
  return       * = 300;

  (* Movement *)
  home         * = 401;
  begin        * = 402;
  end          * = 403;
  left         * = 404;
  right        * = 405;
  up           * = 406;
  down         * = 407;
  prior        * = 408;
  next         * = 409;

  (* Special keys *)
  tab          * = 500;
  leftTab      * = 501;
  space        * = 502;
  escape       * = 503;
  print        * = 504;
  insert       * = 505;

  (* Function keys *)
  f1           * = 600;
  f2           * = 601;
  f3           * = 602;
  f4           * = 603;
  f5           * = 604;
  f6           * = 605;
  f7           * = 606;
  f8           * = 607;
  f9           * = 608;
  f10          * = 609;
  f11          * = 610;
  f12          * = 611;

TYPE
  Event*          = POINTER TO EventDesc;
  EventDesc*      = ABSTRACT RECORD
  (**
    Baseclass for events. Currently all objects get a instance
    of this baseclass and then have to analyse the message by
    evaluating the containing X11-event itself. This may change in the
    future. Display will send generate and send instances of inherited
    Classes thatd define abstract events.
  *)
                      reUse* : BOOLEAN;
                    END;

  KeyEvent*       = POINTER TO KeyEventDesc;
  KeyEventDesc*   = ABSTRACT RECORD (EventDesc)
  (**
    Keyboard event. The application receives this event when a key
    has been pressed or raised.
  *)
                      key*       : INTEGER;  (** the keycode *)
                      qualifier* : SET;      (** the current key and mouse qualifiers *)
                      text*      : U.Text;   (** the ASCII-string corresponding to the keyboard event *)
                      textLength*: INTEGER;  (** length of the text *)
                      type*      : SHORTINT; (** type of key event *)
                    END;

  MouseEvent*     = POINTER TO MouseEventDesc;
  MouseEventDesc* = ABSTRACT RECORD (EventDesc)
  (**
    Mouse event. The application recieves this event when one or
    more mousebuttons have been pressed or released. You'll also
    get events when the mouse moves.
  *)
                      qualifier* : SET;     (** the qualifier *)
                      x*,y*      : INTEGER; (** window relative position of mouse *)
                    END;

  ButtonEvent*    = POINTER TO ButtonEventDesc;
  ButtonEventDesc* = ABSTRACT RECORD (MouseEventDesc)
  (**
    Mouse event. The application recieves this event when one or
    more mousebuttons have been pressed or released. You'll also
    get events when the mouse moves.
  *)
                       type*   : SHORTINT;  (** type of mouse event *)
                       button* : SHORTINT;  (** button that caused action *)
                     END;

  MotionEvent*    = POINTER TO MotionEventDesc;
  MotionEventDesc* = ABSTRACT RECORD (MouseEventDesc)
  (**
    Mouse event. The application recieves this event when one or
    more mousebuttons have been pressed or released. You'll also
    get events when the mouse moves.
  *)
                     END;

  PROCEDURE GetKeyName*(key : INTEGER; OUT buffer : ARRAY OF SHORTCHAR):BOOLEAN;

  BEGIN
    CASE key OF
      backspace:
      buffer := "BackSpace";
    | delete:
      buffer := "Delete";
    | tab:
      buffer := "Tab";
    | leftTab:
      buffer := "LeftTab";
    | return:
      buffer := "Return";
    | escape:
      buffer := "Escape";
    | space:
      buffer := "Space";
    | home:
      buffer := "Home";
    | begin:
      buffer := "Begin";
    | end:
      buffer := "End";
    | left:
      buffer := "Left";
    | right:
      buffer := "Right";
    | up:
      buffer := "Up";
    | down:
      buffer := "Down";
    | prior:
      buffer := "Prior";
    | next:
      buffer := "Next";
    | print:
      buffer := "Print";
    | insert:
      buffer := "Insert";
    | f1:
      buffer := "F1";
    | f2:
      buffer := "F2";
    | f3:
      buffer := "F3";
    | f4:
      buffer := "F4";
    | f5:
      buffer := "F5";
    | f6:
      buffer := "F6";
    | f7:
      buffer := "F7";
    | f8:
      buffer := "F8";
    | f9:
      buffer := "F9";
    | f10:
      buffer := "F10";
    | f11:
      buffer := "F11";
    | f12:
      buffer := "F12";
    ELSE
      buffer[0]:=0X;
      RETURN FALSE;
    END;

    RETURN TRUE;
  END GetKeyName;

  PROCEDURE (e : KeyEvent) GetName*(OUT buffer : ARRAY OF SHORTCHAR), NEW, ABSTRACT;

END VO_Base_Event.
