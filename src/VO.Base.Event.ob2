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

MODULE VO:Base:Event [OOC_EXTENSIONS];

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

IMPORT U := VO:Base:Util(*,

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
  EventDesc*      = RECORD [ABSTRACT]
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
  KeyEventDesc*   = RECORD [ABSTRACT] (EventDesc)
  (**
    Keyboard event. The application receives this event when a key
    has been pressed or raised.
  *)
                      key*       : LONGINT; (** the keycode *)
                      qualifier* : SET;     (** the current key and mouse qualifiers *)
                      text*      : U.Text;  (** the ASCII-string corresponding to the keyboard event *)
                      textLength*: LONGINT; (** length of the text *)
                      type*      : INTEGER; (** type of key event *)
                    END;

  MouseEvent*     = POINTER TO MouseEventDesc;
  MouseEventDesc* = RECORD [ABSTRACT] (EventDesc)
  (**
    Mouse event. The application recieves this event when one or
    more mousebuttons have been pressed or released. You'll also
    get events when the mouse moves.
  *)
                      qualifier* : SET;     (** the qualifier *)
                      x*,y*      : LONGINT; (** window relative position of mouse *)
                    END;

  ButtonEvent*    = POINTER TO ButtonEventDesc;
  ButtonEventDesc* = RECORD [ABSTRACT] (MouseEventDesc)
  (**
    Mouse event. The application recieves this event when one or
    more mousebuttons have been pressed or released. You'll also
    get events when the mouse moves.
  *)
                       type*   : INTEGER;   (** type of mouse event *)
                       button* : INTEGER;   (** button that caused action *)
                     END;

  MotionEvent*    = POINTER TO MotionEventDesc;
  MotionEventDesc* = RECORD [ABSTRACT] (MouseEventDesc)
  (**
    Mouse event. The application recieves this event when one or
    more mousebuttons have been pressed or released. You'll also
    get events when the mouse moves.
  *)
                     END;

  PROCEDURE GetKeyName*(key : LONGINT; VAR buffer : ARRAY OF CHAR):BOOLEAN;

  BEGIN
    CASE key OF
      backspace:
      COPY("BackSpace",buffer);
    | delete:
      COPY("Delete",buffer);
    | tab:
      COPY("Tab",buffer);
    | leftTab:
      COPY("LeftTab",buffer);
    | return:
      COPY("Return",buffer);
    | escape:
      COPY("Escape",buffer);
    | space:
      COPY("Space",buffer);
    | home:
      COPY("Home",buffer);
    | begin:
      COPY("Begin",buffer);
    | end:
      COPY("End",buffer);
    | left:
      COPY("Left",buffer);
    | right:
      COPY("Right",buffer);
    | up:
      COPY("Up",buffer);
    | down:
      COPY("Down",buffer);
    | prior:
      COPY("Prior",buffer);
    | next:
      COPY("Next",buffer);
    | print:
      COPY("Print",buffer);
    | insert:
      COPY("Insert",buffer);
    | f1:
      COPY("F1",buffer);
    | f2:
      COPY("F2",buffer);
    | f3:
      COPY("F3",buffer);
    | f4:
      COPY("F4",buffer);
    | f5:
      COPY("F5",buffer);
    | f6:
      COPY("F6",buffer);
    | f7:
      COPY("F7",buffer);
    | f8:
      COPY("F8",buffer);
    | f9:
      COPY("F9",buffer);
    | f10:
      COPY("F10",buffer);
    | f11:
      COPY("F11",buffer);
    | f12:
      COPY("F12",buffer);
    ELSE
      buffer[0]:=0X;
      RETURN FALSE;
    END;

    RETURN TRUE;
  END GetKeyName;

  PROCEDURE (e : KeyEvent) [ABSTRACT] GetName*(VAR buffer : ARRAY OF CHAR);
  END GetName;

END VO:Base:Event.