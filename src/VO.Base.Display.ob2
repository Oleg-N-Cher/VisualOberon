MODULE VO:Base:Display [OOC_EXTENSIONS];
(**
  This module is responsible for the handling of the display and all
  its attributes like color, font and that sort. It also exports the
  class @code{DrawInfo} which implements an abstract, that means
  OS-independend, drawing engine. This module only contains the interfaces,
  You can find the OS dependend implemention ina asparate module.

  Most classes here should not be instanciated. Use wrapper classes in
  other modules for this.
*)

(*
    Classes for visualisation.
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

IMPORT D     := VO:Base:DragDrop,
       E     := VO:Base:Event,
       O     := VO:Base:Object,
       P     := VO:Prefs:Base,
       U     := VO:Base:Util,

       Codec := XML:UnicodeCodec,
<* PUSH; Warnings:=FALSE *>
                XML:UnicodeCodec:ImportAll,
<* POP *>
                IO,
       Obj   := Object,
                OS:ProcessParameters,
       str   := Strings,
       t     := Time,

                SYSTEM;

CONST
  (* Different messages the display can listen to *)

  exitMsg*    = 0;
  timeOutMsg* = 1;

  (* Different modes of display color (Display.colorMode) *)

  monochromeMode * = 0; (** The display runs in monochrome mode,
                            that means only black and white are available *)
  greyScaleMode  * = 1; (** The display runs in greyscale mode *)
  colorMode      * = 2; (** The display runs in color mode *)

  backgroundColorIndex       * =  0;
  tableBackgroundColorIndex  * =  1;
  tableBackground2ColorIndex * =  2;
  tableTextColorIndex        * =  3;
  textBackgroundColorIndex   * =  4;
  buttonBackgroundColorIndex * =  5;
  textColorIndex             * =  6;
  shineColorIndex            * =  7;
  halfShineColorIndex        * =  8;
  halfShadowColorIndex       * =  9;
  shadowColorIndex           * = 10;
  fillColorIndex             * = 11;
  fillTextColorIndex         * = 12;
  warnColorIndex             * = 13;
  disabledColorIndex         * = 14;
  focusColorIndex            * = 15;
  blackColorIndex            * = 16;
  whiteColorIndex            * = 17;
  helpBackgroundColorIndex   * = 18;

  colorCount   * = 19;

  (* The different supported fonts  *)

  tinyFontIndex       * =  0;
  scriptFontIndex     * =  1;
  footnoteFontIndex   * =  2;
  smallFontIndex      * =  3;
  normalFontIndex     * =  4;
  largeFontIndex      * =  5;
  LargeFontIndex      * =  6;
  LARGEFontIndex      * =  7;
  hugeFontIndex       * =  8;
  HUGEFontIndex       * =  9;

  smallFixedFontIndex * = 10;
  fixedFontIndex      * = 11;
  hugeFixedFontIndex  * = 12;

  fontCount      * = 13;

  (*
    The different styles a font can have.
    NOTE
    Not all styles can used together. italic and slanted f.e. are
    exclusive.
  *)

  bold        * = 0;
  italic      * = 1;
  underlined  * = 2;
  slanted     * = 3;

  maxStyle    * = 3;
  maxStyleNum * = 2*2*2*2;
  styleMask   * = {bold,italic,underlined,slanted};

  (*
    List of features a font can have. A Font structure has a number of
    attributes. The feature list tells which features are known to this font.
    (A font selection must only that parameter ofa font that are within its
    feature list.

    The other way round, when loading a font you fill in a number of features
    about that font to specify it. VisualOberon is free to ignore some features.
  *)

  fontFoundry*     =  0; (** This should always be set *)
  fontName*        =  1; (** This should always be set *)
  fontHeight*      =  2;
  fontAscent*      =  3; (** I'm not sure if these two are really  feature *)
  fontDescent*     =  4;
  fontPointHeight* =  5; (** This should always be set *)
  fontAvWidth*     =  6;
  fontSetWidth*    =  7;
  fontSpacing*     =  8;
  fontCharSet*     =  9;


  (*
    font width for the above fontSetWidth feature
  *)

  fontNormal *   = 0;
  fontCondensed* = 1;
  fontNarrow*    = 2;
  fontDouble*    = 3;

  (*
    font spacing for the above fontSpacing feature
  *)

  fontFixed*        = 0;
  fontProportional* = 1;
  (* there is also "c", whats that? *)


  (*
    Drawing capabilities. Define which special drawing state
    an object supports. Some obejcts may behave differently depending
    on the drawing capabilities their children support. The may
    delegate some special drawing to them.
  *)

  canDrawFocused*  = 0; (** This signals that the object has special code for drawing itself focused *)
  canDrawDisabled* = 1; (** This signals that the object has special code for drawing itself disabled *)


  (*
    Different DrawInfo.mode
    Not all modes other than "normal" need to be implemented
  *)

  selected*  = 0; (** Not allways supported *)
  activated* = 1; (** Active but not selected *)
  disabled*  = 2; (** Draw yourself disabled *)

  (* pen styles *)

  normalPen * = 0;
  roundPen  * = 1;

  (* draw mode *)

  copy   * = 0;
  invert * = 1;

  (* dash modes *)

  fMode * = 0; (** Draw dashes in foreground color *)
  fbMode* = 1; (** Draw dashes in foreground color, gaps in background color *)

  (* pattern styles *)

  fgPattern* = 0; (** set bits are draw in foreground color, unset bits arn't used *)
  fbPattern* = 1; (** set bits are draw in foreground color, unset in background   *)

  (* various types of data *)

  none * = 0;
  text * = 1;

  (* flags for window positioning *)

  manualPos*      = 0;
  centerOnParent* = 1;
  centerOnScreen* = 2;
  osPos*          = 3;

  (* Bitmap patterns *)

  disableWidth*   = 8;
  disableHeight*  = 2;

  bigChessWidth*  = 16;
  bigChessHeight* = 4;

  (* Type of data layout in memory *)
  littleEndian* = 1;
  bigEndian*    = 2;

  (* Type of display *)
  displayTypeGraphical* = 0;
  displayTypeTextual*   = 1;

  (* Size of display *)
  displaySizeTiny*   = 0;
  displaySizeSmall*  = 1;
  displaySizeNormal* = 2;
  displaySizeLarge*  = 3;
  displaySizeHuge*   = 4;

  (* Types of windows *)
  windowTypeToolbar* = 0; (** Window is a teared off toolbar *)
  windowTypeMenu*    = 1; (** Window is a menu *)
  windowTypePopup*   = 2; (** Window is a temporary popup, similar to a menu *)
  windowTypeUtility* = 3; (** Window is a persistant utilty window *)
  windowTypeSplash*  = 4; (** Window is a splash window *)
  windowTypeSysTray* = 5; (** Place window is system tray - this is highly driver
                              dependend and may not even work at all *)
  windowTypeDialog*  = 6; (** Window is a modal sub window *)
  windowTypeMain*    = 7; (** Window is a main window (there is normaly only one) *)
  windowTypeAuto*    = 8; (** Window is either a sub or a main window,
                              depending on having a parent or not. Driver implementors
                              will never see it, becaue the base class will evaluate
                              the real type *)

TYPE
  ColorName*    = ARRAY 30 OF CHAR;
  FontName*     = ARRAY 100 OF CHAR;
  ThemeName*    = ARRAY 100 OF CHAR;

  Window*       = POINTER TO WindowDesc;
  WindowImpl*   = POINTER TO WindowImplDesc;
  Display*      = POINTER TO DisplayDesc;
  DrawInfo*     = POINTER TO DrawInfoDesc;
  Font*         = POINTER TO FontDesc;


  PrefsCallback*     = POINTER TO PrefsCallbackDesc;
  PrefsCallbackDesc* = RECORD [ABSTRACT]
                         (**
                           Internaly used class for loading of preferences.
                         *)
                       END;

  Color*        = LONGINT; (** Type for a color as used in VisualOberon *)


  Object*     = POINTER TO ObjectDesc;


  ObjectDesc* = RECORD (O.MsgObjectDesc)
                  (**
                    Baseclass for all object that support drag and drop.
                    All GUI objects should inherit from this class
                    (and @code{VO:OObject.Object} does inherit!).
                  *)
                END;

  WindowDesc*     = RECORD (O.MsgObjectDesc)
                      impl-  : WindowImpl;

                      focus,
                      maped,
                      opened : BOOLEAN;
                    END;

  WindowImplDesc* = RECORD [ABSTRACT] (O.MsgObjectDesc)
                      (**
                        The abstract baseclass for all windows. All windows should
                        derive from this class and call the apropiate methods where
                        stated.

                        Window inherits from O.MsgObject, you can send messages to
                        it.
                      *)
                      interface-    : Window;

                      x*,y*,       (* TODO: Fix export *)
                      width*,
                      height*,
                      minWidth*,
                      minHeight*,
                      maxWidth*,
                      horizontalPos*,
                      verticalPos*,
                      maxHeight*     : LONGINT;
                      modalCount-    : LONGINT;
                      parent-        : WindowImpl;
                      title          : STRING; (* TODO: Fix export *)
                      open           : BOOLEAN;
                      type-          : LONGINT;
                  END;

  Bitmap*       = POINTER TO BitmapDesc;
  BitmapDesc*   = RECORD
                    draw*   : DrawInfo; (* TODO: Fix export *)
                    width*,             (* TODO: Fix export *)
                    height* : LONGINT;  (* TODO: Fix export *)
                  END;

  FontDesc*     = RECORD [ABSTRACT]
                    (**
                      Abstract fontdefinition. See @ofield{features}
                      to find out which attributes contain valid
                      information.
                    *)
                    next*,                 (* TODO: Fix export *)
                    last*        : Font;   (* TODO: Fix export *)
                    features*    : SET;    (** Specifies the attributes containing valid data *)
                    foundry*,              (** The creator of the font, sometime needed to differntiate font with the same name *)
                    name*,                 (** The name of the font *)
                    charSet*     : U.Text; (** The charset the font is in *)
                    ascent*,
                    descent*,
                    height*,               (** Internal value for font height (ascent+descent) *)
                    pixelHeight*,          (** Height in pixel *)
                    pointHeight*,          (** Height in points *)
                    avWidth*,
                    setWidth*,
                    spacing*     : LONGINT;
                  END;

  FontExtentDesc* = RECORD
                      (**
                        Returned by @oproc{Font.TextExtent}.
                      *)
                      lbearing*,             (* TODO: Fix export? *)
                      rbearing*,
                      width*,
                      height*,
                      ascent*,
                      descent*  : LONGINT;
                    END;

  FontSize*        = POINTER TO FontSizeDesc;
  FontSizeDesc*    = RECORD
                       next* : FontSize;
                       size* : LONGINT;
                     END;

  FontEncoding*    = POINTER TO FontEncodingDesc;
  FontEncodingDesc*= RECORD
                       (**
                         A font encoding contains a list of available fonts
                         sizes for this encoding.

                         This class and all the objects it references are read
                         only!.
                       *)
                       next*     : FontEncoding;
                       encoding* : U.Text;     (** Encoding for this font *)
                       sizes*    : FontSize;   (** List of sizes this font supplies, NIL if all sizes are supported *)
                       anySize*  : BOOLEAN;
                    END;

  FontFoundry*    = POINTER TO FontFoundryDesc;
  FontFoundryDesc*= RECORD
                      (**
                        The list of available fonts is group by font
                        foundries.

                        The list of families is unsorted.

                        This class and all the objects it references are read
                        only!.
                      *)
                      next*     : FontFoundry;
                      name*     : U.Text;     (** Name of the font foundry *)
                      encodings* : FontEncoding; (** List of all encodings for this font family *)
                    END;

  FontFamily*     = POINTER TO FontFamilyDesc;
  FontFamilyDesc* = RECORD
                      (**
                        A font family contains a list of available encodings.

                        This class and all the objects it references are read
                        only!.
                      *)
                      next*      : FontFamily;
                      name*      : U.Text;       (** Name fo the family *)
                      foundries* : FontFoundry; (** List of all font foundries *)
                    END;


  FontList*       = POINTER TO FontListDesc;
  FontListDesc*   = RECORD
                      (**
                        This class holds a list of all available fonts.
                        Call @oproc{Display.GetFontList} to an instance of
                        this class.

                        The list of foundries is unsorted.

                        This class and all the objects it references are read
                        only!.
                      *)
                      families* : FontFamily; (** List of all font families *)
                    END;

  Timer*          = POINTER TO TimerDesc;
  TimerDesc*      = RECORD
                      (**
                        Create this class using @oproc{Factory.CreateTimer} to
                        make uses of timer and timed actions.
                      *)
                      active-   : BOOLEAN;     (** The timer is active *)
                      interval- : t.Interval;  (** The interval the timer is triggered *)
                      time*     : t.TimeStamp; (** Do not directly write it! *)
                      object-   : O.MsgObject; (** The @otype{O.MsgObject}, the timer message will be send to *)
                    END;

  Sleep*          = POINTER TO SleepDesc;
  SleepDesc*      = RECORD
                    END;

  Channel*        = POINTER TO ChannelDesc;
  ChannelDesc*    = RECORD
                      (**
                        A handle you get back if you have registered a channel
                        to the main event loop.
                      *)
                      channel* : IO.Channel; (** The channel that your registered *)
                    END;

  DisplayDesc * = RECORD [ABSTRACT] (O.MsgObjectDesc)
                    (**
                      Class that abstracts the properties of a display.

                      Should be initialized only once.

                      Holds all process global information about the grafical
                      user interface used.
                    *)
                    driverName*  : STRING; (** Name of the display driver *)
                    appName-     : STRING; (** Name of the application *)

                    displayName* : ARRAY 100 OF CHAR;  (* fix export *)

                    scrWidth*,              (** Width of screen in pixel *)
                    scrHeight*   : LONGINT; (** Height of screen in pixel *)

                    (* colors *)
                    colorMode*   : LONGINT; (** color capability of display *) (* fix export *)
                    colorDepth*  : LONGINT; (** number of color planes *)           (* fix export *)

                    displayType* : LONGINT; (** type of display *)
                    displaySize* : LONGINT; (** size of display *)

                    spaceHeight*,           (** will become obsolete in future *) (* fix export *)
                    spaceWidth*  : LONGINT; (** will become obsolete in future *) (* fix export *)

                    font*        : ARRAY fontCount OF Font;
                  END;

  DisplayPrefs*     = POINTER TO DisplayPrefsDesc;
  DisplayPrefsDesc* = RECORD (P.PrefsDesc)
                        (**
                          In this class all preferences stuff of the display
                          is stored.
                        *)
                        localeCodecFactory* : Codec.Factory;
                        localeCodec*        : Codec.Codec;
                        colors*             : ARRAY colorCount OF ColorName;
                        fonts*              : ARRAY fontCount OF Font;
                        contextTimer*       : LONGINT; (** Time until context window apears in 1/1000 sec. *)
                        theme*              : ThemeName;
                      END;

  ExitMsg*        = POINTER TO ExitMsgDesc;
  ExitMsgDesc*    = RECORD (O.MessageDesc)
                      (**
                        Send this message to Display if you want
                        to leave the application.
                      *)
                    END;

  TimerMsg*     = POINTER TO TimerMsgDesc;
  TimerMsgDesc* = RECORD (O.MessageDesc)
                    (**
                      The message will be send when a timer runs out.
                    *)
                    timer* : Timer; (** The timer that triggered the event *)
                  END;

  SleepMsg*       = POINTER TO SleepMsgDesc;
  SleepMsgDesc*   = RECORD (O.MessageDesc)
                      (**
                        The message an objects gets, when a
                        registered sleep event get called.
                      *)
                      sleep* : Sleep;
                    END;

  ChannelMsg*     = POINTER TO ChannelMsgDesc;
  ChannelMsgDesc* = RECORD (O.MessageDesc)
                      (**
                        The message an objects gets, when a
                        registered fd event get called.
                      *)
                      channel* : Channel;
                    END;

  Msg2Exit*       = POINTER TO Msg2ExitDesc;
  Msg2ExitDesc*   = RECORD (O.HandlerDesc)
                      (**
                        A converter that throuws the incomming message away and
                        generates a ExitMsg for Display.
                      *)
                    END;

  PointDesc* = RECORD
                 (**
                   A point has an x and an y member with size INTEGER.
                   However the X11-function wants a XPoint as parameter,
                   so we simply alias from it. Ports may implement this
                   differently but they must have two members x and y.
                 *)
                 x*,y* : LONGINT;
               END;


  DrawInfoDesc* = RECORD [ABSTRACT]
                    (**
                      The class for all abstract drawings. This class uses a stack
                      mechanism for drawing information like pens, colors, fonts.
                      That means that most drawing primitives use the values
                      that are top most on the stack.

                      If you want to change some of the drawing parameters
                      just push a new value using the Push method. After use
                      be sure to call the aprioate Pop method.


                    *)
                    mode* : SET;
                  END;

(*  Data*     = POINTER TO DataDesc;
  DataDesc* = RECORD
                type*   : LONGINT;
                length* : LONGINT;

                string* : U.Text;
                ints*   : POINTER TO ARRAY OF INTEGER;
                longs*  : POINTER TO ARRAY OF LONGINT;

                xData   : C.charPtr1d;
              END;*)

  Factory*      = POINTER TO FactoryDesc;
  FactoryDesc*  = RECORD [ABSTRACT]
                    (**
                      Factory for generating instances of certain classes.
                    *)
                    driverName* : STRING; (** Name of the display driver *)
                    priority-   : LONGINT;
                  END;

VAR
  systemByteOrder- : SHORTINT;

  (*
    This function will be called when all inportant display filed are filled
    and before the corresponding preferences settings are evaluated.
  *)

  prefsCallback* : PrefsCallback;

  (* Pattern for disabling of gadgets *)

  disablePattern-  : ARRAY 2 OF CHAR;
  bigChessPattern- : ARRAY 8 OF CHAR;

  (* Diverse patterns for dashlines *)

  sPointLine- : ARRAY 2 OF CHAR; (** small  points *)
  mPointLine- : ARRAY 2 OF CHAR; (** medium points *)
  lPointLine- : ARRAY 2 OF CHAR; (** large points  *)

  colorNames- : ARRAY colorCount OF ColorName;
  fontNames-  : ARRAY fontCount OF FontName;

  prefs*      : DisplayPrefs;

  display-    : Display;

  factory-    : Factory;

  (* Pens *)
  backgroundColor       *, (** background color of windows *)
  tableBackgroundColor  *, (** background of table like object *)
  tableBackground2Color *, (** alternate background of table like object *)
  tableTextColor        *,
  textBackgroundColor   *, (** backgrond of text pinput objects *)
  buttonBackgroundColor *, (** background color of button-like objects, should be close to backgroundColor *)
  textColor             *, (** normal text background *)
  shineColor            *,
  halfShineColor        *,
  halfShadowColor       *,
  shadowColor           *,
  fillColor             *, (** color for visualizing selection of filling *)
  fillTextColor         *, (** textcolor while selecting *)
  warnColor             *, (** warn color *)
  disabledColor         *, (** color of "disable"grid *)
  focusColor            *, (** color of focus frame *)
  blackColor            *,
  whiteColor            *,
  helpBackgroundColor   * : Color; (** background color of tooltips *)

  tinyFont*,
  scriptFont*,
  footnoteFont*,
  smallFont*,
  normalFont*,
  largeFont*,
  LargeFont*,
  LARGEFont*,
  hugeFont*,
  HUGEFont*,

  smallFixedFont*,
  fixedFont*,
  hugeFixedFont*   : Font;

  smallChess*,
  bigChess*        : Bitmap;

  home             : STRING;


  PROCEDURE (p : PrefsCallback) [ABSTRACT] LoadPrefs*(appName : ARRAY OF CHAR);
  END LoadPrefs;

  PROCEDURE (p : PrefsCallback) [ABSTRACT] ReadDisplayPrefs*;
  END ReadDisplayPrefs;

  PROCEDURE (p : PrefsCallback) [ABSTRACT] ReadOtherPrefs*;
  END ReadOtherPrefs;

  PROCEDURE (p : PrefsCallback) [ABSTRACT] LoadTheme*(theme : STRING);
  END LoadTheme;

  PROCEDURE (p : PrefsCallback) [ABSTRACT] ReadDisplayTheme*;
  END ReadDisplayTheme;

  PROCEDURE (p : PrefsCallback) [ABSTRACT] ReadOtherTheme*;
  END ReadOtherTheme;

  PROCEDURE (p : PrefsCallback) [ABSTRACT] Free*;
  END Free;

  PROCEDURE (p : DisplayPrefs) Init*;

  VAR
    x : LONGINT;

  BEGIN
    p.Init^;

    p.localeCodecFactory:=Codec.GetFactory("ISO-8859-1");
    p.localeCodec:=p.localeCodecFactory.NewCodec();

    FOR x:=0 TO LEN(p.colors)-1 DO
      p.colors[x]:="";
    END;

    FOR x:=0 TO LEN(p.fonts)-1 DO
      p.fonts[x]:=NIL;
    END;

    p.contextTimer:=3000;
    p.theme:="";
  END Init;


  (* ------------ timer stuff --------------- *)

  PROCEDURE (timer : Timer) Init*;

  BEGIN
    timer.active:=FALSE;
    timer.object:=NIL;
  END Init;

  PROCEDURE (timer : Timer) SetInterval*(interval : t.Interval);

    (**
      Set the relative period of time after that the timer should trigger.
    *)

  BEGIN
    ASSERT(~timer.active);

    timer.interval:=interval;
  END SetInterval;

  PROCEDURE (timer : Timer) SetSecs*(secs, msecs : LONGINT);

    (**
      Set the relative period of time after that the timer should trigger.
    *)

  BEGIN
    ASSERT(~timer.active);

    t.InitInterval(timer.interval,0,secs*1000+msecs);
  END SetSecs;

  PROCEDURE (timer : Timer) SetTime*(time : t.TimeStamp);

  BEGIN
    ASSERT(~timer.active);

    timer.time:=time;
  END SetTime;

  PROCEDURE (timer : Timer) SetObject*(object : O.MsgObject);

    (**
      Set the object that should be triggered when the timer elapses. The object
      will receive an instance of @otype{TimerMsg}.
    *)

  BEGIN
    ASSERT(~timer.active);

    timer.object:=object;
  END SetObject;

  PROCEDURE (timer : Timer) Activate*;

    (**
      Activate the timer.
    *)

  BEGIN
    timer.active:=TRUE;
  END Activate;

  PROCEDURE (timer : Timer) Deactivate*;

    (**
      Deactivate the timer. The timer can be reactivated calling
      @oproc{Timer.Activate}.
    *)

  BEGIN
    timer.active:=FALSE;
  END Deactivate;

  (* ------------ object stuff --------------- *)

  PROCEDURE (object : Object) GetDragInfo*(VAR dragInfo : D.DnDDataInfo);
  (**
    Before the data drop actually occurs the drag object will be asked
    for a list of supported datatypes. This will then be handed to the
    drop object which than can select a apropiate datatype. This type will
    the requested from the drag object and after that will be handed to the
    drop object.

    NOTE
    The is no way to cancel the action at that point the object has already
    made itself valid by answering @code{VO:Object.Object.GetDnDObject}.

    This is only true for internal drag and drop. External drag and drop may
    leave some of the described steps. An object must be prepared of that.
  *)

  BEGIN
  END GetDragInfo;

  PROCEDURE (object : Object) GetDragData*(group, type, action : LONGINT):D.DnDData;
  (**
    All objects support drag actions. Return a derived class of
    VODragDrop.DnDData if you can offer drag data of the given type
    or NIL.

    NOTE
    data should really be of type DataDesc, but there seems to be
    compiler bugs with it. We will change this later.
  *)

  BEGIN
    RETURN NIL;
  END GetDragData;

  PROCEDURE (object : Object) GetDropDataType*(VAR dragInfo : D.DnDDataInfo;
                                               VAR group,type,action : LONGINT):BOOLEAN;
  (**
    The object gets a list of supported datatypes of the drag object and
    has to choose one of them. If there is no fitting datatype it must return
    FALSE.
  *)

  BEGIN
    RETURN FALSE;
  END GetDropDataType;

  PROCEDURE (object : Object) HandleDrop*(data : D.DnDData; action : LONGINT):BOOLEAN;
  (**
    All object can handle drop actions. Return TRUE if you have
    handled the drop event.
  *)

  BEGIN
    RETURN FALSE;
  END HandleDrop;

  PROCEDURE (object : Object) Deselect*;
  (**
    Gets called, when the object has registered a selection using
    Display.RegisterSelection and now should deselect itself because
    somebody else has registered an selection.
  *)

  BEGIN
  END Deselect;

  PROCEDURE (d : DrawInfo) [ABSTRACT] InstallClip*(x,y,w,h : LONGINT);
  (**
    Start a new clipping. Calling this function does not start
    any cliping (in fact it copies the cliping rectangles of the
    current cliping) you must add cliping rectangles using
    DrawInfo.AddRegion.

    Clips are stacked and must be freed in order.
  *)
  END InstallClip;

  PROCEDURE (d : DrawInfo) [ABSTRACT] FreeClip*;
    (**
      Temporary unset the current clipping region.
    *)

  END FreeClip;

  PROCEDURE (d : DrawInfo) [ABSTRACT] ReinstallClip*;
  (**
    Reinstall the clip that was Temporary freed using FreeClip.
  *)

  END ReinstallClip;

  PROCEDURE (d : DrawInfo) [ABSTRACT] AddRegion*(x,y,width,height : LONGINT);
  (**
    Add a new cliping rectangle to the current clip.
  *)
  END AddRegion;

  PROCEDURE (d : DrawInfo) [ABSTRACT] SubRegion*(x,y,width,height : LONGINT);
  (**
    Removes a rectangle from the allowed area.
  *)
  END SubRegion;

  PROCEDURE (d : DrawInfo) [ABSTRACT] GetClipRegion*(VAR x,y,w,h : LONGINT);
  (**
    Returns the outer box of the current clip region.
  *)
  END GetClipRegion;

  PROCEDURE (d : DrawInfo) [ABSTRACT] FreeLastClip*;
  (**
    Free the current clip and reset clipping to the last stacked clip.
  *)
  END FreeLastClip;

  PROCEDURE (d : DrawInfo) [ABSTRACT] PushFont*(handle : Font; style : SET);
  (**
    Push the given font on the stack and make it the current one.
  *)
  END PushFont;

  PROCEDURE (d : DrawInfo) [ABSTRACT] PopFont*;
  (**
    Pops the last stacked font and reactivates the last stacked.
  *)
  END PopFont;

  PROCEDURE (d : DrawInfo) [ABSTRACT] DrawString*(x,y : LONGINT; text : ARRAY OF CHAR; length : LONGINT);
  (**
    Draws the given string in the current font at the given position.
  *)
  END DrawString;

  PROCEDURE (d : DrawInfo) [ABSTRACT] DrawLongString*(x,y : LONGINT; text : ARRAY OF LONGCHAR; length : LONGINT);
  (**
    Similar to @oproc{DrawInfo.DrawString} but for unicode strings.
  *)
  END DrawLongString;

  PROCEDURE (d : DrawInfo) DrawStr*(x,y : LONGINT; text : STRING);

  (**
    Similar to @oproc{DrawInfo.DrawString} but for STRING objects.

    The base class implements this method by calling @oproc{DrawInfo.DrawString}
    or @oproc{DrawInfo.DrawLongString} depending on the real type of the string
    object.
  *)

  VAR
    tmp  : Obj.CharsLatin1;
    tmp2 : Obj.CharsUTF16;

  BEGIN
    WITH
      text : Obj.String8 DO
      tmp:=text.CharsLatin1();
      d.DrawString(x,y,tmp^,text.length);
    | text : Obj.String16 DO
      tmp2:=text.CharsUTF16();
      d.DrawLongString(x,y,tmp2^,text.length);
    END;
  END DrawStr;

  PROCEDURE (d : DrawInfo) [ABSTRACT] DrawFillString*(x,y : LONGINT; text : ARRAY OF CHAR; length : LONGINT);
  (**
    Draws the given string in the current font at the given position.
    The background will be filled with the current background color.
  *)
  END DrawFillString;

  PROCEDURE (d : DrawInfo) [ABSTRACT] DrawFillLongString*(x,y : LONGINT; text : ARRAY OF LONGCHAR; length : LONGINT);
  (**
    Similar to @oproc{DrawInfo.DrawFillString} but for unicode strings.
  *)
  END DrawFillLongString;

  PROCEDURE (d : DrawInfo) DrawFillStr*(x,y : LONGINT; text : STRING);
  (**
    Similar to @oproc{DrawInfo.DrawFillString} but for STRING objects.

    The base class implements this method by calling @oproc{DrawInfo.DrawFillString}
    or @oproc{DrawInfo.DrawFillLongString} depending on the real type of the string
    object.
  *)

  VAR

    tmp  : Obj.CharsLatin1;
    tmp2 : Obj.CharsUTF16;

  BEGIN
    WITH text : Obj.String8 DO
      tmp:=text.CharsLatin1();
      d.DrawFillString(x,y,tmp^,text.length);
    | text : Obj.String16 DO
      tmp2:=text.CharsUTF16();
      d.DrawFillLongString(x,y,tmp2^,text.length);
    END;
  END DrawFillStr;

  PROCEDURE (d : DrawInfo) [ABSTRACT] PushForeground*(color : Color);
  (**
    Push the given color on the stack and make it the current foreground
    color.
  *)
  END PushForeground;

  PROCEDURE (d : DrawInfo) [ABSTRACT] PopForeground*;
  (**
    Pop the last pushed foreground color from the stack and thus reinstalls
    the previous color.
  *)
  END PopForeground;

  PROCEDURE (d : DrawInfo) [ABSTRACT] PushDrawMode*(mode : LONGINT);
  (**
    Push the given draw mode on the stack and make it the current draw mode.
  *)
  END PushDrawMode;

  PROCEDURE (d : DrawInfo) [ABSTRACT] PopDrawMode*;
  (**
    Push the given draw mode on the stack and make it the current draw mode.
  *)
  END PopDrawMode;

  PROCEDURE (d : DrawInfo) [ABSTRACT] PushBackground*(color : Color);
  (**
    Push the given draw mode on the stack and make it the current draw mode.
  *)
  END PushBackground;

  PROCEDURE (d : DrawInfo) [ABSTRACT] PopBackground*;
  (**
    Push the given draw mode on the stack and make it the current draw mode.
  *)
  END PopBackground;

  PROCEDURE (d : DrawInfo) [ABSTRACT] PushStyle*(size, mode : LONGINT);
  (**
    Push the given draw mode on the stack and make it the current draw mode.
  *)
  END PushStyle;

  PROCEDURE (d : DrawInfo) [ABSTRACT] PopStyle*;
  (**
    Push the given draw mode on the stack and make it the current draw mode.
  *)
  END PopStyle;

  PROCEDURE (d : DrawInfo) [ABSTRACT] PushDash*(dashList : ARRAY OF CHAR; mode : LONGINT);
  (**
    Pushes the a new style for drawing lines on the stack.
  *)
  END PushDash;

  PROCEDURE (d : DrawInfo) [ABSTRACT] PopDash*;
  (**
    Pushes the a new style for drawing lines on the stack.
  *)
  END PopDash;

  PROCEDURE (d : DrawInfo) [ABSTRACT] PushPattern*(pattern : ARRAY OF CHAR; width, height : LONGINT; mode : LONGINT);
  (**
    Push a new pattern for filling onto the stack.
  *)
  END PushPattern;

  PROCEDURE (d : DrawInfo) [ABSTRACT] PopPattern*;
  (**
    Pop the last pattern from the stack.
  *)
  END PopPattern;

  PROCEDURE (d : DrawInfo) [ABSTRACT] PushBitmap*(bitmap : Bitmap; mode : LONGINT);
  (**
    Push a new pattern bitmap for filling onto the stack.
  *)
  END PushBitmap;

  PROCEDURE (d : DrawInfo) [ABSTRACT] PopBitmap*;
  (**
    Pop the last pattern from the stack.
  *)
  END PopBitmap;

  PROCEDURE (d : DrawInfo) PushUniqueFillPattern*(pos, maximum : LONGINT);

    (**
      This methods tries to create a unique fill pattern on the stack.
      VisualOberon tries to select the optimal fill pattern for the given
      color mode.VisualOberon cannot offer an unlimited number of different
      fill patterns. After a not specified amount of patterns (at least three)
      VisualOberon will reuse the patterns. E.g. when VisualOberon offers three
      patterns the fourth one will be equal to the first one. VisualOberon will
      also garantee that the the last pattern will not be equal to the first
      pattern. Garanteeing this, you need not take special care when filling
      f.e. a pie chart.

      PARAMETER
      - @oparam{pos} is the running number of the pattern.
      - @oparam{maximum} is the maximum number of patterns you want.
      Only when this value is correctly set VisualOberon will garantee the above
      fact.
      If you don't want VisualOberon to take special care just hand -1.
    *)

  VAR
   pattern : LONGINT;

  BEGIN
    pattern:=pos MOD 3;
    IF (pos=maximum) & (pattern=1) THEN
      pattern:=2;
    END;

    IF display.displayType=displayTypeTextual THEN
      d.PushForeground(textColor);
      d.PushBackground(backgroundColor);
      CASE pattern OF
        0: d.PushPattern("*",1,1,fbMode);
      | 1: d.PushPattern("+",1,1,fbMode);
      | 2: d.PushPattern("@",1,1,fbMode);
      END;
    ELSE
      CASE display.colorMode OF
        colorMode:
        CASE pattern OF
          0: d.PushForeground(warnColor);
        | 1: d.PushForeground(fillColor);
        | 2: d.PushForeground(halfShadowColor);
        END;
      | greyScaleMode:
        CASE pattern OF
          0: d.PushForeground(shineColor);
        | 1: d.PushForeground(halfShineColor);
        | 2: d.PushForeground(halfShadowColor);
        END;
      | monochromeMode: (* only use black and white and some shadings *)
        ASSERT(FALSE);
      END;
    END;
  END PushUniqueFillPattern;

  PROCEDURE (d : DrawInfo) PopUniqueFillPattern*(pos, maximum : LONGINT);

    (**
      Pop the pushed pattern from the stack.
    *)

  VAR
   pattern : LONGINT;

  BEGIN
    pattern:=pos MOD 3;
    IF (pos=maximum) & (pattern=1) THEN
      pattern:=2;
    END;

    IF display.displayType=displayTypeTextual THEN
      d.PopForeground;
      d.PopBackground;
      d.PopPattern;
    ELSE
      IF (display.colorMode#monochromeMode) THEN
        d.PopForeground;
      END;	
    END;
  END PopUniqueFillPattern;

  (* --- Drawing functions --- *)

  PROCEDURE (d : DrawInfo) [ABSTRACT] DrawPoint*(x,y : LONGINT);
  (**
    Draws a point at the given position.
  *)
  END DrawPoint;

  PROCEDURE (d : DrawInfo) DrawPointWithColor*(x,y : LONGINT; color : Color);
  (**
    Draws a point at the given position in the given color.
  *)
  BEGIN
    d.PushForeground(color);
    d.DrawPoint(x,y);
    d.PopForeground;
  END DrawPointWithColor;

  PROCEDURE (d : DrawInfo) [ABSTRACT] DrawLine*(x1,y1,x2,y2 : LONGINT);
    (**
      Draws a line from x1,y1 to x2,y2, including.
    *)
  END DrawLine;

  PROCEDURE (d : DrawInfo) [ABSTRACT] DrawRectangle*(x,y,width,height : LONGINT);
    (**
      Draws a simple, unfilled rectangle in the current foreground color. Note,
      that for displays of type @oconst{displayTypeTextual} the background color
      is also taken into acount. So set the background color to something sensefull,
      too.
    *)
  END DrawRectangle;

  PROCEDURE (d : DrawInfo) [ABSTRACT] FillRectangle*(x,y,width,height : LONGINT);
    (**
      Draws a filled rectangle in the current foreground color.
    *)
  END FillRectangle;

  PROCEDURE (d : DrawInfo) [ABSTRACT] FillRectangleAlpha*(alpha : LONGINT; x,y,width,height : LONGINT);
  END FillRectangleAlpha;

  PROCEDURE (d : DrawInfo) [ABSTRACT] InvertRectangle*(x,y,width,height : LONGINT);
    (**
      Invert the current rectangle. Drawing an inverted rectangle can be used
      for temporary hilighting a certain area of a window.

      Inverting an inverted are result will in the original content (if the area
      has not be marked as dirty). The details of your the engine invert
      the area is indefined.
    *)
  END InvertRectangle;

  PROCEDURE (d : DrawInfo) [ABSTRACT] DrawArc*(x,y,width,height,angle1,angle2 : LONGINT);
  END DrawArc;

  PROCEDURE (d : DrawInfo) [ABSTRACT] FillArc*(x,y,width,height,angle1,angle2 : LONGINT);
  END FillArc;

  PROCEDURE (d : DrawInfo) [ABSTRACT] FillPolygon*(points : ARRAY OF PointDesc; count : LONGINT);
  END FillPolygon;

  PROCEDURE (d : DrawInfo) FillBackground*(x,y,width,height : LONGINT);
  (**
    Fill the given rectangle with the background color defined in Display.
    This is a high level function. You should use it whenever you want to clear
    a area and give it the background color.

    The base class implements this method by pushing the @ovar{backgroundColor},
    drawing a rectangle using @oproc{DrawInfo.FillRectangle} and then poping
    the color back.
  *)

  BEGIN
    d.PushForeground(backgroundColor);
    d.FillRectangle(x,y,width,height);
    d.PopForeground;
  END FillBackground;

  PROCEDURE (d : DrawInfo) [ABSTRACT] CopyArea*(sX,sY,width,height,dX,dY : LONGINT);
  (**
    Fill the given rectangle with the background color defined in Display.
    This is a high level function. You should use it whenever you want to clear
    a area and give it the background color.
  *)
  END CopyArea;

  PROCEDURE (d : DrawInfo) [ABSTRACT] CopyFromBitmap*(bitmap : Bitmap; sX,sY,width,height,dX,dY : LONGINT);
  END CopyFromBitmap;

  PROCEDURE (d : DrawInfo) [ABSTRACT] CopyToBitmap*(sX,sY,width,height,dX,dY : LONGINT; bitmap : Bitmap);
  END CopyToBitmap;

  (* ------------ Font ----------------- *)

  PROCEDURE StyleToPos*(style : SET):LONGINT;

    (**
      Calculates the position in the linearized fontstyle array for the given style.

      This is a helper method for special drivers. Don't touch it, if you are
      not a driver.
    *)

  VAR
    x,y,val,res  : LONGINT;

  BEGIN
    res:=0;
    style:=style*styleMask;
    FOR x:=0 TO SIZE(SET)-1 DO
      IF x IN style THEN
        val:=1;
        FOR y:=1 TO x DO
          val:=val*2;
        END;
        INC(res,val);
      END;
    END;

    RETURN res;
  END StyleToPos;

  PROCEDURE (font : Font) Init*;

  BEGIN
    font.name:=NIL;
    font.charSet:=NIL;
  END Init;

  PROCEDURE (font : Font) [ABSTRACT] TextWidth*(text : ARRAY OF CHAR; length : LONGINT; style : SET):LONGINT;
  (**
    Returns the width of the given text in pixels in respect to the font.
  *)
  END TextWidth;

  PROCEDURE (font : Font) [ABSTRACT] LongTextWidth*(text : ARRAY OF LONGCHAR; length : LONGINT; style : SET):LONGINT;
  END LongTextWidth;

  PROCEDURE (font : Font) [ABSTRACT] StrWidth*(text : STRING; style : SET):LONGINT;
  END StrWidth;

  PROCEDURE (font : Font) [ABSTRACT] TextExtent*(text : ARRAY OF CHAR; length : LONGINT; style : SET; VAR extent : FontExtentDesc);
  (**
    Returns the width of the given text in pixels in respect to the font.
  *)
  END TextExtent;

  PROCEDURE (font : Font) [ABSTRACT] LongTextExtent*(text : ARRAY OF LONGCHAR; length : LONGINT; style : SET; VAR extent : FontExtentDesc);
  END LongTextExtent;

  PROCEDURE (font : Font) [ABSTRACT] StrExtent*(text : STRING; style : SET; VAR extent : FontExtentDesc);
  END StrExtent;

  PROCEDURE (font : Font) [ABSTRACT] Load*():Font;
  END Load;

  PROCEDURE (font : Font) [ABSTRACT] Free*;
  END Free;

  (* ------------ FontList stuff ----------------- *)

  PROCEDURE (f : FontEncoding) GetOrCreateSize*(size : LONGINT):FontSize;

    (**
      Returns the named size if available. Creates and registeres it if not.

      This method is for internal use only.
    *)

  VAR
    fontSize : FontSize;

  BEGIN
    fontSize:=f.sizes;
    WHILE (fontSize#NIL) & (fontSize.size#size) DO
      fontSize:=fontSize.next;
    END;

    IF fontSize#NIL THEN
      RETURN fontSize;
    ELSE
      NEW(fontSize);
      (*      foundry.families:=NIL;*)
      fontSize.size:=size;
      fontSize.next:=f.sizes;
      f.sizes:=fontSize;

      RETURN fontSize;
    END;
  END GetOrCreateSize;

  PROCEDURE (f : FontFoundry) GetOrCreateEncoding*(name : ARRAY OF CHAR):FontEncoding;

    (**
      Returns the named family if available. Creates and registeres it if not.

      This method is for internal use only.
    *)

  VAR
    encoding : FontEncoding;

  BEGIN
    encoding:=f.encodings;
    WHILE (encoding#NIL) & (encoding.encoding^#name) DO
      encoding:=encoding.next;
    END;

    IF encoding#NIL THEN
      RETURN encoding;
    ELSE
      NEW(encoding);
      encoding.sizes:=NIL;
      encoding.anySize:=FALSE;
      NEW(encoding.encoding,str.Length(name)+1);
      COPY(name,encoding.encoding^);
      encoding.next:=f.encodings;
      f.encodings:=encoding;

      RETURN encoding;
    END;
  END GetOrCreateEncoding;

  PROCEDURE (f : FontFamily) GetOrCreateFoundry*(name : ARRAY OF CHAR):FontFoundry;

    (**
      Returns the named foundry if available. Creates and registeres it if not.

      This method is for internal use only.
    *)

  VAR
    foundry : FontFoundry;

  BEGIN
    foundry:=f.foundries;
    WHILE (foundry#NIL) & (foundry.name^#name) DO
      foundry:=foundry.next;
    END;

    IF foundry#NIL THEN
      RETURN foundry;
    ELSE
      NEW(foundry);
      foundry.encodings:=NIL;
      NEW(foundry.name,str.Length(name)+1);
      COPY(name,foundry.name^);
      foundry.next:=f.foundries;
      f.foundries:=foundry;

      RETURN foundry;
    END;

  END GetOrCreateFoundry;

  PROCEDURE (f : FontList) GetOrCreateFamily*(name : ARRAY OF CHAR):FontFamily;

    (**
      Returns the named family if available. Creates and registeres it if not.

      This method is for internal use only.
    *)

  VAR
    family : FontFamily;

  BEGIN
    family:=f.families;
    WHILE (family#NIL) & (family.name^#name) DO
      family:=family.next;
    END;

    IF family#NIL THEN
      RETURN family;
    ELSE
      NEW(family);
      NEW(family.name,str.Length(name)+1);
      COPY(name,family.name^);
	  family.foundries:=NIL;
      family.next:=f.families;
      f.families:=family;

      RETURN family;
    END;
  END GetOrCreateFamily;

  (* ------------ Factory ----------------- *)

  PROCEDURE (f : Factory) Init*;

  BEGIN
    f.priority:=0;

    f.driverName:="";
  END Init;

  PROCEDURE (f : Factory) SetPriority*(priority : LONGINT);

  BEGIN
    f.priority:=priority;
  END SetPriority;

  PROCEDURE (f : Factory) [ABSTRACT] CreateFont*():Font;
  END CreateFont;

  PROCEDURE (f : Factory) [ABSTRACT] CreateDrawInfo*():DrawInfo;
  END CreateDrawInfo;

  PROCEDURE (f : Factory) [ABSTRACT] CreateWindowImpl*():WindowImpl;
  END CreateWindowImpl;

  PROCEDURE (f : Factory) [ABSTRACT] CreateDisplay*():Display;
  END CreateDisplay;

  PROCEDURE (f : Factory) [ABSTRACT] CreateBitmap*():Bitmap;
  END CreateBitmap;

  PROCEDURE (f : Factory) [ABSTRACT] CreateTimer*():Timer;
  END CreateTimer;

(* ============== Implementation classes ============== *)

  PROCEDURE (d : Display) Init*;

  BEGIN
    d.appName:="";

    d.spaceWidth:=8;
    d.spaceHeight:=8;
  END Init;

  PROCEDURE (d : Display) SetAppName*(name : STRING);

  BEGIN
    d.appName:=name;
  END SetAppName;

  PROCEDURE (d : Display) GetPrefsPath*():STRING;

  BEGIN
    RETURN home+"/.VisualOberon/";
  END GetPrefsPath;

  PROCEDURE (d : Display) GetPrefsName*():STRING;

  BEGIN
    RETURN d.GetPrefsPath()+"VisualOberon"+"-"+d.driverName+".res";
  END GetPrefsName;

  PROCEDURE (d : Display) GetThemePath*(theme : STRING):STRING;

  BEGIN
    RETURN d.GetPrefsPath()+"themes/"+theme+"/";
  END GetThemePath;

  PROCEDURE (d : Display) GetThemeName*(theme : STRING):STRING;

  BEGIN
    RETURN d.GetThemePath(theme)+"theme.xml";
  END GetThemeName;

  PROCEDURE (d : Display) [ABSTRACT] Open*():BOOLEAN;

  (**
    Initialize a instance of the Display class.
  *)

  END Open;

  (* -------- font stuff of display ------------- *)

  PROCEDURE (d : Display) [ABSTRACT] GetFontList*():FontList;

    (**
      Returns a list of all available fonts.
    *)

  END GetFontList;

  (* -------- color stuff of display ------------- *)

  PROCEDURE (d : Display) [ABSTRACT] AllocateColor8*(r,g,b : SHORTINT;
                                                     default : LONGINT;
                                                     VAR color : Color);
  (**
    Allocate a color with the given rgb values. Since colors cannot be
    garbage collected you must store the color id and free the color later.

    RESULT
    A color id. You need to store this to free the color later.

    NOTE
    You cannot be sure that all bits of the color values will be used.
    X11 f.e. only uses 16 bit for color description.
  *)
  END AllocateColor8;

  PROCEDURE (d : Display) [ABSTRACT] AllocateColor16*(r,g,b : INTEGER;
                                                      default : Color;
                                                      VAR color : Color);
  (**
    Allocate a color with the given rgb values. Since colors cannot be
    garbage collected you must store the color id and free the color later.

    RESULT
    A color id. You need to store this to free the color later.

    NOTE
    You cannot be sure that all bits of the color values will be used.
    X11 f.e. only uses 16 bit for color description.
  *)
  END AllocateColor16;

  PROCEDURE (d : Display) [ABSTRACT] AllocateColor32*(r,g,b : LONGINT;
                                                      default : Color;
                                                      VAR color : Color);
  (**
    Allocate a color with the given rgb values. Since colors cannot be
    garbage collected you must store the color id and free the color later.

    RESULT
    A color id. You need to store this to free the color later.

    NOTE
    You cannot be sure that all bits of the color values will be used.
    X11 f.e. only uses 16 bit for color description.
  *)
  END AllocateColor32;

  PROCEDURE (d : Display) [ABSTRACT] AllocateNamedColor*(name : ARRAY OF CHAR;
                                                         default : Color;
                                                         VAR color : Color);
  END AllocateNamedColor;

  PROCEDURE (d : Display) [ABSTRACT] IsAllocatedColor*(color : Color):BOOLEAN;
  END IsAllocatedColor;

  PROCEDURE (d : Display) [ABSTRACT] FreeColor*(color : Color);
  END FreeColor;

  PROCEDURE (d : Display) [ABSTRACT] AddTimer*(timer : Timer);
    (**
      Add a timeout. The object will be send a @code{TimerMsg} after
      the given relative amount of time has been elapsed.

      NOTE
      It is garanteed that the time has been elasped when the object
      get notified. However, since there is no real multitasking involved,
      it may get called anytime later.

      If the timeout has been elasped and the message has been send, there is
      no need to remove the @code{Timer}. @code{Display} does this for you.
    *)
  END AddTimer;

  PROCEDURE (d : Display) [ABSTRACT] RemoveTimer*(timer : Timer);
  (**
    Remove a @code{Timer} before it has been elasped. It is save to call this
    function with a Timer-instance of an already elapsed time event.
  *)
  END RemoveTimer;

  PROCEDURE (d : Display) [ABSTRACT] AddSleep*(object : O.MsgObject):Sleep;
  (**
    Using this method, you can add an object to be called whenever the application is
    not busy. This way you can write applications that take as much processor time as
    possible while still listening to windowing events.

    Note, that you must design the action to be taken when the object is called to be
    rather short, since all event handling will be blocked during this time. If you
    want do handle long time actions you must split them into short partial actions.
  *)
  END AddSleep;

  PROCEDURE (d : Display) [ABSTRACT] RemoveSleep*(sleep : Sleep);
  (**
    Removes the given sleep notifier.
  *)
  END RemoveSleep;

  PROCEDURE (d : Display) [ABSTRACT] AddChannel*(channel : IO.Channel;
                                                 ops : SET;
                                                 object : O.MsgObject):Channel;
  (**
    Using this method, you can add an object to be called whenever the handed
    @otype{IO.Channel} gets available for the handed operation @oparam{ops}.

    Note, that you must design the action to be taken when the object is
    called to be rather short, since the complete event handling will be
    blocked during this time. If you want do handle long time actions you
    must split them into short partial actions.
  *)
  END AddChannel;

  PROCEDURE (d : Display) [ABSTRACT] RemoveChannel*(channel : Channel);
  (**
    Removes the given sleep notifier.
  *)
  END RemoveChannel;

  PROCEDURE (d : Display) [ABSTRACT] CreateBitmap*(width, height : LONGINT):Bitmap;
    (**
      Create a @otype{Bitmap} with the given width and height. You must free
      the allocated @otype{Bitmap} by calling @oproc{Display.FreeBitmap}.

      See @otype{Bitmap} for more information about bitmaps.
    *)
  END CreateBitmap;

  PROCEDURE (d : Display) [ABSTRACT] CreateBitmapPattern*(pattern : ARRAY OF CHAR; width, height : LONGINT):Bitmap;
    (**
      Create a @otype{Bitmap} with the given width and height, filled with
      the given pattern.

      See @otype{Bitmap} for more information about bitmaps.
    *)
  END CreateBitmapPattern;

  PROCEDURE (d : Display) [ABSTRACT] FreeBitmap*(bitmap : Bitmap);
    (**
      Free a @otype{Bitmap} allocated using @oproc{Display.CreateBitmap} or
      @oproc{Display.CreateBitmapPattern}.
    *)
  END FreeBitmap;

  PROCEDURE (d : Display) [ABSTRACT] SetMultiClickTime*(t : LONGINT);
  END SetMultiClickTime;

  PROCEDURE (d : Display) [ABSTRACT] Beep*;
  (**
    Do a display beep.
  *)
  END Beep;

  PROCEDURE (d : Display) [ABSTRACT] RegisterSelection*(object : Object; window : Window):BOOLEAN;
  (**
    using this method an object can register itself a holder of the current
    selection.
  *)
  END RegisterSelection;

  PROCEDURE (d : Display) [ABSTRACT] CancelSelection*;
  (**
    Using this method an object can cancel the before registered selection.
    This can f.e happen, when the object hides.

    NOTE
    The current object holding the selection gets notified via calling
    its Object.Deselect method.
  *)
  END CancelSelection;

  PROCEDURE (d : Display) [ABSTRACT] QuerySelection*(window: Window; object: Object; type: LONGINT):BOOLEAN;
  (**
    Call this method if you want to get the current value of the operating
    system global selection.

    If VisualOberon can get the selection, the @oproc{Object.HandleDrop}
    method of the querying object will be called with a @oconst{D.insert} action.
    Note that there may be some undeterminate amount of time between the query and
    the drop, it is also possible that @oproc{Object.HandleDrop} method may
    never will called.
  *)
  END QuerySelection;

  PROCEDURE (d : Display) SetClipboard*(content : STRING):BOOLEAN;
    (**
      Set the operating system clipboard to the given string value.

      Note, that the interface of this method will change to support more
      datatypes in the future.
    *)

  BEGIN
    RETURN FALSE;
  END SetClipboard;

  PROCEDURE (d : Display) GetClipboard*(object: Object):BOOLEAN;

    (**
      Request the current value of the operating system clipboard.

      If VisualOberon can get the clipboard, the @oproc{object.HandleDrop}
      method of the querying object will be called with a @oconst{D.insert} action.
      Note that there may be some undeterminate amount of time between the query and
      the drop, it is also possible that @oproc{object.HandleDrop} method may
      never will called.
    *)

  BEGIN
    RETURN FALSE;
  END GetClipboard;

  PROCEDURE (d : Display) ClearClipboard*;

    (**
      Clear the operating system global clipboard.
    *)
  BEGIN
  END ClearClipboard;

  PROCEDURE (d : Display) [ABSTRACT] EventLoop*;
  (**
    This is the main event loop of your application. Call this to get
    things started. If you want to leave the event loop and finish the
    application, send a ExitMsg to the display.

    Not that modal windows have their own modal (and local) event loop
    (@oproc{Window.EventLoop}).
  *)
  END EventLoop;

  PROCEDURE (d : Display) [ABSTRACT] Receive*(message : O.Message);
  (**
    The message receive function of the Display. Currently only @otype{ExitMsg} and
    @otype{TimerMsg}s for controlling QuickHelp apearance are directly evaluated.
  *)
  END Receive;

  PROCEDURE (d : Display) [ABSTRACT] PutBackEvent*(event : E.Event; destWin : Window);
  (**
    Put an event back into the message handling queue, so that it can be
    rehandled.
  *)
  END PutBackEvent;

  PROCEDURE (d : Display)[ABSTRACT] ReinitWindows*;
    (**
      Signal all windows to reinitialize them. This works effectivly like an
      reopen. Call this method if you have changed some preferences settings
      and want all windows to adapt to these new settings.
    *)
  END ReinitWindows;

  PROCEDURE (d : Display) [ABSTRACT] Exit*;
  (**
    This sets the exit flag to true. The handler-method will be left after
    this flag has been set.
  *)
  END Exit;

  PROCEDURE (d : Display) [ABSTRACT] Close*;
  (**
    This closes the display and frees all resources.
    Call this method at the end of your program.
  *)
  END Close;

  PROCEDURE (d : Display) KeyToKeyDescription*(qualifier : SET; key : STRING;
                                               VAR description : STRING);

    (**
      Converts a given key description including @oparam{qualifier} and
      @oparam{key} into a textual @oparam{description}. This routine does
      not differentiate between logical identical qualifiers, that apear
      mutliple time, like @oconst{E.qShiftLeft} and @oconst{E.qShiftRight}.
      The will be maped to the same string.

      The current implementation does only handle printable @oparam{key}s
      correctly.
    *)

  BEGIN
    description:="";

    IF qualifier#{} THEN
      IF (E.qShiftLeft IN qualifier) OR (E.qShiftRight IN qualifier) THEN
        description:=description+"S";
      END;
      IF (E.qControlLeft IN qualifier) OR (E.qControlRight IN qualifier) THEN
        description:=description+"C";
      END;
      IF (E.qAltLeft IN qualifier) OR (E.qAltRight IN qualifier) THEN
        description:=description+"A";
      END;
      IF (E.qMetaLeft IN qualifier) OR (E.qMetaRight IN qualifier) THEN
        description:=description+"M";
      END;
      IF (E.qSuperLeft IN qualifier) OR (E.qSuperRight IN qualifier) THEN
        description:=description+"X";
      END;
      IF (E.qHyperLeft IN qualifier) OR (E.qHyperRight IN qualifier) THEN
        description:=description+"H";
      END;
      description:=description+"+";
    END;

    description:=description+key;
  END KeyToKeyDescription;

  PROCEDURE (d : Display) KeyDescriptionToKey*(description : STRING;
                                               VAR qualifier : SET;
                                               VAR key : STRING):BOOLEAN;

    (**
      Converts a given textual key @oparam{description} like it is returned
      by @oproc{Display.KeyToKeyDescription} into a keydescription containing of
      @oparam{qualifier} and @oparam{key}.

      The method returns @code{TRUE} if the conversion succeeds, @code{FALSE}
      if the conversion was not possible because of syntactical error in the
      description format.
    *)

  VAR
    x,pos : INTEGER;

  BEGIN
    qualifier:={};
    key:=NIL;

    pos:=0;
    WHILE (pos<description.length) & (description.CharAt(pos)#"+") DO
      INC(pos);
    END;

    IF pos<description.length THEN
      FOR x:=0 TO pos-1 DO
        CASE description.CharAt(x) OF
          "S": qualifier:=qualifier+E.shiftMask;
        | "C": qualifier:=qualifier+E.controlMask;
        | "A": qualifier:=qualifier+E.altMask;
        | "M": qualifier:=qualifier+E.metaMask;
        | "X": qualifier:=qualifier+E.superMask;
        | "H": qualifier:=qualifier+E.hyperMask;
        ELSE
          RETURN FALSE;
        END;
      END;

      INC(pos);
    ELSE
      pos:=0;
    END;

    IF pos>=description.length THEN
      RETURN FALSE;
    END;

    key:=description.Substring(pos,description.length);

    RETURN TRUE;
  END KeyDescriptionToKey;

  (* ------------ Window ----------------- *)

  PROCEDURE (w : WindowImpl) IsOpen*():BOOLEAN;

  BEGIN
    RETURN w.open;
  END IsOpen;

  PROCEDURE (w : WindowImpl) SetParent*(parent : Window);

  (**
    See @oproc{Window.SetParent}.
  *)

  BEGIN
    IF ~w.IsOpen() THEN
      IF (parent#NIL) & (parent.impl#w) THEN
        w.parent:=parent.impl;
      ELSE
        w.parent:=NIL;
      END;
    END;
  END SetParent;

  PROCEDURE (w : WindowImpl) GetParent*():Window;

  BEGIN
    IF w.parent#NIL THEN
      RETURN w.parent.interface;
    ELSE
      RETURN NIL;
    END;
  END GetParent;

  PROCEDURE (w : WindowImpl) GetTopWindow*():Window;

  VAR
    window : WindowImpl;

  BEGIN
    IF w.parent=NIL THEN
      RETURN NIL;
    ELSE
      window:=w;
      WHILE window.parent#NIL DO
        window:=window.parent;
      END;
      RETURN window.interface;
    END;
  END GetTopWindow;

  PROCEDURE (w : WindowImpl) GetTitle*():STRING;

  BEGIN
    RETURN w.title;
  END GetTitle;

  PROCEDURE (w : WindowImpl) SetSize*(width,height : LONGINT);

    (**
      See @oproc{Window.SetSize}.
    *)

  BEGIN
    IF ~w.IsOpen() THEN
      w.width:=width;
      w.height:=height;
    END;
  END SetSize;

  PROCEDURE (w : WindowImpl) SetMinSize*(width,height : LONGINT);

    (**
      See @oproc{Window.SetMinSize}.
    *)

  BEGIN
    IF ~w.IsOpen() THEN
      IF width>=0 THEN
        w.minWidth:=width;
      END;
      IF height>=0 THEN
        w.minHeight:=height;
      END;
    END;
  END SetMinSize;

  PROCEDURE (w : WindowImpl) SetMaxSize*(width,height : LONGINT);

    (**
      See @oproc{Window.SetMaxSize}.
    *)

  BEGIN
    IF ~w.IsOpen() THEN
      IF width>=0 THEN
        w.maxWidth:=width;
      END;
      IF height>=0 THEN
        w.maxHeight:=height;
      END;
    END;
  END SetMaxSize;

  PROCEDURE (w : WindowImpl) SetPos*(x,y : LONGINT);

    (**
      See @oproc{Window.SetPos}.
    *)

  BEGIN
    IF ~w.IsOpen() THEN
      w.x:=x;
      w.y:=y;
    END;
  END SetPos;

  PROCEDURE (w : WindowImpl) SetPosition*(horiz, vert : LONGINT);

    (**
      See @oproc{Window.SetPosition}.
    *)

  BEGIN
    w.horizontalPos:=horiz;
    w.verticalPos:=vert;
  END SetPosition;

  (* ------------ Handlers for window-events -------------- *)

  PROCEDURE (w : WindowImpl) [ABSTRACT] GetDrawInfo*():DrawInfo;
    (**
      See @oproc{Window.GetDrawInfo}.
    *)
  END GetDrawInfo;

  PROCEDURE (w : WindowImpl) [ABSTRACT] Exit*;
    (**
      See @oproc{Window.Exit}.
    *)
  END Exit;

  PROCEDURE (w : WindowImpl) [ABSTRACT] IsInEventLoop*():BOOLEAN;
  END IsInEventLoop;

  PROCEDURE (w : WindowImpl) Init*;
  (**
    Initialize an instance of the window class.

    NOTE
    You must call this before using a window.
  *)

  BEGIN
    w.Init^;

    w.title:="";

    w.parent:=NIL;

    w.x:=0;
    w.y:=0;

    w.width:=0;
    w.height:=0;

    w.minWidth:=0;
    w.minHeight:=0;

    w.maxWidth:=MAX(LONGINT);
    w.maxHeight:=MAX(LONGINT);

    w.horizontalPos:=osPos;
    w.verticalPos:=osPos;

    w.open:=FALSE;
    w.type:=windowTypeAuto;

    w.modalCount:=0;
  END Init;

  PROCEDURE (w : WindowImpl) SetTitle*(name : STRING);

    (**
      See @oproc{Window.SetTitle}.
    *)

  BEGIN
    w.title:=name;
  END SetTitle;

  PROCEDURE (w : WindowImpl) Resize*(width,height : LONGINT);
    (**
      See @oproc{Window.Resize}.
    *)

  BEGIN
    w.width:=width;
    w.height:=height;
  END Resize;

  PROCEDURE (w : WindowImpl)[ABSTRACT] Grab*(grab : BOOLEAN);
    (**
      See @oproc{Window.Grab}.
    *)
  END Grab;

  PROCEDURE (w : WindowImpl) Open*():BOOLEAN;
  (**
    Opens the window.

    NOTE
    Derived classes must call th e baseclass method.
  *)

  BEGIN
    IF w.type=windowTypeAuto THEN
      IF w.parent#NIL THEN
        w.type:=windowTypeDialog;
      ELSE
        w.type:=windowTypeMain;
      END;
    END;

    CASE w.type OF
(*      D.windowTypeMenu,*)
      windowTypePopup,
      windowTypeSplash:
      w.Grab(TRUE);
    ELSE
    END;

    w.open:=TRUE;
    w.modalCount:=0;

    RETURN TRUE;
  END Open;

  PROCEDURE (w : WindowImpl) Close*;
  (**
    Removes the window from the list of windows known by the
    Display.

    NOTE
    You must call this method before closing the window.
  *)

  BEGIN
    IF w.IsInEventLoop() THEN
      w.Exit;
    END;

    w.open:=FALSE;

    w.modalCount:=0;
  END Close;

  PROCEDURE (w : WindowImpl) [ABSTRACT] EventLoop*;

    (**
      See @oproc{Window.EventLoop}.
    *)

  END EventLoop;

  PROCEDURE (w : WindowImpl) [ABSTRACT] GetMousePos*(VAR rx, ry, wx, wy : LONGINT);
  (**
    See @oproc{Window.GetMousePos}.
  *)
  END GetMousePos;

  PROCEDURE (w : WindowImpl) Enable*;

    (**
      Opposite of @oproc{WindowImpl.Disable}.
    *)

  BEGIN
    DEC(w.modalCount);
  END Enable;

  PROCEDURE (w : WindowImpl) Disable*;

    (**
      Disables the window. Disallows input and make uses of some visual feedback
      (like a special mouse pointer).

      Disabling and enabling are additive, that means, if oyu call Disable
      twice you must call @oproc{WindowImpl.Enable} twice, too.
    *)

  BEGIN
    INC(w.modalCount);
  END Disable;

  PROCEDURE (w : WindowImpl) EnableParents*;

  VAR
   window : WindowImpl;

  BEGIN
    window:=w.parent;
    WHILE window#NIL DO
      window.Enable;
      window:=window.parent;
    END;
  END EnableParents;

  PROCEDURE (w : WindowImpl) DisableParents*;

  VAR
   window : WindowImpl;

  BEGIN
    window:=w.parent;
    WHILE window#NIL DO
      window.Disable;
      window:=window.parent;
    END;
  END DisableParents;

  PROCEDURE (w : WindowImpl) [ABSTRACT] IsDoubleClicked*():BOOLEAN;
  END IsDoubleClicked;

  PROCEDURE (w : WindowImpl) [ABSTRACT] IsTrippleClicked*():BOOLEAN;
  END IsTrippleClicked;

  PROCEDURE (w : Window) Init*;

  BEGIN
    w.Init^;

    w.impl:=factory.CreateWindowImpl();
    w.impl.interface:=w;

    w.maped:=FALSE;
    w.opened:=FALSE;
    w.focus:=FALSE;
  END Init;

  PROCEDURE (w : Window) GetDrawInfo*():DrawInfo;

  BEGIN
    RETURN w.impl.GetDrawInfo();
  END GetDrawInfo;

  PROCEDURE (w : Window) SetParent*(parent : Window);
  (**
    Sets the parent window of the current window. VisualOberon will try to
    make use of the supplied information about the hierachical structure of
    the window tree.

    NOTE
    Parent will only be evaluated before first opening.

  *)

  BEGIN
    w.impl.SetParent(parent);
  END SetParent;

  PROCEDURE (w : Window) GetParent*():Window;

  BEGIN
    RETURN w.impl.GetParent();
  END GetParent;

  PROCEDURE (w : Window) SetType*(type : LONGINT);

    (**
      Sets the type of the window.

      NOTE
      You cannot change the type of the window, once it has been opened!
    *)

  BEGIN
    w.impl.type:=type;
  END SetType;

  PROCEDURE (w : Window) SetPos*(x,y : LONGINT);
  (**
    Sets the top left of the window.

    NOTE
    Does only work, if the windows is not open. If the window  is open,
    use Window.Resize instead.
  *)

  BEGIN
    w.impl.SetPos(x,y);
  END SetPos;

  PROCEDURE (w : Window) SetPosition*(horiz, vert : LONGINT);
  (**
    Set the position modes for vertical and horizotal positioning of the window
    on the display. If no modes are explicitly set, the x,y position of the
    window will be used. This position is the position set with SetPos
    or defaults to zero. In this case the windowmanager might position the
    window (it might, too, if you set a mode, since a windowmanager may ignore
    these values).
  *)

  BEGIN
    w.impl.SetPosition(horiz,vert);
  END SetPosition;

  PROCEDURE (w : Window) SetSize*(width,height : LONGINT);
  (**
    Sets the width and height of the window.

    NOTE
    Does only work, if the windows is not open. If the window  is open,
    use Window.Resize instead.
  *)

  BEGIN
    w.impl.SetSize(width,height);
  END SetSize;

  PROCEDURE (w : Window) GetX*():LONGINT;

  BEGIN
    RETURN w.impl.x;
  END GetX;

  PROCEDURE (w : Window) GetY*():LONGINT;

  BEGIN
    RETURN w.impl.y;
  END GetY;

  PROCEDURE (w : Window) GetWidth*():LONGINT;

  BEGIN
    RETURN w.impl.width;
  END GetWidth;

  PROCEDURE (w : Window) GetHeight*():LONGINT;

  BEGIN
    RETURN w.impl.height;
  END GetHeight;

  PROCEDURE (w : Window) IsDoubleClicked*():BOOLEAN;

  BEGIN
    RETURN w.impl.IsDoubleClicked();
  END IsDoubleClicked;

  PROCEDURE (w : Window) IsTrippleClicked*():BOOLEAN;

  BEGIN
    RETURN w.impl.IsTrippleClicked();
  END IsTrippleClicked;

  PROCEDURE (w : Window) SetMinSize*(width,height : LONGINT);
  (**
    Sets the minimal width and height of the window.

    NOTE
    Does only work, if the windows is not open. If the window  is open,
    use Window.Resize instead.
  *)

  BEGIN
    w.impl.SetMinSize(width,height);
  END SetMinSize;

  PROCEDURE (w : Window) SetMaxSize*(width,height : LONGINT);
  (**
    Sets the maximal width and height of the window.

    NOTE
    Does only work, if the windows is not open. If the window  is open,
    use Window.Resize instead.
  *)

  BEGIN
    w.impl.SetMaxSize(width,height);
  END SetMaxSize;

  PROCEDURE (w : Window) SetTitle*(name : STRING);

    (**
      Sets the title of the window.
    *)

  BEGIN
    w.impl.SetTitle(name);
  END SetTitle;

  PROCEDURE (w : Window) FocusNext*;

    (**
      This one gets called, when the display thinks the window should
      change the KeyboardFocus.
    *)

  BEGIN
  END FocusNext;

  PROCEDURE (w : Window) GetMousePos*(VAR rx, ry, wx, wy : LONGINT);
    (**
      Returns the mouse position in window relative and abslute coords.
    *)
  BEGIN
    w.impl.GetMousePos(rx,ry,wx,wy);
  END GetMousePos;

  PROCEDURE (w : Window) CursorIsIn*():BOOLEAN;

    (**
      returns @code{TRUE}, if the mouse cursor ins withinthe window, else
      @code{FALSE}.
    *)

  VAR
    rx,ry,
    wx,wy  : LONGINT;

  BEGIN
    w.GetMousePos(rx,ry,wx,wy);

    RETURN (wx>=0) & (wx<w.GetWidth()) & (wy>=0) & (wy<w.GetHeight());
  END CursorIsIn;

  PROCEDURE (w : Window) Grab*(grab : BOOLEAN);
  (**
    Do mouse and keyboard-grabing.

    NOTE
    Changing the value does only work, when the window is not visible.
  *)
  BEGIN
    w.impl.Grab(grab);
  END Grab;

  PROCEDURE (w : Window) PreInit*;
  (**
    This method will be called on every call to Open().

    This allows delayed creation of the object-hierachie within the window.

    NOTE
    You must call the method of the baseclass if you overload this method.
  *)

  BEGIN
  END PreInit;

  PROCEDURE (w : Window) Open*():BOOLEAN;
  (**
    Opens the window.

    NOTE
    Derived classes must call th e baseclass method.
  *)

  BEGIN
    w.PreInit;

    w.opened:=FALSE;
    w.maped:=FALSE;

    RETURN w.impl.Open();
  END Open;

  PROCEDURE (w : Window) Close*;
  (**
    Closes the window.

    NOTE
    You must call this method before closing the window.
  *)

  BEGIN
    w.impl.Close;
  END Close;

  PROCEDURE (w : Window) IsOpen*():BOOLEAN;

  BEGIN
    RETURN w.impl.IsOpen();
  END IsOpen;

  PROCEDURE (w : Window) IsMaped*():BOOLEAN;

    (**
      Returns TRUE, when the window is maped, else FALSE.
    *)

  BEGIN
    RETURN w.maped;
  END IsMaped;

  PROCEDURE (w : Window) IsInEventLoop*():BOOLEAN;

  BEGIN
    RETURN w.impl.IsInEventLoop();
  END IsInEventLoop;

  PROCEDURE (w : Window) Exit*;
  (**
    This sets the exit flag to true. The handler-method will be left after
    this flag has been set.
  *)

  BEGIN
    w.impl.Exit;
  END Exit;

  PROCEDURE (w : Window)HandleEvent*(event : E.Event):BOOLEAN;
  (**
    If you derive yourself from window and want to overload the
    defaulthandler, call the baseclass first in your handler and check the
    result, if its is TRUE the defaulthandler has allready handled it.
  *)

  BEGIN
    RETURN FALSE;
  END HandleEvent;

  PROCEDURE (w : Window) EventLoop*;
  (**
    This implements a local event loop for a modal window. The method will
    return, when the window has been closed.
  *)
  BEGIN
    w.impl.EventLoop;
  END EventLoop;

  PROCEDURE (w : Window) Resize*(width,height : LONGINT);
  (**
    Resize the window to the given size. Be carefull to not resize the window
    below the minimal bounds of the top object. Best is to leave resize handling
    completely to the derived window class.

    NOTE
    Derived class should size against minimal and maximal size of its top object.
  *)

  BEGIN
    w.impl.Resize(width,height);
  END Resize;

  PROCEDURE (w : Window) Enable*;

    (**
      Opposite of @oproc{WindowImpl.Disable}.
    *)

  BEGIN
    w.impl.Enable;
  END Enable;

  PROCEDURE (w : Window) Disable*;

    (**
      Disables the window. Disallows input and make uses of some visual feedback
      (like a special mouse pointer).

      Disabling and enabling are additive, that means, if oyu call Disable
      twice you must call @oproc{WindowImpl.Enable} twice, too.
    *)

  BEGIN
    w.impl.Disable;
  END Disable;

  PROCEDURE (w : Window) OnClosePressed*;
  (**
    Called when the the closing gadget of the window got pressed.
  *)

  BEGIN
  END OnClosePressed;

  PROCEDURE (w : Window) OnMaped*;
  (**
    Called, when window has been maped.

    Call baseclass method, when you inherit.
  *)

  BEGIN
    w.maped:=TRUE;
    w.opened:=FALSE;
  END OnMaped;

  PROCEDURE (w : Window) OnUnmaped*;
  (**
    Called, when window has been unmaped.

    Call baseclass method, when you inherit.
  *)

  BEGIN
    w.maped:=FALSE;
  END OnUnmaped;

  PROCEDURE (w : Window) OnOpened*;

    (**
      This method is called, when the the window is open (@oproc{Window.OnMaped}
      was called) and the content was drawn (@oproc{Window.OnRedraw} was
      called).

      Call baseclass method, when you inherit.
    *)

  BEGIN
  END OnOpened;

  PROCEDURE (w : Window) ReinitWindow*;
  (**
    Called, when the display want the window to reinit itself, f.e
    when the preferences of some or all of the objects has been changed.

    Call baseclass method, when you inherit.
  *)
  BEGIN
  END ReinitWindow;

  PROCEDURE (w : Window) OnHidden*;
  (**
    This method get calls, when the window becomes (partial) hidden, e.g.
    gets covered by another window. This is likely to not be supported for all
    platforms.

    Call baseclass method, when you inherit.
  *)

  BEGIN
  END OnHidden;

  PROCEDURE (w : Window) OnFocusIn*;
  (**
    Called, when the window gets the keyboard focus.

    Call baseclass method, when you inherit.
  *)

  BEGIN
    w.focus:=TRUE;
  END OnFocusIn;

  PROCEDURE (w : Window) OnFocusOut*;
  (**
    Called, when the window looses the keyboard focus.

    Call baseclass method, when you inherit.
  *)

  BEGIN
    w.focus:=FALSE;
  END OnFocusOut;

  PROCEDURE (w : Window) OnMouseEntered*;
  (**
    Gets called, when the mouse (not the focus!) has entered the window.

    Call baseclass method, when you inherit.
  *)

  BEGIN
  END OnMouseEntered;

  PROCEDURE (w : Window) OnMouseLeft*;
  (**
    Gets called, when the mouse (not the focus!) has left the window.

    Call baseclass method, when you inherit.
  *)

  BEGIN
  END OnMouseLeft;

  PROCEDURE (w : Window) OnRedraw*(x,y,width,height : LONGINT);
  (**
    Will be called, if you have to redraw yourself.
    Overload it as aproximate. The window can restrict the redrawing to the given
    area.
  *)
  BEGIN
    IF w.maped & ~w.opened THEN
      w.opened:=TRUE;
      w.OnOpened;
    END;
  END OnRedraw;

  PROCEDURE (w : Window) OnResized*(width,height : LONGINT);
  (**
    This method gets called, when the window has been resized.
    The given size is the size of the window-inner, that means,
    the size of the window without its borders.

    Note, that window#decorationwindow!
  *)

  BEGIN
  END OnResized;

  PROCEDURE (w : Window) OnContextHelp*;
  (**
    This method gets called, when the display thinks you should
    open a tooltip help.
  *)

  BEGIN
  END OnContextHelp;

  PROCEDURE (w : Window) GetDnDObject*(x,y : LONGINT; drag : BOOLEAN):Object;
  (**
    Returns the object that coveres the given point and that supports
    dragging of data.

    If drag is TRUE, when want to find a object that we can drag data from,
    else we want an object to drop data on.

    NOTE
    A window can be sure to be called only, if dragging or dropping makes sense.
    For example, you cannot drop data onto a window that is block due to its
    modal count. However, you can always drag data from a window.
  *)

  BEGIN
    RETURN NIL;
  END GetDnDObject;

  PROCEDURE (h : Msg2Exit) Convert*(message : O.Message):O.Message;
  (**
    Converts any incomming message to a ExitMsg.
  *)

  VAR
    new : ExitMsg;

  BEGIN
    NEW(new);
    RETURN new;
  END Convert;

  PROCEDURE GetColorByIndex*(index : LONGINT):LONGINT;

  BEGIN
    CASE index OF
      backgroundColorIndex:
      RETURN backgroundColor;
    | tableBackgroundColorIndex:
      RETURN tableBackgroundColor;
    | tableBackground2ColorIndex:
      RETURN tableBackground2Color;
    | tableTextColorIndex:
      RETURN tableTextColor;
    | textBackgroundColorIndex:
      RETURN textBackgroundColor;
    | buttonBackgroundColorIndex:
      RETURN buttonBackgroundColor;
    | textColorIndex:
      RETURN textColor;
    | shineColorIndex:
      RETURN shineColor;
    | halfShineColorIndex:
      RETURN halfShineColor;
    | halfShadowColorIndex:
      RETURN halfShadowColor;
    | shadowColorIndex:
      RETURN shadowColor;
    | fillColorIndex:
      RETURN fillColor;
    | fillTextColorIndex:
      RETURN fillTextColor;
    | warnColorIndex:
      RETURN warnColor;
    | disabledColorIndex:
      RETURN disabledColor;
    | focusColorIndex:
      RETURN focusColor;
    | blackColorIndex:
      RETURN blackColor;
    | whiteColorIndex:
      RETURN whiteColor;
    | helpBackgroundColorIndex:
      RETURN helpBackgroundColor;
    END;
  END GetColorByIndex;

  PROCEDURE GetColorIndexByName*(name : ARRAY OF CHAR):LONGINT;

  VAR
    x,pos : LONGINT;

  BEGIN
    x:=0;
    pos:=-1;
    WHILE (x<=colorCount-1) & (pos=-1) DO
      IF name=colorNames[x] THEN
        pos:=x;
      END;

      INC(x);
    END;

    RETURN pos;
  END GetColorIndexByName;

  PROCEDURE GetColorByName*(name : ARRAY OF CHAR):LONGINT;

  VAR
    pos : LONGINT;

  BEGIN
    pos:=GetColorIndexByName(name);

    IF pos>=0 THEN
      RETURN GetColorByIndex(pos);
    ELSE
      RETURN GetColorByIndex(0);
    END;
  END GetColorByName;

  PROCEDURE GetRGB32ByColorName*(name : ARRAY OF CHAR;
                                 VAR r,g,b : LONGINT):BOOLEAN;

  VAR
    color   : ARRAY 16 OF CHAR;
    intense : LONGINT;
    length,
    x       : LONGINT;

    PROCEDURE GetHex(char : CHAR):LONGINT;

    BEGIN
      IF (char>="0") & (char<="9") THEN
        RETURN ORD(char)-ORD("0");
      ELSE
        RETURN ORD(char)-ORD("A")+10;
      END;
    END GetHex;

  BEGIN
    (* Make it all capital *)
    length:=0;
    WHILE (length<LEN(name)) & (name[length]#0X) DO
      name[length]:=CAP(name[length]);
      INC(length);
    END;

    x:=0;
    WHILE (x<LEN(name)) & (name[x]>="A") & (name[x]<="Z") DO
      color[x]:=name[x];
      INC(x);
    END;
    color[x]:=0X;

    intense:=100;

    IF name[0]="#" THEN
      IF length=7 THEN
        FOR x:=1 TO 6 DO
          IF ~(((name[x]>="0") & (name[x]<="9")) OR ((name[x]>="A") & (name[x]<="F"))) THEN
            RETURN FALSE;
          END;
        END;

        r:=GetHex(name[1])*16+GetHex(name[2]);
        g:=GetHex(name[3])*16+GetHex(name[4]);
        b:=GetHex(name[5])*16+GetHex(name[6]);
      ELSE
        RETURN FALSE;
      END;
    ELSE
      IF (x<LEN(name)) & (name[x]>="0") & (name[x]<="9") THEN
        intense:=0;
        WHILE (x<LEN(name)) & (name[x]>="0") & (name[x]<="9") DO
          intense:=intense*10+ORD(name[x])-ORD("0");
        INC(x);
        END;
      END;

      IF color="RED" THEN
        r:=0FFH;
        g:=0;
        b:=0;
      ELSIF color="GREEN" THEN
        r:=0;
        g:=0FFH;
        b:=0;
      ELSIF color="BLUE" THEN
        r:=0;
        g:=0;
        b:=0FFH;
      ELSIF color="YELLOW" THEN
        r:=0FFH;
        g:=0FFH;
        b:=0;
      ELSIF color="MAGENTA" THEN
        r:=0FFH;
        g:=0;
        b:=0FFH;
      ELSIF color="CYAN" THEN
        r:=0;
        g:=0FFH;
        b:=0FFH;
      ELSIF color="BLACK" THEN
        r:=0;
        g:=0;
        b:=0;
      ELSIF color="WHITE" THEN
        r:=0FFH;
        g:=0FFH;
        b:=0FFH;
      ELSIF (color="GREY") OR (color="GRAY") THEN
        r:=0FFH;
        g:=0FFH;
        b:=0FFH;
      ELSE
        RETURN FALSE;
      END;
    END;

    (* Scale *)
    r:=(r*intense) DIV 100;
    g:=(g*intense) DIV 100;
    b:=(b*intense) DIV 100;

    (* Expand to 32 bit *)
    r:=r*256*256*256;
    g:=g*256*256*256;
    b:=b*256*256*256;

    RETURN TRUE;
  END GetRGB32ByColorName;

  PROCEDURE SetFactory*(f : Factory);

  BEGIN
    factory:=f;
    display:=factory.CreateDisplay();
    display.Init;
  END SetFactory;

  PROCEDURE CheckByteOrder;

  VAR
    i : INTEGER;

    PROCEDURE DoCheck(VAR x : ARRAY OF SYSTEM.BYTE);

    BEGIN
      IF SYSTEM.VAL(CHAR,x[0])=1X THEN
        systemByteOrder:=littleEndian;
      ELSE
        systemByteOrder:=bigEndian;
      END;
    END DoCheck;

  BEGIN
    i:=1;
    DoCheck(i);
  END CheckByteOrder;

BEGIN
  CheckByteOrder;

  home:=ProcessParameters.GetEnv("HOME");

  factory:=NIL;

  disablePattern[0]:=CHR(170);  (* 10101010 *)
  disablePattern[1]:=CHR(85);   (* 01010101 *)

  bigChessPattern[0]:=CHR(204); (* 11001100 *)
  bigChessPattern[1]:=CHR(204); (* 11001100 *)
  bigChessPattern[2]:=CHR(204); (* 11001100 *)
  bigChessPattern[3]:=CHR(204); (* 11001100 *)
  bigChessPattern[4]:=CHR(51);  (* 00110011 *)
  bigChessPattern[5]:=CHR(51);  (* 00110011 *)
  bigChessPattern[6]:=CHR(51);  (* 00110011 *)
  bigChessPattern[7]:=CHR(51);  (* 00110011 *)

  sPointLine[0]:=CHR(1);
  sPointLine[1]:=CHR(1);

  mPointLine[0]:=CHR(2);
  mPointLine[1]:=CHR(2);

  lPointLine[0]:=CHR(3);
  lPointLine[1]:=CHR(3);

  backgroundColor       := MIN(Color);
  tableBackgroundColor  := MIN(Color);
  tableBackground2Color := MIN(Color);
  tableTextColor        := MIN(Color);
  textBackgroundColor   := MIN(Color);
  buttonBackgroundColor := MIN(Color);
  textColor             := MIN(Color);
  shineColor            := MIN(Color);
  halfShineColor        := MIN(Color);
  halfShadowColor       := MIN(Color);
  shadowColor           := MIN(Color);
  fillColor             := MIN(Color);
  fillTextColor         := MIN(Color);
  warnColor             := MIN(Color);
  disabledColor         := MIN(Color);
  focusColor            := MIN(Color);
  blackColor            := MIN(Color);
  whiteColor            := MIN(Color);
  helpBackgroundColor   := MIN(Color);

  (* we should assign the constants, but since it is only a temporary solution... *)

  tinyFont:=NIL;
  scriptFont:=NIL;
  footnoteFont:=NIL;
  smallFont:=NIL;
  normalFont:=NIL;
  largeFont:=NIL;
  LargeFont:=NIL;
  LARGEFont:=NIL;
  hugeFont:=NIL;
  HUGEFont:=NIL;

  smallFixedFont:=NIL;
  fixedFont:=NIL;
  hugeFixedFont:=NIL;

  colorNames[backgroundColorIndex]      :="background";
  colorNames[tableBackgroundColorIndex] :="tableBackground";
  colorNames[tableBackground2ColorIndex]:="tableBackground2";
  colorNames[tableTextColorIndex]       :="tableText";
  colorNames[textBackgroundColorIndex]  :="textBackground";
  colorNames[buttonBackgroundColorIndex]:="buttonBackground";
  colorNames[textColorIndex]            :="text";
  colorNames[shineColorIndex]           :="shine";
  colorNames[shadowColorIndex]          :="shadow";
  colorNames[fillColorIndex]            :="fill";
  colorNames[fillTextColorIndex]        :="fillText";
  colorNames[halfShineColorIndex]       :="halfShine";
  colorNames[halfShadowColorIndex]      :="halfShadow";
  colorNames[warnColorIndex]            :="warn";
  colorNames[disabledColorIndex]        :="disabled";
  colorNames[focusColorIndex]           :="focus";
  colorNames[blackColorIndex]           :="black";
  colorNames[whiteColorIndex]           :="white";
  colorNames[helpBackgroundColorIndex]  :="helpBackground";

  fontNames[tinyFontIndex]      :="tiny";
  fontNames[scriptFontIndex]    :="script";
  fontNames[footnoteFontIndex]  :="footnote";
  fontNames[smallFontIndex]     :="small";
  fontNames[normalFontIndex]    :="normal";
  fontNames[largeFontIndex]     :="large";
  fontNames[LargeFontIndex]     :="Large";
  fontNames[LARGEFontIndex]     :="LARGE";
  fontNames[hugeFontIndex]      :="huge";
  fontNames[HUGEFontIndex]      :="HUGE";
  fontNames[smallFixedFontIndex]:="smallFixed";
  fontNames[fixedFontIndex]     :="fixed";
  fontNames[hugeFixedFontIndex] :="hugeFixed";

  prefsCallback:=NIL;
END VO:Base:Display.
