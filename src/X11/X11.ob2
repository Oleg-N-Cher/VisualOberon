MODULE [foreign] X11;

(* OMAKE LINK "X11" *)

IMPORT
  SYSTEM;

TYPE
  C_longint* = SYSTEM.INT64;
  C_int* = SYSTEM.INT32;
  C_shortint* = SYSTEM.INT16;
  C_char* = SYSTEM.CHAR8;
  C_longchar* = SYSTEM.CHAR16;
  C_address* = SYSTEM.ADRINT;

  C_longset* = C_longint;
  C_set* = C_int;
  C_enum1* = C_int;

  C_intPtr1d* = POINTER TO ARRAY [untagged] OF C_int;
  C_string* = POINTER TO ARRAY [untagged] OF C_char;
  C_longstring* = POINTER TO ARRAY [untagged] OF C_longchar;

  C_charPtr1d* = POINTER TO ARRAY [untagged] OF C_char;
  C_charPtr2d* = POINTER TO ARRAY [untagged] OF C_charPtr1d;

TYPE
  ulongmask* = C_longset;
  uintmask* = C_set;

(* ### include file X.h, conversion of the file
       $XConsortium: X.h,v 1.69 94/04/17 20:10:48 dpw Exp $  *)

CONST
  X_PROTOCOL* = 11;             (* current protocol version *)
  X_PROTOCOL_REVISION* = 0;     (* current minor version *)

(* Resources *)
TYPE
  XID* = C_longint;
  Mask* = C_longint;
  Atom* = C_longint;
  AtomPtr1d* = POINTER TO ARRAY [untagged] OF Atom;
  VisualID* = C_longint;
  Time* = C_longint;

  Window* = XID;
  WindowPtr1d* = POINTER TO ARRAY [untagged] OF Window;
  Drawable* = XID;
  Font* = XID;
  Pixmap* = XID;
  Cursor* = XID;
  Colormap* = XID;
  ColormapPtr1d* = POINTER TO ARRAY [untagged] OF Colormap;
  GContext* = XID;
  KeySym* = XID;
  KeySymPtr1d* = POINTER TO ARRAY [untagged] OF KeySym;

  KeyCode* = C_char;
  KeyCodePtr1d* = POINTER TO ARRAY [untagged] OF KeyCode;

(*****************************************************************
 * RESERVED RESOURCE AND CONSTANT DEFINITIONS
 *****************************************************************)
CONST
  None* = 0;                    (* universal null resource or null atom *)
  ParentRelative* = 1;          (* background pixmap in CreateWindow
				    and ChangeWindowAttributes *)
  CopyFromParent* = 0;          (* border pixmap in CreateWindow
				       and ChangeWindowAttributes
				   special VisualID and special window
				       class passed to CreateWindow *)
  PointerWindow* = 0;           (* destination window in SendEvent *)
  InputFocus* = 1;              (* destination window in SendEvent *)
  PointerRoot* = 1;             (* focus window in SetInputFocus *)
  AnyPropertyType* = 0;         (* special Atom, passed to GetProperty *)
  AnyKey* = 0;                  (* special Key Code, passed to GrabKey *)
  AnyButton* = 0;               (* special Button Code, passed to GrabButton *)
  AllTemporary* = 0;            (* special Resource ID passed to KillClient *)
  CurrentTime* = 0;             (* special Time *)
  NoSymbol* = 0;                (* special KeySym *)

(*****************************************************************
 * EVENT DEFINITIONS
 *****************************************************************)
(* Input Event Masks. Used as event-mask window attribute and as arguments
   to Grab requests.  Not to be confused with event names.  *)
CONST
(*  NoEventMask* = {};
  KeyPressMask* = {0};
  KeyReleaseMask* = {1};
  ButtonPressMask* = {2};
  ButtonReleaseMask* = {3};
  EnterWindowMask* = {4};
  LeaveWindowMask* = {5};
  PointerMotionMask* = {6};
  PointerMotionHintMask* = {7};
  Button1MotionMask* = {8};
  Button2MotionMask* = {9};
  Button3MotionMask* = {10};
  Button4MotionMask* = {11};
  Button5MotionMask* = {12};
  ButtonMotionMask* = {13};
  KeymapStateMask* = {14};
  ExposureMask* = {15};
  VisibilityChangeMask* = {16};
  StructureNotifyMask* = {17};
  ResizeRedirectMask* = {18};
  SubstructureNotifyMask* = {19};
  SubstructureRedirectMask* = {20};
  FocusChangeMask* = {21};
  PropertyChangeMask* = {22};
  ColormapChangeMask* = {23};
  OwnerGrabButtonMask* = {24}; *)

  NoEventMask* = 0;
  KeyPressMask* = 1;
  KeyReleaseMask* = 2;
  ButtonPressMask* = 4;
  ButtonReleaseMask* = 8;
  EnterWindowMask* = 16;
  LeaveWindowMask* = 32;
  PointerMotionMask* = 64;
  PointerMotionHintMask* = 128;
  Button1MotionMask* = 256;
  Button2MotionMask* = 512;
  Button3MotionMask* = 1024;
  Button4MotionMask* = 2048;
  Button5MotionMask* = 4096;
  ButtonMotionMask* = 8192;
  KeymapStateMask* = 16384;
  ExposureMask* = 32768;
  VisibilityChangeMask* = 65536;
  StructureNotifyMask* = 131072;
  ResizeRedirectMask* = 262144;
  SubstructureNotifyMask* = 524288;
  SubstructureRedirectMask* = 1048576;
  FocusChangeMask* = 2097152;
  PropertyChangeMask* = 4194304;
  ColormapChangeMask* = 8388608;
  OwnerGrabButtonMask* = 16777216;


(* Event names.  Used in "type" field in XEvent structures.  Not to be
confused with event masks above.  They start from 2 because 0 and 1
are reserved in the protocol for errors and replies. *)
CONST
  KeyPress* = 2;
  KeyRelease* = 3;
  ButtonPress* = 4;
  ButtonRelease* = 5;
  MotionNotify* = 6;
  EnterNotify* = 7;
  LeaveNotify* = 8;
  FocusIn* = 9;
  FocusOut* = 10;
  KeymapNotify* = 11;
  Expose* = 12;
  GraphicsExpose* = 13;
  NoExpose* = 14;
  VisibilityNotify* = 15;
  CreateNotify* = 16;
  DestroyNotify* = 17;
  UnmapNotify* = 18;
  MapNotify* = 19;
  MapRequest* = 20;
  ReparentNotify* = 21;
  ConfigureNotify* = 22;
  ConfigureRequest* = 23;
  GravityNotify* = 24;
  ResizeRequest* = 25;
  CirculateNotify* = 26;
  CirculateRequest* = 27;
  PropertyNotify* = 28;
  SelectionClear* = 29;
  SelectionRequest* = 30;
  SelectionNotify* = 31;
  ColormapNotify* = 32;
  ClientMessage* = 33;
  MappingNotify* = 34;
  LASTEvent* = 35;              (* must be bigger than any event # *)

(* Key masks. Used as modifiers to GrabButton and GrabKey, results of
   QueryPointer, state in various key-, mouse-, and button-related events. *)
CONST
  ShiftMask* = {0};
  LockMask* = {1};
  ControlMask* = {2};
  Mod1Mask* = {3};
  Mod2Mask* = {4};
  Mod3Mask* = {5};
  Mod4Mask* = {6};
  Mod5Mask* = {7};

(* modifier names.  Used to build a SetModifierMapping request or
   to read a GetModifierMapping request.  These correspond to the
   masks defined above. *)
CONST
  ShiftMapIndex* = 0;
  LockMapIndex* = 1;
  ControlMapIndex* = 2;
  Mod1MapIndex* = 3;
  Mod2MapIndex* = 4;
  Mod3MapIndex* = 5;
  Mod4MapIndex* = 6;
  Mod5MapIndex* = 7;

(* button masks.  Used in same manner as Key masks above. Not to be confused
   with button names below. *)
CONST
  Button1Mask* = {8};
  Button2Mask* = {9};
  Button3Mask* = {10};
  Button4Mask* = {11};
  Button5Mask* = {12};
  AnyModifier* = {15};          (* used in GrabButton, GrabKey *)

(* button names. Used as arguments to GrabButton and as detail in ButtonPress
   and ButtonRelease events.  Not to be confused with button masks above.
   Note that 0 is already defined above as "AnyButton".  *)
CONST
  Button1* = 1;
  Button2* = 2;
  Button3* = 3;
  Button4* = 4;
  Button5* = 5;

(* Notify modes *)
CONST
  NotifyNormal* = 0;
  NotifyGrab* = 1;
  NotifyUngrab* = 2;
  NotifyWhileGrabbed* = 3;
  NotifyHint* = 1;              (* for MotionNotify events *)

(* Notify detail *)
CONST
  NotifyAncestor* = 0;
  NotifyVirtual* = 1;
  NotifyInferior* = 2;
  NotifyNonlinear* = 3;
  NotifyNonlinearVirtual* = 4;
  NotifyPointer* = 5;
  NotifyPointerRoot* = 6;
  NotifyDetailNone* = 7;

(* Visibility notify *)
CONST
  VisibilityUnobscured* = 0;
  VisibilityPartiallyObscured* = 1;
  VisibilityFullyObscured* = 2;

(* Circulation request *)
CONST
  PlaceOnTop* = 0;
  PlaceOnBottom* = 1;

(* protocol families *)
CONST
  FamilyInternet* = 0;
  FamilyDECnet* = 1;
  FamilyChaos* = 2;

(* Property notification *)
CONST
  PropertyNewValue* = 0;
  PropertyDelete* = 1;

(* Color Map notification *)
CONST
  ColormapUninstalled* = 0;
  ColormapInstalled* = 1;

(* GrabPointer, GrabButton, GrabKeyboard, GrabKey Modes *)
CONST
  GrabModeSync* = 0;
  GrabModeAsync* = 1;

(* GrabPointer, GrabKeyboard reply status *)
CONST
  GrabSuccess* = 0;
  AlreadyGrabbed* = 1;
  GrabInvalidTime* = 2;
  GrabNotViewable* = 3;
  GrabFrozen* = 4;

(* AllowEvents modes *)
CONST
  AsyncPointer* = 0;
  SyncPointer* = 1;
  ReplayPointer* = 2;
  AsyncKeyboard* = 3;
  SyncKeyboard* = 4;
  ReplayKeyboard* = 5;
  AsyncBoth* = 6;
  SyncBoth* = 7;

(* Used in SetInputFocus, GetInputFocus *)
CONST
  RevertToNone* = None;
  RevertToPointerRoot* = PointerRoot;
  RevertToParent* = 2;


(*****************************************************************
 * ERROR CODES
 *****************************************************************)
CONST
  Success* = 0;                 (* everything's okay *)
  BadRequest* = 1;              (* bad request code *)
  BadValue* = 2;                (* int parameter out of range *)
  BadWindow* = 3;               (* parameter not a Window *)
  BadPixmap* = 4;               (* parameter not a Pixmap *)
  BadAtom* = 5;                 (* parameter not an Atom *)
  BadCursor* = 6;               (* parameter not a Cursor *)
  BadFont* = 7;                 (* parameter not a Font *)
  BadMatch* = 8;                (* parameter mismatch *)
  BadDrawable* = 9;             (* parameter not a Pixmap or Window *)
  BadAccess* = 10;              (* depending on context:
				 - key/button already grabbed
				 - attempt to free an illegal
				   cmap entry
				- attempt to store into a read-only
				   color map entry.
 				- attempt to modify the access control
				   list from other than the local host.
				*)
  BadAlloc* = 11;               (* insufficient resources *)
  BadColor* = 12;               (* no such colormap *)
  BadGC* = 13;                  (* parameter not a GC *)
  BadIDChoice* = 14;            (* choice not in range or already used *)
  BadName* = 15;                (* font or color name doesn't exist *)
  BadLength* = 16;              (* Request length incorrect *)
  BadImplementation* = 17;      (* server is defective *)
  FirstExtensionError* = 128;
  LastExtensionError* = 255;


(*****************************************************************
 * WINDOW DEFINITIONS
 *****************************************************************)
(* Window classes used by CreateWindow *)
(* Note that CopyFromParent is already defined as 0 above *)
CONST
  InputOutput* = 1;
  InputOnly* = 2;

(* Window attributes for CreateWindow and ChangeWindowAttributes *)
CONST
  CWBackPixmap* = {0};
  CWBackPixel* = {1};
  CWBorderPixmap* = {2};
  CWBorderPixel* = {3};
  CWBitGravity* = {4};
  CWWinGravity* = {5};
  CWBackingStore* = {6};
  CWBackingPlanes* = {7};
  CWBackingPixel* = {8};
  CWOverrideRedirect* = {9};
  CWSaveUnder* = {10};
  CWEventMask* = {11};
  CWDontPropagate* = {12};
  CWColormap* = {13};
  CWCursor* = {14};

(* ConfigureWindow structure *)
CONST
  CWX* = {0};
  CWY* = {1};
  CWWidth* = {2};
  CWHeight* = {3};
  CWBorderWidth* = {4};
  CWSibling* = {5};
  CWStackMode* = {6};

(* Bit Gravity *)
CONST
  ForgetGravity* = 0;
  NorthWestGravity* = 1;
  NorthGravity* = 2;
  NorthEastGravity* = 3;
  WestGravity* = 4;
  CenterGravity* = 5;
  EastGravity* = 6;
  SouthWestGravity* = 7;
  SouthGravity* = 8;
  SouthEastGravity* = 9;
  StaticGravity* = 10;
  (* Window gravity + bit gravity above *)
  UnmapGravity* = 0;

(* Used in CreateWindow for backing-store hint *)
CONST
  NotUseful* = 0;
  WhenMapped* = 1;
  Always* = 2;

(* Used in GetWindowAttributes reply *)
CONST
  IsUnmapped* = 0;
  IsUnviewable* = 1;
  IsViewable* = 2;

(* Used in ChangeSaveSet *)
CONST
  SetModeInsert* = 0;
  SetModeDelete* = 1;

(* Used in ChangeCloseDownMode *)
CONST
  DestroyAll* = 0;
  RetainPermanent* = 1;
  RetainTemporary* = 2;

(* Window stacking method (in configureWindow) *)
CONST
  Above* = 0;
  Below* = 1;
  TopIf* = 2;
  BottomIf* = 3;
  Opposite* = 4;

(* Circulation direction *)
CONST
  RaiseLowest* = 0;
  LowerHighest* = 1;

(* Property modes *)
CONST
  PropModeReplace* = 0;
  PropModePrepend* = 1;
  PropModeAppend* = 2;


(*****************************************************************
 * GRAPHICS DEFINITIONS
 *****************************************************************)

(* graphics functions, as in GC_alu *)
CONST
  GXclear* = 00H;               (* 0 *)
  GXand* = 01H;                 (* src AND dst *)
  GXandReverse* = 02H;          (* src AND NOT dst *)
  GXcopy* = 03H;                (* src *)
  GXandInverted* = 04H;         (* NOT src AND dst *)
  GXnoop* = 05H;                (* dst *)
  GXxor* = 06H;                 (* src XOR dst *)
  GXor* = 07H;                  (* src OR dst *)
  GXnor* = 08H;                 (* NOT src AND NOT dst *)
  GXequiv* = 09H;               (* NOT src XOR dst *)
  GXinvert* = 0AH;              (* NOT dst *)
  GXorReverse* = 0BH;           (* src OR NOT dst *)
  GXcopyInverted* = 0CH;        (* NOT src *)
  GXorInverted* = 0DH;          (* NOT src OR dst *)
  GXnand* = 0EH;                (* NOT src OR NOT dst *)
  GXset* = 0FH;                 (* 1 *)

(* LineStyle *)
CONST
  LineSolid* = 0;
  LineOnOffDash* = 1;
  LineDoubleDash* = 2;

(* capStyle *)
CONST
  CapNotLast* = 0;
  CapButt* = 1;
  CapRound* = 2;
  CapProjecting* = 3;

(* joinStyle *)
CONST
  JoinMiter* = 0;
  JoinRound* = 1;
  JoinBevel* = 2;

(* fillStyle *)
CONST
  FillSolid* = 0;
  FillTiled* = 1;
  FillStippled* = 2;
  FillOpaqueStippled* = 3;

(* fillRule *)
CONST
  EvenOddRule* = 0;
  WindingRule* = 1;

(* subwindow mode *)
CONST
  ClipByChildren* = 0;
  IncludeInferiors* = 1;

(* SetClipRectangles ordering *)
CONST
  Unsorted* = 0;
  YSorted* = 1;
  YXSorted* = 2;
  YXBanded* = 3;

(* CoordinateMode for drawing routines *)
CONST
  CoordModeOrigin* = 0;         (* relative to the origin *)
  CoordModePrevious* = 1;       (* relative to previous point *)

(* Polygon shapes *)
CONST
  Complex* = 0;                 (* paths may intersect *)
  Nonconvex* = 1;               (* no paths intersect, but not convex *)
  Convex* = 2;                  (* wholly convex *)

(* Arc modes for PolyFillArc *)
CONST
  ArcChord* = 0;                (* join endpoints of arc *)
  ArcPieSlice* = 1;             (* join endpoints to center of arc *)


(* GC components: masks used in CreateGC, CopyGC, ChangeGC, OR'ed into
   GC_stateChanges *)
CONST
(*
  GCFunction* = {0};
  GCPlaneMask* = {1};
  GCForeground* = {2};
  GCBackground* = {3};
  GCLineWidth* = {4};
  GCLineStyle* = {5};
  GCCapStyle* = {6};
  GCJoinStyle* = {7};
  GCFillStyle* = {8};
  GCFillRule* = {9};
  GCTile* = {10};
  GCStipple* = {11};
  GCTileStipXOrigin* = {12};
  GCTileStipYOrigin* = {13};
  GCFont* = {14};
  GCSubwindowMode* = {15};
  GCGraphicsExposures* = {16};
  GCClipXOrigin* = {17};
  GCClipYOrigin* = {18};
  GCClipMask* = {19};
  GCDashOffset* = {20};
  GCDashList* = {21};
  GCArcMode* = {22};
  GCLastBit* = 22;
*)

  GCFunction* = 1;
  GCPlaneMask* = 2;
  GCForeground* = 4;
  GCBackground* = 8;
  GCLineWidth* = 16;
  GCLineStyle* = 32;
  GCCapStyle* = 64;
  GCJoinStyle* = 128;
  GCFillStyle* = 256;
(*
  GCFillRule* = {9};
  GCTile* = {10};
  GCStipple* = {11};
  GCTileStipXOrigin* = {12};
  GCTileStipYOrigin* = {13};
  GCFont* = {14};
  GCSubwindowMode* = {15};
  GCGraphicsExposures* = {16};
  GCClipXOrigin* = {17};
  GCClipYOrigin* = {18};
  GCClipMask* = {19};
  GCDashOffset* = {20};
  GCDashList* = {21};
  GCArcMode* = {22};
*)
  GCLastBit* = 22;
(*****************************************************************
 * FONTS
 *****************************************************************)

(* used in QueryFont -- draw direction *)
CONST
  FontLeftToRight* = 0;
  FontRightToLeft* = 1;
  FontChange* = 255;


(*****************************************************************
 *  IMAGING
 *****************************************************************)

(* ImageFormat -- PutImage, GetImage *)
CONST
  XYBitmap* = 0;                (* depth 1, XYFormat *)
  XYPixmap* = 1;                (* depth == drawable depth *)
  ZPixmap* = 2;                 (* depth == drawable depth *)


(*****************************************************************
 *  COLOR MAP STUFF
 *****************************************************************)

(* For CreateColormap *)
CONST
  AllocNone* = 0;               (* create map with no entries *)
  AllocAll* = 1;                (* allocate entire map writeable *)

(* Flags used in StoreNamedColor, StoreColors *)
CONST
  DoRed* = {0};
  DoGreen* = {1};
  DoBlue* = {2};


(*****************************************************************
 * CURSOR STUFF
 *****************************************************************)

(* QueryBestSize Class *)
CONST
  CursorShape* = 0;             (* largest size that can be displayed *)
  TileShape* = 1;               (* size tiled fastest *)
  StippleShape* = 2;            (* size stippled fastest *)


(*****************************************************************
 * KEYBOARD/POINTER STUFF
 *****************************************************************)
CONST
  AutoRepeatModeOff* = 0;
  AutoRepeatModeOn* = 1;
  AutoRepeatModeDefault* = 2;
  LedModeOff* = 0;
  LedModeOn* = 1;

(* masks for ChangeKeyboardControl *)
CONST
  KBKeyClickPercent* = {0};
  KBBellPercent* = {1};
  KBBellPitch* = {2};
  KBBellDuration* = {3};
  KBLed* = {4};
  KBLedMode* = {5};
  KBKey* = {6};
  KBAutoRepeatMode* = {7};
  MappingSuccess* = 0;
  MappingBusy* = 1;
  MappingFailed* = 2;
  MappingModifier* = 0;
  MappingKeyboard* = 1;
  MappingPointer* = 2;


(*****************************************************************
 * SCREEN SAVER STUFF
 *****************************************************************)
CONST
  DontPreferBlanking* = 0;
  PreferBlanking* = 1;
  DefaultBlanking* = 2;
  DisableScreenSaver* = 0;
  DisableScreenInterval* = 0;
  DontAllowExposures* = 0;
  AllowExposures* = 1;
  DefaultExposures* = 2;

(* for ForceScreenSaver *)
CONST
  ScreenSaverReset* = 0;
  ScreenSaverActive* = 1;


(*****************************************************************
 * HOSTS AND CONNECTIONS
 *****************************************************************)

(* for ChangeHosts *)
CONST
  HostInsert* = 0;
  HostDelete* = 1;

(* for ChangeAccessControl *)
CONST
  EnableAccess* = 1;
  DisableAccess* = 0;

(* Display classes  used in opening the connection
 * Note that the statically allocated ones are even numbered and the
 * dynamically changeable ones are odd numbered *)
CONST
  StaticGray* = 0;
  GrayScale* = 1;
  StaticColor* = 2;
  PseudoColor* = 3;
  TrueColor* = 4;
  DirectColor* = 5;

(* Byte order  used in imageByteOrder and bitmapBitOrder *)
CONST
  LSBFirst* = 0;
  MSBFirst* = 1;



(* ### include file Xlib.h, conversion of the file
       $XConsortium: Xlib.h,v 11.237 94/09/01 18:44:49 kaleb Exp $
       $XFree86: xc/lib/X11/Xlib.h,v 3.2 1994/09/17 13:44:15 dawes Exp $ *)

(*
 *	Xlib.h - Header definition and support file for the C subroutine
 *	interface library (Xlib) to the X Window System Protocol (V11).
 *	Structures and symbols starting with "_" are private to the library.
 *)

CONST
  XlibSpecificationRelease* = 6;

(* replace this with #include or typedef appropriate for your system *)
TYPE
  wchar_t* = C_longint;

TYPE
  XPointer* = C_address;
  XPointerPtr1d* = POINTER TO ARRAY [untagged] OF XPointer;
  Bool* = C_int;
  Status* = C_int;

CONST
  True* = 1;
  False* = 0;

CONST
  QueuedAlready* = 0;
  QueuedAfterReading* = 1;
  QueuedAfterFlush* = 2;

(*
 * Extensions need a way to hang private data on some structures.
 *)
TYPE
  XExtDataPtr* = POINTER TO XExtData;
  XExtData* = RECORD [untagged]
    number*: C_int;             (* number returned by XRegisterExtension *)
    next*: XExtDataPtr;         (* next item on list of data for structure *)
    free_private*: PROCEDURE (): C_int;  (* called to free private storage *)
    private_data*: XPointer;    (* data private to this extension. *)
  END;
  XExtDataPtr1d* = POINTER TO ARRAY [untagged] OF XExtDataPtr;

(*
 * This file contains structures used by the extension mechanism.
 *)
TYPE
  XExtCodesPtr* = POINTER TO XExtCodes;
  XExtCodes* = RECORD [untagged]
    extension*: C_int;          (* extension number *)
    major_opcode*: C_int;       (* major op-code assigned by server *)
    first_event*: C_int;        (* first event number for the extension *)
    first_error*: C_int;        (* first error number for the extension *)
  END;

(*
 * Data structure for retrieving info about pixmap formats.
 *)
TYPE
  XPixmapFormatValuesPtr* = POINTER TO XPixmapFormatValues;
  XPixmapFormatValues* = RECORD [untagged]
    depth*: C_int;
    bits_per_pixel*: C_int;
    scanline_pad*: C_int;
  END;

(*
 * Data structure for setting graphics context.
 *)
TYPE
  XGCValuesPtr* = POINTER TO XGCValues;
  XGCValues* = RECORD [untagged]
    function*: C_int;           (* logical operation *)
    plane_mask*: ulongmask;     (* plane mask *)
    foreground*: C_longint;     (* foreground pixel *)
    background*: C_longint;     (* background pixel *)
    line_width*: C_int;         (* line width *)
    line_style*: C_int;         (* LineSolid, LineOnOffDash, LineDoubleDash *)
    cap_style*: C_int;          (* CapNotLast, CapButt,
				   CapRound, CapProjecting *)
    join_style*: C_int;         (* JoinMiter, JoinRound, JoinBevel *)
    fill_style*: C_int;         (* FillSolid, FillTiled,
				   FillStippled, FillOpaeueStippled *)
    fill_rule*: C_int;          (* EvenOddRule, WindingRule *)
    arc_mode*: C_int;           (* ArcChord, ArcPieSlice *)
    tile*: Pixmap;              (* tile pixmap for tiling operations *)
    stipple*: Pixmap;           (* stipple 1 plane pixmap for stipping *)
    ts_x_origin*: C_int;        (* offset for tile or stipple operations *)
    ts_y_origin*: C_int;
    font*: Font;                (* default text font for text operations *)
    subwindow_mode*: C_int;     (* ClipByChildren, IncludeInferiors *)
    graphics_exposures*: Bool;  (* boolean, should exposures be generated *)
    clip_x_origin*: C_int;      (* origin for clipping *)
    clip_y_origin*: C_int;
    clip_mask*: Pixmap;         (* bitmap clipping; other calls for rects *)
    dash_offset*: C_int;        (* patterned/dashed line information *)
    dashes*: C_char;
  END;

(*
 * Graphics context.  The contents of this structure are implementation
 * dependent.  A GC should be treated as opaque by application code.
 *)
TYPE
  GC* = POINTER TO RECORD [untagged]
    ext_data*: XExtDataPtr;     (* hook for extension to hang data *)
    gid*: GContext;             (* protocol ID for graphics context *)
    (* there is more to this structure, but it is private to Xlib *)
  END;

(*
 * Visual structure; contains information about colormapping possible.
 *)
TYPE
  VisualPtr* = POINTER TO Visual;
  Visual* = RECORD [untagged]
    ext_data*: XExtDataPtr;     (* hook for extension to hang data *)
    visualid*: VisualID;        (* visual id of this visual *)
    class*: C_int;              (* class of screen (monochrome, etc.) *)
    red_mask*, green_mask*, blue_mask*: ulongmask;  (* mask values *)
    bits_per_rgb*: C_int;       (* log base 2 of distinct color values *)
    map_entries*: C_int;        (* color map entries *)
  END;

(*
 * Depth structure; contains information for each possible depth.
 *)
TYPE
  DepthPtr* = POINTER TO Depth;
  Depth* = RECORD [untagged]
    depth*: C_int;              (* this depth (Z) of the depth *)
    nvisuals*: C_int;           (* number of Visual types at this depth *)
    visuals*: VisualPtr;        (* list of visuals possible at this depth *)
  END;

(*
 * Information about the screen.  The contents of this structure are
 * implementation dependent.  A Screen should be treated as opaque
 * by application code.
 *)
TYPE
  DisplayPtr* = POINTER TO Display;
  ScreenPtr* = POINTER TO Screen;
  Screen* = RECORD [untagged]
    ext_data*: XExtDataPtr;     (* hook for extension to hang data *)
    display*: DisplayPtr;       (* back pointer to display structure *)
    root*: Window;              (* Root window id. *)
    width*, height*: C_int;     (* width and height of screen *)
    mwidth*, mheight*: C_int;   (* width and height of  in millimeters *)
    ndepths*: C_int;            (* number of depths possible *)
    depths*: DepthPtr;          (* list of allowable depths on the screen *)
    root_depth*: C_int;         (* bits per pixel *)
    root_visual*: VisualPtr;    (* root visual *)
    default_gc*: GC;            (* GC for the root root visual *)
    cmap*: Colormap;            (* default color map *)
    white_pixel*: C_longint;
    black_pixel*: C_longint;    (* White and Black pixel values *)
    max_maps*, min_maps*: C_int; (* max and min color maps *)
    backing_store*: C_int;      (* Never, WhenMapped, Always *)
    save_unders*: Bool;
    root_input_mask*: ulongmask;(* initial root input mask *)
  END;

(*
 * Format structure; describes ZFormat data the screen will understand.
 *)
TYPE
  ScreenFormatPtr* = POINTER TO ScreenFormat;
  ScreenFormat* = RECORD [untagged]
    ext_data*: XExtDataPtr;     (* hook for extension to hang data *)
    depth*: C_int;              (* depth of this image format *)
    bits_per_pixel*: C_int;     (* bits/pixel at this depth *)
    scanline_pad*: C_int;       (* scanline must padded to this multiple *)
  END;

(*
 * Data structure for setting window attributes.
 *)
TYPE
  XSetWindowAttributesPtr* = POINTER TO XSetWindowAttributes;
  XSetWindowAttributes* = RECORD [untagged]
    background_pixmap*: Pixmap; (* background or None or ParentRelative *)
    background_pixel*: C_longint;(* background pixel *)
    border_pixmap*: Pixmap;     (* border of the window *)
    border_pixel*: C_longint;   (* border pixel value *)
    bit_gravity*: C_int;        (* one of bit gravity values *)
    win_gravity*: C_int;        (* one of the window gravity values *)
    backing_store*: C_int;      (* NotUseful, WhenMapped, Always *)
    backing_planes*: C_longint; (* planes to be preseved if possible *)
    backing_pixel*: C_longint;  (* value to use in restoring planes *)
    save_under*: Bool;          (* should bits under be saved? (popups) *)
    event_mask*: ulongmask;     (* set of events that should be saved *)
    do_not_propagate_mask*: ulongmask;(* set of events that should not propagate *)
    override_redirect*: Bool;   (* boolean value for override-redirect *)
    colormap*: Colormap;        (* color map to be associated with window *)
    cursor*: Cursor;            (* cursor to be displayed (or None) *)
  END;

  XWindowAttributesPtr* = POINTER TO XWindowAttributes;
  XWindowAttributes* = RECORD [untagged]
    x*, y*: C_int;              (* location of window *)
    width*, height*: C_int;     (* width and height of window *)
    border_width*: C_int;       (* border width of window *)
    depth*: C_int;              (* depth of window *)
    visual*: VisualPtr;         (* the associated visual structure *)
    root*: Window;              (* root of screen containing window *)
    class*: C_int;              (* InputOutput, InputOnly*)
    bit_gravity*: C_int;        (* one of bit gravity values *)
    win_gravity*: C_int;        (* one of the window gravity values *)
    backing_store*: C_int;      (* NotUseful, WhenMapped, Always *)
    backing_planes*: C_longint; (* planes to be preserved if possible *)
    backing_pixel*: C_longint;  (* value to be used when restoring planes *)
    save_under*: Bool;          (* boolean, should bits under be saved? *)
    colormap*: Colormap;        (* color map to be associated with window *)
    map_installed*: Bool;       (* boolean, is color map currently installed*)
    map_state*: C_int;          (* IsUnmapped, IsUnviewable, IsViewable *)
    all_event_masks*: ulongmask;(* set of events all people have interest in*)
    your_event_mask*: ulongmask;(* my event mask *)
    do_not_propagate_mask*: ulongmask;(* set of events that should not propagate *)
    override_redirect*: Bool;   (* boolean value for override-redirect *)
    screen*: ScreenPtr;         (* back pointer to correct screen *)
  END;

(*
 * Data structure for host setting; getting routines.
 *
 *)
TYPE
  XHostAddressPtr* = POINTER TO XHostAddress;
  XHostAddress* = RECORD [untagged]
    family*: C_int;             (* for example FamilyInternet *)
    length*: C_int;             (* length of address, in bytes *)
    address*: C_string;      (* pointer to where to find the bytes *)
  END;
  XHostAddressPtr1d* = POINTER TO ARRAY [untagged] OF XHostAddress;

(*
 * Data structure for "image" data, used by image manipulation routines.
 *)
  XImagePtr* = POINTER TO XImage;
  XImage* = RECORD [untagged]
    width*, height*: C_int;     (* size of image *)
    xoffset*: C_int;            (* number of pixels offset in X direction *)
    format*: C_int;             (* XYBitmap, XYPixmap, ZPixmap *)
    data*: C_string;         (* pointer to image data *)
    byte_order*: C_int;         (* data byte order, LSBFirst, MSBFirst *)
    bitmap_unit*: C_int;        (* quant. of scanline 8, 16, 32 *)
    bitmap_bit_order*: C_int;   (* LSBFirst, MSBFirst *)
    bitmap_pad*: C_int;         (* 8, 16, 32 either XY or ZPixmap *)
    depth*: C_int;              (* depth of image *)
    bytes_per_line*: C_int;     (* accelarator to next line *)
    bits_per_pixel*: C_int;     (* bits per pixel (ZPixmap) *)
    red_mask*: ulongmask;       (* bits in z arrangment *)
    green_mask*: ulongmask;
    blue_mask*: ulongmask;
    obdata*: XPointer;          (* hook for the object routines to hang on *)
    f*: RECORD [untagged]                  (* image manipulation routines *)
      create_image*: PROCEDURE (): XImagePtr;
      destroy_image*: PROCEDURE (a: XImagePtr): C_int;
      get_pixel*: PROCEDURE (a: XImagePtr; b, c: C_int): C_longint;
      put_pixel*: PROCEDURE (a: XImagePtr; b, c: C_int; d: C_longint): C_int;
      sub_image*: PROCEDURE (a: XImagePtr; b, c: C_int; d, e: C_longint): XImagePtr;
      add_pixel*: PROCEDURE (a: XImagePtr; b: C_longint): C_int;
    END
  END;

(*
 * Data structure for XReconfigureWindow
 *)
TYPE
  XWindowChangesPtr* = POINTER TO XWindowChanges;
  XWindowChanges* = RECORD [untagged]
    x*, y*: C_int;
    width*, height*: C_int;
    border_width*: C_int;
    sibling*: Window;
    stack_mode*: C_int;
  END;

(*
 * Data structure used by color operations
 *)
TYPE
  XColorPtr* = POINTER TO XColor;
  XColor* = RECORD [untagged]
    pixel*: C_longint;
    red*, green*, blue*: C_shortint;
    flags*: C_char;       (* do_red, do_green, do_blue *)
    pad*: C_char;
  END;

(*
 * Data structures for graphics operations.  On most machines, these are
 * congruent with the wire protocol structures, so reformatting the data
 * can be avoided on these architectures.
 *)
TYPE
  XSegmentPtr* = POINTER TO XSegment;
  XSegment* = RECORD [untagged]
    x1*, y1*, x2*, y2*: C_shortint;
  END;
  XPointPtr* = POINTER TO XPoint;
  XPoint* = RECORD [untagged]
    x*, y*: C_shortint;
  END;
  XRectanglePtr* = POINTER TO XRectangle;
  XRectangle* = RECORD [untagged]
    x*, y*: C_shortint;
    width*, height*: C_shortint;
  END;
  XArcPtr* = POINTER TO XArc;
  XArc* = RECORD [untagged]
    x*, y*: C_shortint;
    width*, height*: C_shortint;
    angle1*, angle2*: C_shortint;
  END;

(* Data structure for XChangeKeyboardControl *)
TYPE
  XKeyboardControlPtr* = POINTER TO XKeyboardControl;
  XKeyboardControl* = RECORD [untagged]
    key_click_percent*: C_int;
    bell_percent*: C_int;
    bell_pitch*: C_int;
    bell_duration*: C_int;
    led*: C_int;
    led_mode*: C_int;
    key*: C_int;
    auto_repeat_mode*: C_int;   (* On, Off, Default *)
  END;

(* Data structure for XGetKeyboardControl *)
TYPE
  XKeyboardStatePtr* = POINTER TO XKeyboardState;
  XKeyboardState* = RECORD [untagged]
    key_click_percent*: C_int;
    bell_percent*: C_int;
    bell_pitch*, bell_duration*: C_int;
    led_mask*: ulongmask;
    global_auto_repeat*: C_int;
    auto_repeats*: ARRAY [untagged] 32 OF C_char;
  END;

(* Data structure for XGetMotionEvents.  *)
TYPE
  XTimeCoordPtr* = POINTER TO XTimeCoord;
  XTimeCoord* = RECORD [untagged]
    time*: Time;
    x*, y*: C_shortint;
  END;

(* Data structure for X{Set,Get}ModifierMapping *)
TYPE
  XModifierKeymapPtr* = POINTER TO XModifierKeymap;
  XModifierKeymap* = RECORD [untagged]
    max_keypermod*: C_int;      (* The server's max # of keys per modifier *)
    modifiermap*: KeyCodePtr1d; (* An 8 by max_keypermod array of modifiers *)
  END;

(*
 * Display datatype maintaining display specific data.
 * The contents of this structure are implementation dependent.
 * A Display should be treated as opaque by application code.
 *)
TYPE
  XPrivatePtr* = C_address;
  XrmHashBucketRecPtr* = C_address;

TYPE
  Display* = RECORD [untagged]
    ext_data*: XExtDataPtr;     (* hook for extension to hang data *)
    private1*: XPrivatePtr;
    fd*: C_int;                 (* Network socket. *)
    private2*: C_int;
    proto_major_version*: C_int;(* major version of server's X protocol *)
    proto_minor_version*: C_int;(* minor version of servers X protocol *)
    vendor*: C_string;       (* vendor of the server hardware *)
    private3*: XID;
    private4*: XID;
    private5*: XID;
    private6*: C_int;
    resource_alloc*: PROCEDURE (): XID;  (* allocator function *)
    byte_order*: C_int;         (* screen byte order, LSBFirst, MSBFirst *)
    bitmap_unit*: C_int;        (* padding and data requirements *)
    bitmap_pad*: C_int;         (* padding requirements on bitmaps *)
    bitmap_bit_order*: C_int;   (* LeastSignificant or MostSignificant *)
    nformats*: C_int;           (* number of pixmap formats in list *)
    pixmap_format*: ScreenFormatPtr;(* pixmap format list *)
    private8*: C_int;
    release*: C_int;            (* release of the server *)
    private9*: XPrivatePtr;
    private10*: XPrivatePtr;
    qlen*: C_int;               (* Length of input event queue *)
    last_request_read*: C_longint;(* seq number of last event read *)
    request*: C_longint;        (* sequence number of last request. *)
    private11*: XPointer;
    private12*: XPointer;
    private13*: XPointer;
    private14*: XPointer;
    max_request_size*: C_int;   (* maximum number 32 bit words in request*)
    db*: XrmHashBucketRecPtr;
    private15*: PROCEDURE (): C_int;
    display_name*: C_string; (* "host:display" string used on this connect*)
    default_screen*: C_int;     (* default screen for operations *)
    nscreens*: C_int;           (* number of screens on this server*)
    screens*: ScreenPtr;        (* pointer to list of screens *)
    motion_buffer*: C_longint;  (* size of motion buffer *)
    private16*: C_longint;
    min_keycode*: C_int;        (* minimum defined keycode *)
    max_keycode*: C_int;        (* maximum defined keycode *)
    private17*: XPointer;
    private18*: XPointer;
    private19*: C_int;
    xdefaults*: C_string;    (* contents of defaults from server *)
  END;


(*
 * Definitions of specific events.
 *)
TYPE
  XKeyEventPtr* = POINTER TO XKeyEvent;
  XKeyEvent* = RECORD [untagged]
    type*: C_int;               (* of event *)
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    window*: Window;            (* "event" window it is reported relative to *)
    root*: Window;              (* root window that the event occured on *)
    subwindow*: Window;         (* child window *)
    time*: Time;                (* milliseconds *)
    x*, y*: C_int;              (* pointer x, y coordinates in event window *)
    x_root*, y_root*: C_int;    (* coordinates relative to root *)
    state*: uintmask;           (* key or button mask *)
    keycode*: C_int;            (* detail *)
    same_screen*: Bool;         (* same screen flag *)
  END;
  XKeyPressedEvent* = XKeyEvent;
  XKeyReleasedEvent* = XKeyEvent;

  XButtonEventPtr* = POINTER TO XButtonEvent;
  XButtonEvent* = RECORD [untagged]
    type*: C_int;               (* of event *)
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    window*: Window;            (* "event" window it is reported relative to *)
    root*: Window;              (* root window that the event occured on *)
    subwindow*: Window;         (* child window *)
    time*: Time;                (* milliseconds *)
    x*, y*: C_int;              (* pointer x, y coordinates in event window *)
    x_root*, y_root*: C_int;    (* coordinates relative to root *)
    state*: uintmask;           (* key or button mask *)
    button*: C_int;             (* detail *)
    same_screen*: Bool;         (* same screen flag *)
  END;
  XButtonPressedEvent* = XButtonEvent;
  XButtonReleasedEvent* = XButtonEvent;

  XMotionEventPtr* = POINTER TO XMotionEvent;
  XMotionEvent* = RECORD [untagged]
    type*: C_int;               (* of event *)
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    window*: Window;            (* "event" window reported relative to *)
    root*: Window;              (* root window that the event occured on *)
    subwindow*: Window;         (* child window *)
    time*: Time;                (* milliseconds *)
    x*, y*: C_int;              (* pointer x, y coordinates in event window *)
    x_root*, y_root*: C_int;    (* coordinates relative to root *)
    state*: uintmask;           (* key or button mask *)
    is_hint*: C_char;           (* detail *)
    same_screen*: Bool;         (* same screen flag *)
  END;
  XPointerMovedEvent* = XMotionEvent;

  XCrossingEventPtr* = POINTER TO XCrossingEvent;
  XCrossingEvent* = RECORD [untagged]
    type*: C_int;               (* of event *)
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    window*: Window;            (* "event" window reported relative to *)
    root*: Window;              (* root window that the event occured on *)
    subwindow*: Window;         (* child window *)
    time*: Time;                (* milliseconds *)
    x*, y*: C_int;              (* pointer x, y coordinates in event window *)
    x_root*, y_root*: C_int;    (* coordinates relative to root *)
    mode*: C_int;               (* NotifyNormal, NotifyGrab, NotifyUngrab *)
    detail*: C_int;             (*
	 * NotifyAncestor, NotifyVirtual, NotifyInferior,
	 * NotifyNonlinear,NotifyNonlinearVirtual
	 *)
    same_screen*: Bool;         (* same screen flag *)
    focus*: Bool;               (* boolean focus *)
    state*: uintmask;           (* key or button mask *)
  END;
  XEnterWindowEvent* = XCrossingEvent;
  XLeaveWindowEvent* = XCrossingEvent;

  XFocusChangeEventPtr* = POINTER TO XFocusChangeEvent;
  XFocusChangeEvent* = RECORD [untagged]
    type*: C_int;               (* FocusIn or FocusOut *)
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    window*: Window;            (* window of event *)
    mode*: C_int;               (* NotifyNormal, NotifyGrab, NotifyUngrab *)
    detail*: C_int;             (*
	 * NotifyAncestor, NotifyVirtual, NotifyInferior,
	 * NotifyNonlinear,NotifyNonlinearVirtual, NotifyPointer,
	 * NotifyPointerRoot, NotifyDetailNone
	 *)
  END;
  XFocusInEvent* = XFocusChangeEvent;
  XFocusOutEvent* = XFocusChangeEvent;

(* generated on EnterWindow and FocusIn  when KeyMapState selected *)
  XKeymapEventPtr* = POINTER TO XKeymapEvent;
  XKeymapEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    window*: Window;
    key_vector*: ARRAY [untagged] 32 OF C_char;
  END;

  XExposeEventPtr* = POINTER TO XExposeEvent;
  XExposeEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    window*: Window;
    x*, y*: C_int;
    width*, height*: C_int;
    count*: C_int;              (* if non-zero, at least this many more *)
  END;
  XGraphicsExposeEventPtr* = POINTER TO XGraphicsExposeEvent;
  XGraphicsExposeEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    drawable*: Drawable;
    x*, y*: C_int;
    width*, height*: C_int;
    count*: C_int;              (* if non-zero, at least this many more *)
    major_code*: C_int;         (* core is CopyArea or CopyPlane *)
    minor_code*: C_int;         (* not defined in the core *)
  END;

  XNoExposeEventPtr* = POINTER TO XNoExposeEvent;
  XNoExposeEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    drawable*: Drawable;
    major_code*: C_int;         (* core is CopyArea or CopyPlane *)
    minor_code*: C_int;         (* not defined in the core *)
  END;

  XVisibilityEventPtr* = POINTER TO XVisibilityEvent;
  XVisibilityEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    window*: Window;
    state*: C_int;              (* Visibility state *)
  END;

  XCreateWindowEventPtr* = POINTER TO XCreateWindowEvent;
  XCreateWindowEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    parent*: Window;            (* parent of the window *)
    window*: Window;            (* window id of window created *)
    x*, y*: C_int;              (* window location *)
    width*, height*: C_int;     (* size of window *)
    border_width*: C_int;       (* border width *)
    override_redirect*: Bool;   (* creation should be overridden *)
  END;

  XDestroyWindowEventPtr* = POINTER TO XDestroyWindowEvent;
  XDestroyWindowEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    event*: Window;
    window*: Window;
  END;

  XUnmapEventPtr* = POINTER TO XUnmapEvent;
  XUnmapEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    event*: Window;
    window*: Window;
    from_configure*: Bool;
  END;

  XMapEventPtr* = POINTER TO XMapEvent;
  XMapEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    event*: Window;
    window*: Window;
    override_redirect*: Bool;   (* boolean, is override set... *)
  END;

  XMapRequestEventPtr* = POINTER TO XMapRequestEvent;
  XMapRequestEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    parent*: Window;
    window*: Window;
  END;

  XReparentEventPtr* = POINTER TO XReparentEvent;
  XReparentEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    event*: Window;
    window*: Window;
    parent*: Window;
    x*, y*: C_int;
    override_redirect*: Bool;
  END;

  XConfigureEventPtr* = POINTER TO XConfigureEvent;
  XConfigureEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    event*: Window;
    window*: Window;
    x*, y*: C_int;
    width*, height*: C_int;
    border_width*: C_int;
    above*: Window;
    override_redirect*: Bool;
  END;

  XGravityEventPtr* = POINTER TO XGravityEvent;
  XGravityEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    event*: Window;
    window*: Window;
    x*, y*: C_int;
  END;

  XResizeRequestEventPtr* = POINTER TO XResizeRequestEvent;
  XResizeRequestEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    window*: Window;
    width*, height*: C_int;
  END;

  XConfigureRequestEventPtr* = POINTER TO XConfigureRequestEvent;
  XConfigureRequestEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    parent*: Window;
    window*: Window;
    x*, y*: C_int;
    width*, height*: C_int;
    border_width*: C_int;
    above*: Window;
    detail*: C_int;             (* Above, Below, TopIf, BottomIf, Opposite *)
    value_mask*: ulongmask;
  END;

  XCirculateEventPtr* = POINTER TO XCirculateEvent;
  XCirculateEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    event*: Window;
    window*: Window;
    place*: C_int;              (* PlaceOnTop, PlaceOnBottom *)
  END;

  XCirculateRequestEventPtr* = POINTER TO XCirculateRequestEvent;
  XCirculateRequestEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    parent*: Window;
    window*: Window;
    place*: C_int;              (* PlaceOnTop, PlaceOnBottom *)
  END;

  XPropertyEventPtr* = POINTER TO XPropertyEvent;
  XPropertyEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    window*: Window;
    atom*: Atom;
    time*: Time;
    state*: C_int;              (* NewValue, Deleted *)
  END;

  XSelectionClearEventPtr* = POINTER TO XSelectionClearEvent;
  XSelectionClearEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    window*: Window;
    selection*: Atom;
    time*: Time;
  END;

  XSelectionRequestEventPtr* = POINTER TO XSelectionRequestEvent;
  XSelectionRequestEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    owner*: Window;
    requestor*: Window;
    selection*: Atom;
    target*: Atom;
    property*: Atom;
    time*: Time;
  END;

  XSelectionEventPtr* = POINTER TO XSelectionEvent;
  XSelectionEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    requestor*: Window;
    selection*: Atom;
    target*: Atom;
    property*: Atom;            (* ATOM or None *)
    time*: Time;
  END;

  XColormapEventPtr* = POINTER TO XColormapEvent;
  XColormapEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    window*: Window;
    colormap*: Colormap;        (* COLORMAP or None *)
    new*: Bool;
    state*: C_int;              (* ColormapInstalled, ColormapUninstalled *)
  END;

  XClientMessageEventPtr* = POINTER TO XClientMessageEvent;
  XClientMessageEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    window*: Window;
    message_type*: Atom;
    format*: C_int;
    data*: RECORD [union]
      b*: ARRAY [untagged] 20 OF C_char;
      s*: ARRAY [untagged] 10 OF C_shortint;
      l*: ARRAY [untagged] 5 OF C_longint;
    END;
  END;

  XMappingEventPtr* = POINTER TO XMappingEvent;
  XMappingEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    window*: Window;            (* unused *)
    request*: C_int;            (* one of MappingModifier, MappingKeyboard,
				   MappingPointer *)
    first_keycode*: C_int;      (* first keycode *)
    count*: C_int;              (* defines range of change w. first_keycode*)
  END;

  XErrorEventPtr* = POINTER TO XErrorEvent;
  XErrorEvent* = RECORD [untagged]
    type*: C_int;
    display*: DisplayPtr;       (* Display the event was read from *)
    resourceid*: XID;           (* resource id *)
    serial*: C_longint;         (* serial number of failed request *)
    error_code*: C_char;        (* error code of failed request *)
    request_code*: C_char;      (* Major op-code of failed request *)
    minor_code*: C_char;        (* Minor op-code of failed request *)
  END;

  XAnyEventPtr* = POINTER TO XAnyEvent;
  XAnyEvent* = RECORD [untagged]
    type*: C_int;
    serial*: C_longint;         (* # of last request processed by server *)
    send_event*: Bool;          (* true if this came from a SendEvent request *)
    display*: DisplayPtr;       (* Display the event was read from *)
    window*: Window;            (* window on which event was requested in event mask *)
  END;

(*
 * this union is defined so Xlib can always use the same sized
 * event structure internally, to avoid memory fragmentation.
 *)
  XEventPtr* = POINTER TO XEvent;
  XEvent* = RECORD [union]
    type*: C_int;               (* must not be changed; first element *)
    xany*: XAnyEvent;
    xkey*: XKeyEvent;
    xbutton*: XButtonEvent;
    xmotion*: XMotionEvent;
    xcrossing*: XCrossingEvent;
    xfocus*: XFocusChangeEvent;
    xexpose*: XExposeEvent;
    xgraphicsexpose*: XGraphicsExposeEvent;
    xnoexpose*: XNoExposeEvent;
    xvisibility*: XVisibilityEvent;
    xcreatewindow*: XCreateWindowEvent;
    xdestroywindow*: XDestroyWindowEvent;
    xunmap*: XUnmapEvent;
    xmap*: XMapEvent;
    xmaprequest*: XMapRequestEvent;
    xreparent*: XReparentEvent;
    xconfigure*: XConfigureEvent;
    xgravity*: XGravityEvent;
    xresizerequest*: XResizeRequestEvent;
    xconfigurerequest*: XConfigureRequestEvent;
    xcirculate*: XCirculateEvent;
    xcirculaterequest*: XCirculateRequestEvent;
    xproperty*: XPropertyEvent;
    xselectionclear*: XSelectionClearEvent;
    xselectionrequest*: XSelectionRequestEvent;
    xselection*: XSelectionEvent;
    xcolormap*: XColormapEvent;
    xclient*: XClientMessageEvent;
    xmapping*: XMappingEvent;
    xerror*: XErrorEvent;
    xkeymap*: XKeymapEvent;
    pad*: ARRAY [untagged] 24 OF C_longint;
  END;


(*
 * per character font metric information.
 *)
TYPE
  XCharStructPtr* = POINTER TO XCharStruct;
  XCharStruct* = RECORD [untagged]
    lbearing*: C_shortint;      (* origin to left edge of raster *)
    rbearing*: C_shortint;      (* origin to right edge of raster *)
    width*: C_shortint;         (* advance to next char's origin *)
    ascent*: C_shortint;        (* baseline to top edge of raster *)
    descent*: C_shortint;       (* baseline to bottom edge of raster *)
    attributes*: C_shortint;    (* per char flags (not predefined) *)
  END;

(*
 * To allow arbitrary information with fonts, there are additional properties
 * returned.
 *)
TYPE
  XFontPropPtr* = POINTER TO XFontProp;
  XFontProp* = RECORD [untagged]
    name*: Atom;
    card32*: C_longint;
  END;

  XFontStructPtr* = POINTER TO XFontStruct;
  XFontStruct* = RECORD [untagged]
    ext_data*: XExtDataPtr;     (* hook for extension to hang data *)
    fid*: Font;                 (* Font id for this font *)
    direction*: C_int;          (* hint about direction the font is painted *)
    min_char_or_byte2*: C_int;  (* first character *)
    max_char_or_byte2*: C_int;  (* last character *)
    min_byte1*: C_int;          (* first row that exists *)
    max_byte1*: C_int;          (* last row that exists *)
    all_chars_exist*: Bool;     (* flag if all characters have non-zero size*)
    default_char*: C_int;       (* char to print for undefined character *)
    n_properties*: C_int;       (* how many properties there are *)
    properties*: XFontPropPtr;  (* pointer to array of additional properties*)
    min_bounds*: XCharStruct;   (* minimum bounds over all existing char*)
    max_bounds*: XCharStruct;   (* maximum bounds over all existing char*)
    per_char*: XCharStructPtr;  (* first_char to last_char information *)
    ascent*: C_int;             (* log. extent above baseline for spacing *)
    descent*: C_int;            (* log. descent below baseline for spacing *)
  END;

(*
 * PolyText routines take these as arguments.
 *)
TYPE
  XTextItemPtr* = POINTER TO XTextItem;
  XTextItem* = RECORD [untagged]
    chars*: C_string;        (* pointer to string *)
    nchars*: C_int;             (* number of characters *)
    delta*: C_int;              (* delta between strings *)
    font*: Font;                (* font to print it in, None don't change *)
  END;

  XChar2bPtr* = POINTER TO XChar2b;
  XChar2b* = RECORD [untagged]
    byte1*: C_char;
    byte2*: C_char;
  END;

  XTextItem16Ptr* = POINTER TO XTextItem16;
  XTextItem16* = RECORD [untagged]
    chars*: XChar2bPtr;         (* two byte characters *)
    nchars*: C_int;             (* number of characters *)
    delta*: C_int;              (* delta between strings *)
    font*: Font;                (* font to print it in, None don't change *)
  END;

  XEDataObjectPtr* = POINTER TO XEDataObject;
  XEDataObject* = RECORD [union]
    display*: DisplayPtr;
    gc*: GC;
    visual*: VisualPtr;
    screen*: ScreenPtr;
    pixmap_format*: ScreenFormatPtr;
    font*: XFontStructPtr;
  END;

  XFontSetExtentsPtr* = POINTER TO XFontSetExtents;
  XFontSetExtents* = RECORD [untagged]
    max_ink_extent*: XRectangle;
    max_logical_extent*: XRectangle;
  END;

TYPE
  XOMProc* = PROCEDURE;

  XOMDesc* = RECORD [untagged] END;
  XOCDesc* = RECORD [untagged] END;
  XOM* = POINTER TO XOMDesc;
  XOC* = POINTER TO XOCDesc;
  XFontSet* = POINTER TO XOCDesc;

TYPE
  XmbTextItemPtr* = POINTER TO XmbTextItem;
  XmbTextItem* = RECORD [untagged]
    chars*: C_string;
    nchars*: C_int;
    delta*: C_int;
    font_set*: XFontSet;
  END;

TYPE
  wstring* = POINTER TO ARRAY [untagged] OF wchar_t;
  wcharPtr2d* = POINTER TO ARRAY [untagged] OF wstring;
  XwcTextItemPtr* = POINTER TO XwcTextItem;
  XwcTextItem* = RECORD [untagged]
    chars*: wstring;
    nchars*: C_int;
    delta*: C_int;
    font_set*: XFontSet;
  END;


CONST
  XNRequiredCharSet* = "requiredCharSet";
  XNQueryOrientation* = "queryOrientation";
  XNBaseFontName* = "baseFontName";
  XNOMAutomatic* = "omAutomatic";
  XNMissingCharSet* = "missingCharSet";
  XNDefaultString* = "defaultString";
  XNOrientation* = "orientation";
  XNDirectionalDependentDrawing* = "directionalDependentDrawing";
  XNContextualDrawing* = "contextualDrawing";
  XNFontInfo* = "fontInfo";

TYPE
  XOMCharSetListPtr* = POINTER TO XOMCharSetList;
  XOMCharSetList* = RECORD [untagged]
    charset_count*: C_int;
    charset_list*: C_charPtr2d;
  END;

CONST  (* enum XOrientation *)
  XOMOrientation_LTR_TTB* = 0;
  XOMOrientation_RTL_TTB* = 1;
  XOMOrientation_TTB_LTR* = 2;
  XOMOrientation_TTB_RTL* = 3;
  XOMOrientation_Context* = 4;

TYPE
  XOrientation* = C_enum1;
  XOrientationPtr1d* = POINTER TO ARRAY [untagged] OF XOrientation;

TYPE
  XOMOrientationPtr* = POINTER TO XOMOrientation;
  XOMOrientation* = RECORD [untagged]
    num_orient*: C_int;
    orient*: XOrientationPtr1d;    (* Input Text description *)
  END;

TYPE
  XFontStructPtr1d* = POINTER TO ARRAY [untagged] OF XFontStructPtr;
  XOMFontInfoPtr* = POINTER TO XOMFontInfo;
  XOMFontInfo* = RECORD [untagged]
    num_font*: C_int;
    font_struct_list*: XFontStructPtr1d;
    font_name_list*: C_charPtr2d;
  END;

TYPE
  XIMProc* = PROCEDURE;

TYPE
  XIMDesc* = RECORD [untagged] END;
  XICDesc* = RECORD [untagged] END;
  XIM* = POINTER TO XIMDesc;
  XIC* = POINTER TO XICDesc;

  XIMStyle* = C_longint;
  XIMStylePtr1d* = POINTER TO ARRAY [untagged] OF XIMStyle;

TYPE
  XIMStylesPtr* = POINTER TO XIMStyles;
  XIMStyles* = RECORD [untagged]
    count_styles*: C_shortint;
    supported_styles*: XIMStylePtr1d;
  END;

CONST
  XIMPreeditArea* = 00001H;
  XIMPreeditCallbacks* = 00002H;
  XIMPreeditPosition* = 00004H;
  XIMPreeditNothing* = 00008H;
  XIMPreeditNone* = 00010H;
  XIMStatusArea* = 00100H;
  XIMStatusCallbacks* = 00200H;
  XIMStatusNothing* = 00400H;
  XIMStatusNone* = 00800H;

CONST
  XNVaNestedList* = "XNVaNestedList";
  XNQueryInputStyle* = "queryInputStyle";
  XNClientWindow* = "clientWindow";
  XNInputStyle* = "inputStyle";
  XNFocusWindow* = "focusWindow";
  XNResourceName* = "resourceName";
  XNResourceClass* = "resourceClass";
  XNGeometryCallback* = "geometryCallback";
  XNDestroyCallback* = "destroyCallback";
  XNFilterEvents* = "filterEvents";
  XNPreeditStartCallback* = "preeditStartCallback";
  XNPreeditDoneCallback* = "preeditDoneCallback";
  XNPreeditDrawCallback* = "preeditDrawCallback";
  XNPreeditCaretCallback* = "preeditCaretCallback";
  XNPreeditStateNotifyCallback* = "preeditStateNotifyCallback";
  XNPreeditAttributes* = "preeditAttributes";
  XNStatusStartCallback* = "statusStartCallback";
  XNStatusDoneCallback* = "statusDoneCallback";
  XNStatusDrawCallback* = "statusDrawCallback";
  XNStatusAttributes* = "statusAttributes";
  XNArea* = "area";
  XNAreaNeeded* = "areaNeeded";
  XNSpotLocation* = "spotLocation";
  XNColormap* = "colorMap";
  XNStdColormap* = "stdColorMap";
  XNForeground* = "foreground";
  XNBackground* = "background";
  XNBackgroundPixmap* = "backgroundPixmap";
  XNFontSet* = "fontSet";
  XNLineSpace* = "lineSpace";
  XNCursor* = "cursor";

CONST
  XNQueryIMValuesList* = "queryIMValuesList";
  XNQueryICValuesList* = "queryICValuesList";
  XNVisiblePosition* = "visiblePosition";
  XNR6PreeditCallback* = 6;
  XNStringConversionCallback* = "stringConversionCallback";
  XNStringConversion* = "stringConversion";
  XNResetState* = "resetState";
  XNHotKey* = "hotKey";
  XNHotKeyState* = "hotKeyState";
  XNPreeditState* = "preeditState";
  XNSeparatorofNestedList* = "separatorofNestedList";

CONST
  XBufferOverflow* = 1;
  XLookupNone* = 1;
  XLookupChars* = 2;
  XLookupKeySym* = 3;
  XLookupBoth* = 4;

TYPE
  XVaNestedList* = C_address;

TYPE
  XIMCallbackPtr* = POINTER TO XIMCallback;
  XIMCallback* = RECORD [untagged]
    client_data*: XPointer;
    callback*: XIMProc;
  END;

  XIMFeedback* = C_longint;
  XIMFeedbackPtr1d* = POINTER TO ARRAY [untagged] OF XIMFeedback;

CONST
  XIMReverse* = {0};
  XIMUnderline* = {1};
  XIMHighlight* = {2};
  XIMPrimary* = {5};
  XIMSecondary* = {6};
  XIMTertiary* = {7};
  XIMVisibleToForward* = {8};
  XIMVisibleToBackword* = {9};
  XIMVisibleToCenter* = {10};


TYPE
  XIMTextPtr* = POINTER TO XIMText;
  XIMText* = RECORD [untagged]
    length*: C_shortint;
    feedback*: XIMFeedbackPtr1d;
    encoding_is_wchar*: Bool;
    string*: RECORD [union]
      multi_byte*: C_string;
      wide_char*: wstring
    END
  END;

  XIMPreeditState* = C_longint;

CONST
  XIMPreeditUnKnown* = {};
  XIMPreeditEnable* = {0};
  XIMPreeditDisable* = {1};


TYPE
  XIMPreeditStateNotifyCallbackStructPtr* = POINTER TO XIMPreeditStateNotifyCallbackStruct;
  XIMPreeditStateNotifyCallbackStruct* = RECORD [untagged]
    state*: XIMPreeditState;
  END;

  XIMResetState* = C_longint;

CONST
  XIMInitialState* = {0};
  XIMPreserveState* = {1};

TYPE
  XIMStringConversionFeedback* = C_longint;
  XIMStringConversionFeedbackPtr1d* = POINTER TO ARRAY [untagged] OF XIMStringConversionFeedback;

CONST
  XIMStringConversionLeftEdge* = 000000001H;
  XIMStringConversionRightEdge* = 000000002H;
  XIMStringConversionTopEdge* = 000000004H;
  XIMStringConversionBottomEdge* = 000000008H;
  XIMStringConversionConcealed* = 000000010H;
  XIMStringConversionWrapped* = 000000020H;

TYPE
  XIMStringConversionTextPtr* = POINTER TO XIMStringConversionText;
  XIMStringConversionText* = RECORD [untagged]
    length*: C_shortint;
    feedback*: XIMStringConversionFeedbackPtr1d;
    encoding_is_wchar*: Bool;
    string*: RECORD [union]
      mbs*: C_string;
      wcs*: wstring;
    END;
  END;
  XIMStringConversionPosition* = C_shortint;
  XIMStringConversionType* = C_shortint;

CONST
  XIMStringConversionBuffer* = 00001H;
  XIMStringConversionLine* = 00002H;
  XIMStringConversionWord* = 00003H;
  XIMStringConversionChar* = 00004H;

TYPE
  XIMStringConversionOperation* = C_shortint;

CONST
  XIMStringConversionSubstitution* = 00001H;
  XIMStringConversionRetrival* = 00002H;


TYPE
  XIMStringConversionCallbackStructPtr* = POINTER TO XIMStringConversionCallbackStruct;
  XIMStringConversionCallbackStruct* = RECORD [untagged]
    position*: XIMStringConversionPosition;
    type*: XIMStringConversionType;
    operation*: XIMStringConversionOperation;
    factor*: C_shortint;
    text*: XIMStringConversionTextPtr;
  END;

  XIMPreeditDrawCallbackStructPtr* = POINTER TO XIMPreeditDrawCallbackStruct;
  XIMPreeditDrawCallbackStruct* = RECORD [untagged]
    caret*: C_int;              (* Cursor offset within pre-edit string *)
    chg_first*: C_int;          (* Starting change position *)
    chg_length*: C_int;         (* Length of the change in character count *)
    text*: XIMTextPtr;
  END;

CONST  (* enum XIMCaretDirection *)
  XIMForwardChar* = 0;
  XIMBackwardChar* = 1;
  XIMForwardWord* = 2;
  XIMBackwardWord* = 3;
  XIMCaretUp* = 4;
  XIMCaretDown* = 5;
  XIMNextLine* = 6;
  XIMPreviousLine* = 7;
  XIMLineStart* = 8;
  XIMLineEnd* = 9;
  XIMAbsolutePosition* = 10;
  XIMDontChange* = 11;

TYPE
  XIMCaretDirection* = C_enum1;

CONST  (* enum XIMCaretStyle *)
  XIMIsInvisible* = 0;
  XIMIsPrimary* = 1;
  XIMIsSecondary* = 2;

TYPE
  XIMCaretStyle* = C_enum1;

TYPE
  XIMPreeditCaretCallbackStructPtr* = POINTER TO XIMPreeditCaretCallbackStruct;
  XIMPreeditCaretCallbackStruct* = RECORD [untagged]
    position*: C_int;           (* Caret offset within pre-edit string *)
    direction*: XIMCaretDirection;(* Caret moves direction *)
    style*: XIMCaretStyle;      (* Feedback of the caret *)
  END;

CONST  (* enum XIMStatusDataType *)
  XIMTextType* = 0;
  XIMBitmapType* = 1;

TYPE
  XIMStatusDataType* = C_enum1;

TYPE
  XIMStatusDrawCallbackStructPtr* = POINTER TO XIMStatusDrawCallbackStruct;
  XIMStatusDrawCallbackStruct* = RECORD [untagged]
    type*: XIMStatusDataType;
    data*: RECORD [union]
      text*: XIMTextPtr;
      bitmap*: Pixmap;
    END;
  END;

  XIMHotKeyTriggerPtr* = POINTER TO XIMHotKeyTrigger;
  XIMHotKeyTrigger* = RECORD [untagged]
    keysym*: KeySym;
    modifier*: C_int;
    modifier_mask*: uintmask;
  END;

  XIMHotKeyTriggersPtr* = POINTER TO XIMHotKeyTriggers;
  XIMHotKeyTriggers* = RECORD [untagged]
    num_hot_key*: C_int;
    key*: XIMHotKeyTriggerPtr;
  END;
  XIMHotKeyState* = C_longint;

CONST
  XIMHotKeyStateON* = 00001H;
  XIMHotKeyStateOFF* = 00002H;

TYPE
  XIMValuesList* = RECORD [untagged]
    count_values*: C_shortint;
    supported_values*: C_charPtr2d;
  END;


VAR
  _Xdebug*: C_int;

TYPE
  (* procedure type declarations to acommodate the stricter Oberon-2
     assignment rules.*)
  DisplayProc* = PROCEDURE (display: DisplayPtr): C_int;
  EventProc* = PROCEDURE (display: DisplayPtr; event: XEventPtr; arg: XPointer): Bool;

  (* Xlib procedure variables *)
  XErrorHandler* = PROCEDURE (display: DisplayPtr; error_event: XErrorEventPtr): C_int;
  XIOErrorHandler* = PROCEDURE (display: DisplayPtr);
  XConnectionWatchProc* = PROCEDURE (dpy: DisplayPtr; client_date: XPointer; fd: C_int; opening: Bool; watch_data: XPointerPtr1d);

PROCEDURE XLoadQueryFont* (
    display: DisplayPtr;
    VAR name: ARRAY [untagged] OF C_char): XFontStructPtr;
PROCEDURE XQueryFont* (
    display: DisplayPtr;
    font_ID: XID): XFontStructPtr;
PROCEDURE XGetMotionEvents* (
    display: DisplayPtr;
    w: Window;
    start: Time;
    stop: Time;
    VAR nevents_return: C_int): XTimeCoordPtr;
PROCEDURE XDeleteModifiermapEntry* (
    modmap: XModifierKeymapPtr;
    keycode_entry: KeyCode;  (* or unsigned int instead of KeyCode *)
    modifier: C_int): XModifierKeymapPtr;
PROCEDURE XGetModifierMapping* (
    display: DisplayPtr): XModifierKeymapPtr;
PROCEDURE XInsertModifiermapEntry* (
    modmap: XModifierKeymapPtr;
    keycode_entry: KeyCode;  (* or unsigned int instead of KeyCode *)
    modifier: C_int): XModifierKeymapPtr;
PROCEDURE XNewModifiermap* (
    max_keys_per_mod: C_int): XModifierKeymapPtr;
PROCEDURE XCreateImage* (
    display: DisplayPtr;
    visual: VisualPtr;
    depth: C_int;
    format: C_int;
    offset: C_int;
    data: C_address;
    width: C_int;
    height: C_int;
    bitmap_pad: C_int;
    bytes_per_line: C_int): XImagePtr;
PROCEDURE XInitImage* (
    image: XImagePtr): Status;
PROCEDURE XGetImage* (
    display: DisplayPtr;
    d: Drawable;
    x: C_int;
    y: C_int;
    width: C_int;
    height: C_int;
    plane_mask: ulongmask;
    format: C_int): XImagePtr;
PROCEDURE XGetSubImage* (
    display: DisplayPtr;
    d: Drawable;
    x: C_int;
    y: C_int;
    width: C_int;
    height: C_int;
    plane_mask: ulongmask;
    format: C_int;
    dest_image: XImagePtr;
    dest_x: C_int;
    dest_y: C_int): XImagePtr;
  PROCEDURE XGetPixel*(
    image : XImagePtr;
    x: C_int;
    y: C_int): C_longint;
  PROCEDURE XPutPixel*(
    image : XImagePtr;
    x: C_int;
    y: C_int;
    pixel : C_longint);
  PROCEDURE XSubImage*(
    image : XImagePtr;
    x: C_int;
    y: C_int;
    subimage_width : C_int;
    subimage_height : C_int):XImagePtr;
 PROCEDURE XAddPixel*(
    image : XImagePtr;
    value : C_longint);
 PROCEDURE XDestroyImage*(
    image : XImagePtr);

(*
 * X function declarations.
 *)
PROCEDURE XOpenDisplay* ( display_name : C_string) : DisplayPtr;
    (* display_name [nil] : ARRAY [untagged] OF C_char): DisplayPtr; *)
PROCEDURE XrmInitialize* ();
PROCEDURE XFetchBytes* (
    display: DisplayPtr;
    VAR nbytes_return: C_int): C_string;
PROCEDURE XFetchBuffer* (
    display: DisplayPtr;
    VAR nbytes_return: C_int;
    buffer: C_int): C_string;
PROCEDURE XGetAtomName* (
    display: DisplayPtr;
    atom: Atom): C_string;
PROCEDURE XGetAtomNames* (
    dpy: DisplayPtr;
    VAR atoms: ARRAY [untagged] OF Atom;
    count: C_int;
    VAR names_return: C_charPtr2d): Status;
PROCEDURE XGetDefault* (
    display: DisplayPtr;
    program: C_string;
    option: C_string): C_string;
PROCEDURE XDisplayName* (
    string : C_string): C_string;
PROCEDURE XKeysymToString* (
    keysym: KeySym): C_string;
PROCEDURE XSynchronize* (
    display: DisplayPtr;
    onoff: Bool): DisplayProc;
PROCEDURE XSetAfterFunction* (
    display: DisplayPtr;
    procedure: DisplayProc): DisplayProc;
PROCEDURE XInternAtom* (
    display: DisplayPtr;
    atom_name: C_string;
    only_if_exists: Bool): Atom;
PROCEDURE XInternAtoms* (
    dpy: DisplayPtr;
    names: C_charPtr2d;
    count: C_int;
    onlyIfExists: Bool;
    VAR atoms_return: Atom): Status;
PROCEDURE XCopyColormapAndFree* (
    display: DisplayPtr;
    colormap: Colormap): Colormap;
PROCEDURE XCreateColormap* (
    display: DisplayPtr;
    w: Window;
    visual: VisualPtr;
    alloc: C_int): Colormap;
PROCEDURE XCreatePixmapCursor* (
    display: DisplayPtr;
    source: Pixmap;
    mask: Pixmap;
    VAR foreground_color: XColor;
    VAR background_color: XColor;
    x: C_int;
    y: C_int): Cursor;
PROCEDURE XCreateGlyphCursor* (
    display: DisplayPtr;
    source_font: Font;
    mask_font: Font;
    source_char: C_int;
    mask_char: C_int;
    VAR foreground_color: XColor;
    VAR background_color: XColor): Cursor;
PROCEDURE XCreateFontCursor* (
    display: DisplayPtr;
    shape: C_int): Cursor;
PROCEDURE XLoadFont* (
    display: DisplayPtr;
    name: C_string): Font;
PROCEDURE XCreateGC* (
    display: DisplayPtr;
    d: Drawable;
    valuemask: ulongmask;
    VAR values: XGCValues): GC;
PROCEDURE XGContextFromGC* (
    gc: GC): GContext;
PROCEDURE XFlushGC* (
    display: DisplayPtr;
    gc: GC);
PROCEDURE XCreatePixmap* (
    display: DisplayPtr;
    d: Drawable;
    width: C_int;
    height: C_int;
    depth: C_int): Pixmap;
PROCEDURE XCreateBitmapFromData* (
    display: DisplayPtr;
    d: Drawable;
    VAR data: ARRAY [untagged] OF C_char;
    width: C_int;
    height: C_int): Pixmap;
PROCEDURE XCreatePixmapFromBitmapData* (
    display: DisplayPtr;
    d: Drawable;
    data: C_address;
    width: C_int;
    height: C_int;
    fg: C_longint;
    bg: C_longint;
    depth: C_int): Pixmap;
PROCEDURE XCreateSimpleWindow* (
    display: DisplayPtr;
    parent: Window;
    x: C_int;
    y: C_int;
    width: C_int;
    height: C_int;
    border_width: C_int;
    border: C_longint;
    background: C_longint): Window;
PROCEDURE XGetSelectionOwner* (
    display: DisplayPtr;
    selection: Atom): Window;
PROCEDURE XCreateWindow* (
    display: DisplayPtr;
    parent: Window;
    x: C_int;
    y: C_int;
    width: C_int;
    height: C_int;
    border_width: C_int;
    depth: C_int;
    class: C_int;
    VAR visual: Visual;
    valuemask: ulongmask;
    VAR attributes: XSetWindowAttributes): Window;
PROCEDURE XListInstalledColormaps* (
    display: DisplayPtr;
    w: Window;
    VAR num_return: C_int): ColormapPtr1d;
PROCEDURE XListFonts* (
    display: DisplayPtr;
    VAR pattern: ARRAY [untagged] OF C_char;
    maxnames: C_int;
    VAR actual_count_return: C_int): C_charPtr2d;
PROCEDURE XListFontsWithInfo* (
    display: DisplayPtr;
    VAR pattern: ARRAY [untagged] OF C_char;
    maxnames: C_int;
    VAR count_return: C_int;
    VAR info_return: XFontStructPtr1d): C_charPtr2d;
PROCEDURE XGetFontPath* (
    display: DisplayPtr;
    VAR npaths_return: C_int): C_charPtr2d;
PROCEDURE XListExtensions* (
    display: DisplayPtr;
    VAR nextensions_return: C_int): C_charPtr2d;
PROCEDURE XListProperties* (
    display: DisplayPtr;
    w: Window;
    VAR num_prop_return: C_int): AtomPtr1d;
PROCEDURE XListHosts* (
    display: DisplayPtr;
    VAR nhosts_return: C_int;
    VAR state_return: Bool): XHostAddressPtr1d;
PROCEDURE XKeycodeToKeysym* (
    display: DisplayPtr;
    keycode: KeyCode;  (* or C_int *)
    index: C_int): KeySym;
PROCEDURE XLookupKeysym* (
    key_event: XKeyEventPtr;
    index: C_int): KeySym;
PROCEDURE XGetKeyboardMapping* (
    display: DisplayPtr;
    first_keycode: KeyCode;  (* or C_int *)
    keycode_count: C_int;
    VAR keysyms_per_keycode_return: C_int): KeySymPtr1d;
PROCEDURE XStringToKeysym* (
    string: C_string): KeySym;
PROCEDURE XMaxRequestSize* (
    display: DisplayPtr): C_longint;
PROCEDURE XExtendedMaxRequestSize* (
    display: DisplayPtr): C_longint;
PROCEDURE XResourceManagerString* (
    display: DisplayPtr): C_string;
PROCEDURE XScreenResourceString* (
    screen: ScreenPtr): C_string;
PROCEDURE XDisplayMotionBufferSize* (
    display: DisplayPtr): C_longint;
PROCEDURE XVisualIDFromVisual* (
    visual: VisualPtr): VisualID;


(* multithread routines *)
PROCEDURE XInitThreads* (): Status;
PROCEDURE XLockDisplay* (
    display: DisplayPtr);
PROCEDURE XUnlockDisplay* (
    display: DisplayPtr);


(* routines for dealing with extensions *)
PROCEDURE XInitExtension* (
    display: DisplayPtr;
    name: C_string): XExtCodesPtr;
PROCEDURE XAddExtension* (
    display: DisplayPtr): XExtCodesPtr;
PROCEDURE XFindOnExtensionList* (
    VAR structure: ARRAY [untagged] OF XExtDataPtr;
    number: C_int): XExtDataPtr;
PROCEDURE XEHeadOfExtensionList* (
    object: XEDataObject): XExtDataPtr1d;

(* these are routines for which there are also macros *)
PROCEDURE XRootWindow* (
    display: DisplayPtr;
    screen_number: C_int): Window;
PROCEDURE XDefaultRootWindow* (
    display: DisplayPtr): Window;
PROCEDURE XRootWindowOfScreen* (
    screen: ScreenPtr): Window;
PROCEDURE XDefaultVisual* (
    display: DisplayPtr;
    screen_number: C_int): VisualPtr;
PROCEDURE XDefaultVisualOfScreen* (
    screen: ScreenPtr): VisualPtr;
PROCEDURE XDefaultGC* (
    display: DisplayPtr;
    screen_number: C_int): GC;
PROCEDURE XDefaultGCOfScreen* (
    screen: ScreenPtr): GC;
PROCEDURE XBlackPixel* (
    display: DisplayPtr;
    screen_number: C_int): C_longint;
PROCEDURE XWhitePixel* (
    display: DisplayPtr;
    screen_number: C_int): C_longint;
PROCEDURE XAllPlanes* (): C_longint;
PROCEDURE XBlackPixelOfScreen* (
    screen: ScreenPtr): C_longint;
PROCEDURE XWhitePixelOfScreen* (
    screen: ScreenPtr): C_longint;
PROCEDURE XNextRequest* (
    display: DisplayPtr): C_longint;
PROCEDURE XLastKnownRequestProcessed* (
    display: DisplayPtr): C_longint;
PROCEDURE XServerVendor* (
    display: DisplayPtr): C_string;
PROCEDURE XDisplayString* (
    display: DisplayPtr): C_string;
PROCEDURE XDefaultColormap* (
    display: DisplayPtr;
    screen_number: C_int): Colormap;
PROCEDURE XDefaultColormapOfScreen* (
    screen: ScreenPtr): Colormap;
PROCEDURE XDisplayOfScreen* (
    screen: ScreenPtr): DisplayPtr;
PROCEDURE XScreenOfDisplay* (
    display: DisplayPtr;
    screen_number: C_int): ScreenPtr;
PROCEDURE XDefaultScreenOfDisplay* (
    display: DisplayPtr): ScreenPtr;
PROCEDURE XEventMaskOfScreen* (
    screen: ScreenPtr): C_longint;
PROCEDURE XScreenNumberOfScreen* (
    screen: ScreenPtr): C_int;
PROCEDURE XSetErrorHandler* (
    handler: XErrorHandler): XErrorHandler;
PROCEDURE XSetIOErrorHandler* (
    handler: XIOErrorHandler): XIOErrorHandler;

PROCEDURE XListPixmapFormats* (
    display: DisplayPtr;
    VAR count_return: C_int): XPixmapFormatValuesPtr;
PROCEDURE XListDepths* (
    display: DisplayPtr;
    screen_number: C_int;
    VAR count_return: C_int): C_intPtr1d;


(* ICCCM routines for things that don't require special include files; *)
(* other declarations are given in Xutil.h                             *)
PROCEDURE XReconfigureWMWindow* (
    display: DisplayPtr;
    w: Window;
    screen_number: C_int;
    mask: uintmask;
    VAR changes: XWindowChanges): Status;
PROCEDURE XGetWMProtocols* (
    display: DisplayPtr;
    w: Window;
    VAR protocols_return: AtomPtr1d;
    VAR count_return: C_int): Status;
PROCEDURE XSetWMProtocols* (
    display: DisplayPtr;
    w: Window;
    VAR protocols: ARRAY [untagged] OF Atom;
    count: C_int): Status;
PROCEDURE XIconifyWindow* (
    display: DisplayPtr;
    w: Window;
    screen_number: C_int): Status;
PROCEDURE XWithdrawWindow* (
    display: DisplayPtr;
    w: Window;
    screen_number: C_int): Status;
PROCEDURE XGetCommand* (
    display: DisplayPtr;
    w: Window;
    VAR argv_return: C_charPtr2d;
    VAR argc_return: C_int): Status;
PROCEDURE XGetWMColormapWindows* (
    display: DisplayPtr;
    w: Window;
    VAR windows_return: WindowPtr1d;
    VAR count_return: C_int): Status;
PROCEDURE XSetWMColormapWindows* (
    display: DisplayPtr;
    w: Window;
    VAR colormap_windows: ARRAY [untagged] OF Window;
    count: C_int): Status;
PROCEDURE XFreeStringList* (
    list: C_charPtr2d);
PROCEDURE XSetTransientForHint* (
    display: DisplayPtr;
    w: Window;
    prop_window: Window);


(* The following are given in alphabetical order *)
PROCEDURE XActivateScreenSaver* (
    display: DisplayPtr);
PROCEDURE XAddHost* (
    display: DisplayPtr;
    host: XHostAddressPtr);
PROCEDURE XAddHosts* (
    display: DisplayPtr;
    hosts: XHostAddressPtr;
    num_hosts: C_int);
PROCEDURE XAddToExtensionList* (
    VAR structure: XExtDataPtr;
    ext_data: XExtDataPtr);  (* ??? mh, don't know if that's correct *)
PROCEDURE XAddToSaveSet* (
    display: DisplayPtr;
    w: Window);
PROCEDURE XAllocColor* (
    display: DisplayPtr;
    colormap: Colormap;
    VAR screen_in_out: XColor): Status;
PROCEDURE XAllocColorCells* (
    display: DisplayPtr;
    colormap: Colormap;
    contig: Bool;
    VAR plane_masks_return: ulongmask;
    nplanes: C_int;
    VAR pixels_return: C_longint;
    npixels: C_int): Status;
PROCEDURE XAllocColorPlanes* (
    display: DisplayPtr;
    colormap: Colormap;
    contig: Bool;
    VAR pixels_return: C_longint;
    ncolors: C_int;
    nreds: C_int;
    ngreens: C_int;
    nblues: C_int;
    VAR rmask_return: ulongmask;
    VAR gmask_return: ulongmask;
    VAR bmask_return: ulongmask): Status;
PROCEDURE XAllocNamedColor* (
    display: DisplayPtr;
    colormap: Colormap;
    color_name: C_string;
    VAR screen_def_return: XColor;
    VAR exact_def_return: XColor): Status;
PROCEDURE XAllowEvents* (
    display: DisplayPtr;
    event_mode: C_int;
    time: Time);
PROCEDURE XAutoRepeatOff* (
    display: DisplayPtr);
PROCEDURE XAutoRepeatOn* (
    display: DisplayPtr);
PROCEDURE XBell* (
    display: DisplayPtr;
    percent: C_int);
PROCEDURE XBitmapBitOrder* (
    display: DisplayPtr): C_int;
PROCEDURE XBitmapPad* (
    display: DisplayPtr): C_int;
PROCEDURE XBitmapUnit* (
    display: DisplayPtr): C_int;
PROCEDURE XCellsOfScreen* (
    screen: ScreenPtr): C_int;
PROCEDURE XChangeActivePointerGrab* (
    display: DisplayPtr;
    event_mask: uintmask;
    cursor: Cursor;
    time: Time);
PROCEDURE XChangeGC* (
    display: DisplayPtr;
    gc: GC;
    valuemask: ulongmask;
    VAR values: XGCValues);
PROCEDURE XChangeKeyboardControl* (
    display: DisplayPtr;
    value_mask: ulongmask;
    VAR values: XKeyboardControl);
PROCEDURE XChangeKeyboardMapping* (
    display: DisplayPtr;
    first_keycode: C_int;
    keysyms_per_keycode: C_int;
    VAR keysyms: ARRAY [untagged] OF KeySym;
    num_codes: C_int);
PROCEDURE XChangePointerControl* (
    display: DisplayPtr;
    do_accel: Bool;
    do_threshold: Bool;
    accel_numerator: C_int;
    accel_denominator: C_int;
    threshold: C_int);
PROCEDURE XChangeProperty* (
    display: DisplayPtr;
    w: Window;
    property: Atom;
    type: Atom;
    format: C_int;
    mode: C_int;
    VAR data: ARRAY [untagged] OF C_char;
    nelements: C_int);
PROCEDURE XChangeSaveSet* (
    display: DisplayPtr;
    w: Window;
    change_mode: C_int);
PROCEDURE XChangeWindowAttributes* (
    display: DisplayPtr;
    w: Window;
    valuemask: ulongmask;
    VAR attributes: XSetWindowAttributes);
PROCEDURE XCheckIfEvent* (
    display: DisplayPtr;
    VAR event_return: XEvent;
    predicate: EventProc;
    arg: XPointer): Bool;
PROCEDURE XCheckMaskEvent* (
    display: DisplayPtr;
    event_mask: ulongmask;
    VAR event_return: XEvent): Bool;
PROCEDURE XCheckTypedEvent* (
    display: DisplayPtr;
    event_type: C_int;
    VAR event_return: XEvent): Bool;
PROCEDURE XCheckTypedWindowEvent* (
    display: DisplayPtr;
    w: Window;
    event_type: C_int;
    VAR event_return: XEvent): Bool;
PROCEDURE XCheckWindowEvent* (
    display: DisplayPtr;
    w: Window;
    event_mask: ulongmask;
    VAR event_return: XEvent): Bool;
PROCEDURE XCirculateSubwindows* (
    display: DisplayPtr;
    w: Window;
    direction: C_int);
PROCEDURE XCirculateSubwindowsDown* (
    display: DisplayPtr;
    w: Window);
PROCEDURE XCirculateSubwindowsUp* (
    display: DisplayPtr;
    w: Window);
PROCEDURE XClearArea* (
    display: DisplayPtr;
    w: Window;
    x: C_int;
    y: C_int;
    width: C_int;
    height: C_int;
    exposures: Bool);
PROCEDURE XClearWindow* (
    display: DisplayPtr;
    w: Window);
PROCEDURE XCloseDisplay* (
    display: DisplayPtr);
PROCEDURE XConfigureWindow* (
    display: DisplayPtr;
    w: Window;
    value_mask: uintmask;
    VAR values: XWindowChanges);
PROCEDURE XConnectionNumber* (
    display: DisplayPtr): C_int;
PROCEDURE XConvertSelection* (
    display: DisplayPtr;
    selection: Atom;
    target: Atom;
    property: Atom;
    requestor: Window;
    time: Time);
PROCEDURE XCopyArea* (
    display: DisplayPtr;
    src: Drawable;
    dest: Drawable;
    gc: GC;
    src_x: C_int;
    src_y: C_int;
    width: C_int;
    height: C_int;
    dest_x: C_int;
    dest_y: C_int);
PROCEDURE XCopyGC* (
    display: DisplayPtr;
    src: GC;
    valuemask: ulongmask;
    dest: GC);
PROCEDURE XCopyPlane* (
    display: DisplayPtr;
    src: Drawable;
    dest: Drawable;
    gc: GC;
    src_x: C_int;
    src_y: C_int;
    width: C_int;
    height: C_int;
    dest_x: C_int;
    dest_y: C_int;
    plane: C_longint);
PROCEDURE XDefaultDepth* (
    display: DisplayPtr;
    screen_number: C_int): C_int;
PROCEDURE XDefaultDepthOfScreen* (
    screen: ScreenPtr): C_int;
PROCEDURE XDefaultScreen* (
    display: DisplayPtr): C_int;
PROCEDURE XDefineCursor* (
    display: DisplayPtr;
    w: Window;
    cursor: Cursor);
PROCEDURE XDeleteProperty* (
    display: DisplayPtr;
    w: Window;
    property: Atom);
PROCEDURE XDestroyWindow* (
    display: DisplayPtr;
    w: Window);
PROCEDURE XDestroySubwindows* (
    display: DisplayPtr;
    w: Window);
PROCEDURE XDoesBackingStore* (
    screen: ScreenPtr): C_int;
PROCEDURE XDoesSaveUnders* (
    screen: ScreenPtr): Bool;
PROCEDURE XDisableAccessControl* (
    display: DisplayPtr);
PROCEDURE XDisplayCells* (
    display: DisplayPtr;
    screen_number: C_int): C_int;
PROCEDURE XDisplayHeight* (
    display: DisplayPtr;
    screen_number: C_int): C_int;
PROCEDURE XDisplayHeightMM* (
    display: DisplayPtr;
    screen_number: C_int): C_int;
PROCEDURE XDisplayKeycodes* (
    display: DisplayPtr;
    VAR min_keycodes_return: C_int;
    VAR max_keycodes_return: C_int);
PROCEDURE XDisplayPlanes* (
    display: DisplayPtr;
    screen_number: C_int): C_int;
PROCEDURE XDisplayWidth* (
    display: DisplayPtr;
    screen_number: C_int): C_int;
PROCEDURE XDisplayWidthMM* (
    display: DisplayPtr;
    screen_number: C_int): C_int;
PROCEDURE XDrawArc* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    x: C_int;
    y: C_int;
    width: C_int;
    height: C_int;
    angle1: C_int;
    angle2: C_int);
PROCEDURE XDrawArcs* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    VAR arcs: ARRAY [untagged] OF XArc;
    narcs: C_int);
PROCEDURE XDrawImageString* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    x: C_int;
    y: C_int;
    string: C_string;
    length: C_int);
PROCEDURE XDrawImageString16* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    x: C_int;
    y: C_int;
(*    string: ARRAY [untagged] OF XChar2b;*)
    string: C_longchar;
    length: C_int);
PROCEDURE XDrawLine* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    x1: C_int;
    x2: C_int;
    y1: C_int;
    y2: C_int);
PROCEDURE XDrawLines* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    VAR points: ARRAY [untagged] OF XPoint;
    npoints: C_int;
    mode: C_int);
PROCEDURE XDrawPoint* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    x: C_int;
    y: C_int);
PROCEDURE XDrawPoints* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    VAR points: ARRAY [untagged] OF XPoint;
    npoints: C_int;
    mode: C_int);
PROCEDURE XDrawRectangle* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    x: C_int;
    y: C_int;
    width: C_int;
    height: C_int);
PROCEDURE XDrawRectangles* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    VAR rectangles: ARRAY [untagged] OF XRectangle;
    nrectangles: C_int);
PROCEDURE XDrawSegments* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    VAR segments: ARRAY [untagged] OF XSegment;
    nsegments: C_int);
PROCEDURE XDrawString* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    x: C_int;
    y: C_int;
    string: C_string;
    length: C_int);
PROCEDURE XDrawString16* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    x: C_int;
    y: C_int;
(*    string: ARRAY [untagged] OF XChar2b;*)
    VAR string: C_longstring;
    length: C_int);
PROCEDURE XDrawText* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    x: C_int;
    y: C_int;
    VAR items: ARRAY [untagged] OF XTextItem;
    nitems: C_int);
PROCEDURE XDrawText16* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    x: C_int;
    y: C_int;
    VAR items: ARRAY [untagged] OF XTextItem16;
    nitems: C_int);
PROCEDURE XEnableAccessControl* (
    display: DisplayPtr);
PROCEDURE XEventsQueued* (
    display: DisplayPtr;
    mode: C_int): C_int;
PROCEDURE XFetchName* (
    display: DisplayPtr;
    w: Window;
    VAR window_name_return: C_string): Status;
PROCEDURE XFillArc* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    x: C_int;
    y: C_int;
    width: C_int;
    height: C_int;
    angle1: C_int;
    angle2: C_int);
PROCEDURE XFillArcs* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    VAR arcs: ARRAY [untagged] OF XArc;
    narcs: C_int);
PROCEDURE XFillPolygon* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    VAR points: ARRAY [untagged] OF XPoint;
    npoints: C_int;
    shape: C_int;
    mode: C_int);
PROCEDURE XFillRectangle* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    x: C_int;
    y: C_int;
    width: C_int;
    height: C_int);
PROCEDURE XFillRectangles* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    VAR rectangles: ARRAY [untagged] OF XRectangle;
    nrectangles: C_int);
PROCEDURE XFlush* (
    display: DisplayPtr);
PROCEDURE XForceScreenSaver* (
    display: DisplayPtr;
    mode: C_int);
PROCEDURE XFree* (data: C_address);
PROCEDURE XFreeColormap* (
    display: DisplayPtr;
    colormap: Colormap);
PROCEDURE XFreeColors* (
    display: DisplayPtr;
    colormap: Colormap;
    VAR pixels: ARRAY [untagged] OF C_longint;
    npixels: C_int;
    planes: C_longint);
PROCEDURE XFreeCursor* (
    display: DisplayPtr;
    cursor: Cursor);
PROCEDURE XFreeExtensionList* (
    list: C_charPtr2d);
PROCEDURE XFreeFont* (
    display: DisplayPtr;
    font_struct: XFontStructPtr);
PROCEDURE XFreeFontInfo* (
    names: C_charPtr2d;
    free_info: XFontStructPtr;
    actual_count: C_int);
PROCEDURE XFreeFontNames* (
    list: C_charPtr2d);
PROCEDURE XFreeFontPath* (
    list: C_charPtr2d);
PROCEDURE XFreeGC* (
    display: DisplayPtr;
    gc: GC);
PROCEDURE XFreeModifiermap* (
    modmap: XModifierKeymapPtr);
PROCEDURE XFreePixmap* (
    display: DisplayPtr;
    pixmap: Pixmap);
PROCEDURE XGeometry* (
    display: DisplayPtr;
    screen: C_int;
    position: C_string;
    default_position: C_string;
    bwidth: C_int;
    fwidth: C_int;
    fheight: C_int;
    xadder: C_int;
    yadder: C_int;
    VAR x_return: C_int;
    VAR y_return: C_int;
    VAR width_return: C_int;
    VAR height_return: C_int): C_int;
PROCEDURE XGetErrorDatabaseText* (
    display: DisplayPtr;
    name: C_string;
    message: C_string;
    default_string: C_string;
    VAR buffer_return: ARRAY [untagged] OF C_char;
    length: C_int);
PROCEDURE XGetErrorText* (
    display: DisplayPtr;
    code: C_int;
    VAR buffer_return: ARRAY [untagged] OF C_char;
    length: C_int);
PROCEDURE XGetFontProperty* (
    font_struct: XFontStructPtr;
    atom: Atom;
    VAR value_return: C_longint): Bool;
PROCEDURE XGetGCValues* (
    display: DisplayPtr;
    gc: GC;
    valuemask: ulongmask;
    VAR values_return: XGCValues): Status;
PROCEDURE XGetGeometry* (
    display: DisplayPtr;
    d: Drawable;
    VAR root_return: Window;
    VAR x_return: C_int;
    VAR y_return: C_int;
    VAR width_return: C_int;
    VAR height_return: C_int;
    VAR border_width_return: C_int;
    VAR depth_return: C_int): Status;
PROCEDURE XGetIconName* (
    display: DisplayPtr;
    w: Window;
    VAR icon_name_return: C_string): Status;
PROCEDURE XGetInputFocus* (
    display: DisplayPtr;
    VAR focus_return: Window;
    VAR revert_to_return: C_int);
PROCEDURE XGetKeyboardControl* (
    display: DisplayPtr;
    VAR values_return: XKeyboardState);
PROCEDURE XGetPointerControl* (
    display: DisplayPtr;
    VAR accel_numerator_return: C_int;
    VAR accel_denominator_return: C_int;
    VAR threshold_return: C_int);
PROCEDURE XGetPointerMapping* (
    display: DisplayPtr;
    VAR map_return: C_char;
    nmap: C_int): C_int;
PROCEDURE XGetScreenSaver* (
    display: DisplayPtr;
    VAR timeout_return: C_int;
    VAR interval_return: C_int;
    VAR prefer_blanking_return: C_int;
    VAR allow_exposures_return: C_int);
PROCEDURE XGetTransientForHint* (
    display: DisplayPtr;
    w: Window;
    VAR prop_window_return: Window): Status;
PROCEDURE XGetWindowProperty* (
    display: DisplayPtr;
    w: Window;
    property: Atom;
    long_offset: C_longint;
    long_length: C_longint;
    delete: Bool;
    req_type: Atom;
    VAR actual_type_return: Atom;
    VAR actual_format_return: C_int;
    VAR nitems_return: C_longint;
    VAR bytes_after_return: C_longint;
    VAR prop_return: C_string): C_int;
PROCEDURE XGetWindowAttributes* (
    display: DisplayPtr;
    w: Window;
    VAR window_attributes_return: XWindowAttributes): Status;
PROCEDURE XGrabButton* (
    display: DisplayPtr;
    button: C_int;
    modifiers: C_int;
    grab_window: Window;
    owner_events: Bool;
    event_mask: uintmask;
    pointer_mode: C_int;
    keyboard_mode: C_int;
    confine_to: Window;
    cursor: Cursor);
PROCEDURE XGrabKey* (
    display: DisplayPtr;
    keycode: C_int;
    modifiers: C_int;
    grab_window: Window;
    owner_events: Bool;
    pointer_mode: C_int;
    keyboard_mode: C_int);
PROCEDURE XGrabKeyboard* (
    display: DisplayPtr;
    grab_window: Window;
    owner_events: Bool;
    pointer_mode: C_int;
    keyboard_mode: C_int;
    time: Time): C_int;
PROCEDURE XGrabPointer* (
    display: DisplayPtr;
    grab_window: Window;
    owner_events: Bool;
    event_mask: uintmask;
    pointer_mode: C_int;
    keyboard_mode: C_int;
    confine_to: Window;
    cursor: Cursor;
    time: Time): C_int;
PROCEDURE XGrabServer* (
    display: DisplayPtr);
PROCEDURE XHeightMMOfScreen* (
    screen: ScreenPtr): C_int;
PROCEDURE XHeightOfScreen* (
    screen: ScreenPtr): C_int;
PROCEDURE XIfEvent* (
    display: DisplayPtr;
    VAR event_return: XEvent;
    predicate: EventProc;
    arg: XPointer);
PROCEDURE XImageByteOrder* (
    display: DisplayPtr): C_int;
PROCEDURE XInstallColormap* (
    display: DisplayPtr;
    colormap: Colormap);
PROCEDURE XKeysymToKeycode* (
    display: DisplayPtr;
    keysym: KeySym): KeyCode;
PROCEDURE XKillClient* (
    display: DisplayPtr;
    resource: XID);
PROCEDURE XLookupColor* (
    display: DisplayPtr;
    colormap: Colormap;
    color_name: C_string;
    VAR exact_def_return: XColor;
    VAR screen_def_return: XColor): Status;
PROCEDURE XLowerWindow* (
    display: DisplayPtr;
    w: Window);
PROCEDURE XMapRaised* (
    display: DisplayPtr;
    w: Window);
PROCEDURE XMapSubwindows* (
    display: DisplayPtr;
    w: Window);
PROCEDURE XMapWindow* (
    display: DisplayPtr;
    w: Window);
PROCEDURE XMaskEvent* (
    display: DisplayPtr;
    event_mask: ulongmask;
    VAR event_return: XEvent);
PROCEDURE XMaxCmapsOfScreen* (
    screen: ScreenPtr): C_int;
PROCEDURE XMinCmapsOfScreen* (
    screen: ScreenPtr): C_int;
PROCEDURE XMoveResizeWindow* (
    display: DisplayPtr;
    w: Window;
    x: C_int;
    y: C_int;
    width: C_int;
    height: C_int);
PROCEDURE XMoveWindow* (
    display: DisplayPtr;
    w: Window;
    x: C_int;
    y: C_int);
PROCEDURE XNextEvent* (
    display: DisplayPtr;
    VAR event_return: XEvent);
PROCEDURE XNoOp* (
    display: DisplayPtr);
PROCEDURE XParseColor* (
    display: DisplayPtr;
    colormap: Colormap;
    VAR spec: C_string;
    VAR exact_def_return: XColor): Status;
PROCEDURE XParseGeometry* (
    VAR parsestring: C_string;
    VAR x_return: C_int;
    VAR y_return: C_int;
    VAR width_return: C_int;
    VAR height_return: C_int): C_int;
PROCEDURE XPeekEvent* (
    display: DisplayPtr;
    VAR event_return: XEvent);
PROCEDURE XPeekIfEvent* (
    display: DisplayPtr;
    VAR event_return: XEvent;
    predicate: EventProc;
    arg: XPointer);
PROCEDURE XPending* (
    display: DisplayPtr): C_int;
PROCEDURE XPlanesOfScreen* (
    screen: ScreenPtr): C_int;
PROCEDURE XProtocolRevision* (
    display: DisplayPtr): C_int;
PROCEDURE XProtocolVersion* (
    display: DisplayPtr): C_int;
PROCEDURE XPutBackEvent* (
    display: DisplayPtr;
    event: XEventPtr);
PROCEDURE XPutImage* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    image: XImagePtr;
    src_x: C_int;
    src_y: C_int;
    dest_x: C_int;
    dest_y: C_int;
    width: C_int;
    height: C_int);
PROCEDURE XQLength* (
    display: DisplayPtr): C_int;
PROCEDURE XQueryBestCursor* (
    display: DisplayPtr;
    d: Drawable;
    width: C_int;
    height: C_int;
    VAR width_return: C_int;
    VAR height_return: C_int): Status;
PROCEDURE XQueryBestSize* (
    display: DisplayPtr;
    class: C_int;
    which_screen: Drawable;
    width: C_int;
    height: C_int;
    VAR width_return: C_int;
    VAR height_return: C_int): Status;
PROCEDURE XQueryBestStipple* (
    display: DisplayPtr;
    which_screen: Drawable;
    width: C_int;
    height: C_int;
    VAR width_return: C_int;
    VAR height_return: C_int): Status;
PROCEDURE XQueryBestTile* (
    display: DisplayPtr;
    which_screen: Drawable;
    width: C_int;
    height: C_int;
    VAR width_return: C_int;
    VAR height_return: C_int): Status;
PROCEDURE XQueryColor* (
    display: DisplayPtr;
    colormap: Colormap;
    VAR def_in_out: XColor);
PROCEDURE XQueryColors* (
    display: DisplayPtr;
    colormap: Colormap;
    VAR defs_in_out: ARRAY [untagged] OF XColor;
    ncolors: C_int);
PROCEDURE XQueryExtension* (
    display: DisplayPtr;
    VAR name: C_string;
    VAR major_opcode_return: C_int;
    VAR first_event_return: C_int;
    VAR first_error_return: C_int): Bool;
PROCEDURE XQueryKeymap* (
    display: DisplayPtr;
    VAR keys_return: ARRAY [untagged] (*32*) OF C_char);
PROCEDURE XQueryPointer* (
    display: DisplayPtr;
    w: Window;
    VAR root_return: Window;
    VAR child_return: Window;
    VAR root_x_return: C_int;
    VAR root_y_return: C_int;
    VAR win_x_return: C_int;
    VAR win_y_return: C_int;
    VAR mask_return: uintmask): Bool;
PROCEDURE XQueryTextExtents* (
    display: DisplayPtr;
    font_ID: XID;
    string: C_string;
    nchars: C_int;
    VAR direction_return: C_int;
    VAR font_ascent_return: C_int;
    VAR font_descent_return: C_int;
    VAR overall_return: XCharStruct);
PROCEDURE XQueryTextExtents16* (
    display: DisplayPtr;
    font_ID: XID;
(*    string: ARRAY [untagged] OF XChar2b;*)
    string: C_longstring;
    nchars: C_int;
    VAR direction_return: C_int;
    VAR font_ascent_return: C_int;
    VAR font_descent_return: C_int;
    VAR overall_return: XCharStruct);
PROCEDURE XQueryTree* (
    display: DisplayPtr;
    w: Window;
    VAR root_return: Window;
    VAR parent_return: Window;
    VAR children_return: WindowPtr1d;
    VAR nchildren_return: C_int): Status;
PROCEDURE XRaiseWindow* (
    display: DisplayPtr;
    w: Window);
PROCEDURE XReadBitmapFile* (
    display: DisplayPtr;
    d: Drawable;
    filename: C_string;
    VAR width_return: C_int;
    VAR height_return: C_int;
    VAR bitmap_return: Pixmap;
    VAR x_hot_return: C_int;
    VAR y_hot_return: C_int): C_int;
PROCEDURE XReadBitmapFileData* (
    filename: C_string;
    VAR width_return: C_int;
    VAR height_return: C_int;
    VAR data_return: C_address;
    VAR x_hot_return: C_int;
    VAR y_hot_return: C_int): C_int;
PROCEDURE XRebindKeysym* (
    display: DisplayPtr;
    keysym: KeySym;
    VAR list: ARRAY [untagged] OF KeySym;
    mod_count: C_int;
    string: C_string;
    bytes_string: C_int);
PROCEDURE XRecolorCursor* (
    display: DisplayPtr;
    cursor: Cursor;
    VAR foreground_color: XColor;
    VAR background_color: XColor);
PROCEDURE XRefreshKeyboardMapping* (
    event_map: XMappingEventPtr);
PROCEDURE XRemoveFromSaveSet* (
    display: DisplayPtr;
    w: Window);
PROCEDURE XRemoveHost* (
    display: DisplayPtr;
    host: XHostAddressPtr);
PROCEDURE XRemoveHosts* (
    display: DisplayPtr;
    VAR hosts: ARRAY [untagged] OF XHostAddress;
    num_hosts: C_int);
PROCEDURE XReparentWindow* (
    display: DisplayPtr;
    w: Window;
    parent: Window;
    x: C_int;
    y: C_int);
PROCEDURE XResetScreenSaver* (
    display: DisplayPtr);
PROCEDURE XResizeWindow* (
    display: DisplayPtr;
    w: Window;
    width: C_int;
    height: C_int);
PROCEDURE XRestackWindows* (
    display: DisplayPtr;
    VAR windows: ARRAY [untagged] OF Window;
    nwindows: C_int);
PROCEDURE XRotateBuffers* (
    display: DisplayPtr;
    rotate: C_int);
PROCEDURE XRotateWindowProperties* (
    display: DisplayPtr;
    w: Window;
    VAR properties: ARRAY [untagged] OF Atom;
    num_prop: C_int;
    npositions: C_int);
PROCEDURE XScreenCount* (
    display: DisplayPtr): C_int;
PROCEDURE XSelectInput* (
    display: DisplayPtr;
    w: Window;
    event_mask: ulongmask);
PROCEDURE XSendEvent* (
    display: DisplayPtr;
    w: Window;
    propagate: Bool;
    event_mask: ulongmask;
    event_send: XEventPtr): Status;
PROCEDURE XSetAccessControl* (
    display: DisplayPtr;
    mode: C_int);
PROCEDURE XSetArcMode* (
    display: DisplayPtr;
    gc: GC;
    arc_mode: C_int);
PROCEDURE XSetBackground* (
    display: DisplayPtr;
    gc: GC;
    background: C_longint);
PROCEDURE XSetClipMask* (
    display: DisplayPtr;
    gc: GC;
    pixmap: Pixmap);
PROCEDURE XSetClipOrigin* (
    display: DisplayPtr;
    gc: GC;
    clip_x_origin: C_int;
    clip_y_origin: C_int);
PROCEDURE XSetClipRectangles* (
    display: DisplayPtr;
    gc: GC;
    clip_x_origin: C_int;
    clip_y_origin: C_int;
    rectangles: XRectanglePtr;
    n: C_int;
    ordering: C_int);
PROCEDURE XSetCloseDownMode* (
    display: DisplayPtr;
    close_mode: C_int);
PROCEDURE XSetCommand* (
    display: DisplayPtr;
    w: Window;
    argv: C_charPtr2d;
    argc: C_int);
PROCEDURE XSetDashes* (
    display: DisplayPtr;
    gc: GC;
    dash_offset: C_int;
    VAR dash_list: ARRAY [untagged] OF C_char;
    n: C_int);
PROCEDURE XSetFillRule* (
    display: DisplayPtr;
    gc: GC;
    fill_rule: C_int);
PROCEDURE XSetFillStyle* (
    display: DisplayPtr;
    gc: GC;
    fill_style: C_int);
PROCEDURE XSetFont* (
    display: DisplayPtr;
    gc: GC;
    font: Font);
PROCEDURE XSetFontPath* (
    display: DisplayPtr;
    directories: C_charPtr2d;
    ndirs: C_int);
PROCEDURE XSetForeground* (
    display: DisplayPtr;
    gc: GC;
    foreground: C_longint);
PROCEDURE XSetFunction* (
    display: DisplayPtr;
    gc: GC;
    function: C_int);
PROCEDURE XSetGraphicsExposures* (
    display: DisplayPtr;
    gc: GC;
    graphics_exposures: Bool);
PROCEDURE XSetIconName* (
    display: DisplayPtr;
    w: Window;
    VAR icon_name: ARRAY [untagged] OF C_char);
PROCEDURE XSetInputFocus* (
    display: DisplayPtr;
    focus: Window;
    revert_to: C_int;
    time: Time);
PROCEDURE XSetLineAttributes* (
    display: DisplayPtr;
    gc: GC;
    line_width: C_int;
    line_style: C_int;
    cap_style: C_int;
    join_style: C_int);
PROCEDURE XSetModifierMapping* (
    display: DisplayPtr;
    modmap: XModifierKeymapPtr): C_int;
PROCEDURE XSetPlaneMask* (
    display: DisplayPtr;
    gc: GC;
    plane_mask: ulongmask);
PROCEDURE XSetPointerMapping* (
    display: DisplayPtr;
    VAR map: ARRAY [untagged] OF C_char;
    nmap: C_int): C_int;
PROCEDURE XSetScreenSaver* (
    display: DisplayPtr;
    timeout: C_int;
    interval: C_int;
    prefer_blanking: C_int;
    allow_exposures: C_int);
PROCEDURE XSetSelectionOwner* (
    display: DisplayPtr;
    selection: Atom;
    owner: Window;
    time: Time);
PROCEDURE XSetState* (
    display: DisplayPtr;
    gc: GC;
    foreground: C_longint;
    background: C_longint;
    function: C_int;
    plane_mask: ulongmask);
PROCEDURE XSetStipple* (
    display: DisplayPtr;
    gc: GC;
    stipple: Pixmap);
PROCEDURE XSetSubwindowMode* (
    display: DisplayPtr;
    gc: GC;
    subwindow_mode: C_int);
PROCEDURE XSetTSOrigin* (
    display: DisplayPtr;
    gc: GC;
    ts_x_origin: C_int;
    ts_y_origin: C_int);
PROCEDURE XSetTile* (
    display: DisplayPtr;
    gc: GC;
    tile: Pixmap);
PROCEDURE XSetWindowBackground* (
    display: DisplayPtr;
    w: Window;
    background_pixel: C_longint);
PROCEDURE XSetWindowBackgroundPixmap* (
    display: DisplayPtr;
    w: Window;
    background_pixmap: Pixmap);
PROCEDURE XSetWindowBorder* (
    display: DisplayPtr;
    w: Window;
    border_pixel: C_longint);
PROCEDURE XSetWindowBorderPixmap* (
    display: DisplayPtr;
    w: Window;
    border_pixmap: Pixmap);
PROCEDURE XSetWindowBorderWidth* (
    display: DisplayPtr;
    w: Window;
    width: C_int);
PROCEDURE XSetWindowColormap* (
    display: DisplayPtr;
    w: Window;
    colormap: Colormap);
PROCEDURE XStoreBuffer* (
    display: DisplayPtr;
    VAR bytes: ARRAY [untagged] OF C_char;
    nbytes: C_int;
    buffer: C_int);
PROCEDURE XStoreBytes* (
    display: DisplayPtr;
    VAR bytes: ARRAY [untagged] OF C_char;
    nbytes: C_int);
PROCEDURE XStoreColor* (
    display: DisplayPtr;
    colormap: Colormap;
    VAR color: XColor);
PROCEDURE XStoreColors* (
    display: DisplayPtr;
    colormap: Colormap;
    VAR color: ARRAY [untagged] OF XColor;
    ncolors: C_int);
PROCEDURE XStoreName* (
    display: DisplayPtr;
    w: Window;
    window_name: C_string);
PROCEDURE XStoreNamedColor* (
    display: DisplayPtr;
    colormap: Colormap;
    color: C_string;
    pixel: C_longint;
    flags: uintmask);
PROCEDURE XSync* (
    display: DisplayPtr;
    discard: Bool);
PROCEDURE XTextExtents* (
    font_struct: XFontStructPtr;
    string: C_string;
    nchars: C_int;
    VAR direction_return: C_int;
    VAR font_ascent_return: C_int;
    VAR font_descent_return: C_int;
    VAR overall_return: XCharStruct);
PROCEDURE XTextExtents16* (
    font_struct: XFontStructPtr;
(*    string: ARRAY [untagged] OF XChar2b;*)
    string: C_longstring;
    nchars: C_int;
    VAR direction_return: C_int;
    VAR font_ascent_return: C_int;
    VAR font_descent_return: C_int;
    VAR overall_return: XCharStruct);
PROCEDURE XTextWidth* (
    font_struct: XFontStructPtr;
    string: C_string;
    count: C_int): C_int;
PROCEDURE XTextWidth16* (
    font_struct: XFontStructPtr;
(*    string: ARRAY [untagged] OF XChar2b;*)
    string: C_longstring;
    count: C_int): C_int;
PROCEDURE XTranslateCoordinates* (
    display: DisplayPtr;
    src_w: Window;
    dest_w: Window;
    src_x: C_int;
    src_y: C_int;
    VAR dest_x_return: C_int;
    VAR dest_y_return: C_int;
    VAR child_return: Window): Bool;
PROCEDURE XUndefineCursor* (
    display: DisplayPtr;
    w: Window);
PROCEDURE XUngrabButton* (
    display: DisplayPtr;
    button: C_int;
    modifiers: C_int;
    grab_window: Window);
PROCEDURE XUngrabKey* (
    display: DisplayPtr;
    keycode: C_int;
    modifiers: C_int;
    grab_window: Window);
PROCEDURE XUngrabKeyboard* (
    display: DisplayPtr;
    time: Time);
PROCEDURE XUngrabPointer* (
    display: DisplayPtr;
    time: Time);
PROCEDURE XUngrabServer* (
    display: DisplayPtr);
PROCEDURE XUninstallColormap* (
    display: DisplayPtr;
    colormap: Colormap);
PROCEDURE XUnloadFont* (
    display: DisplayPtr;
    font: Font);
PROCEDURE XUnmapSubwindows* (
    display: DisplayPtr;
    w: Window);
PROCEDURE XUnmapWindow* (
    display: DisplayPtr;
    w: Window);
PROCEDURE XVendorRelease* (
    display: DisplayPtr): C_int;
PROCEDURE XWarpPointer* (
    display: DisplayPtr;
    src_w: Window;
    dest_w: Window;
    src_x: C_int;
    src_y: C_int;
    src_width: C_int;
    src_height: C_int;
    dest_x: C_int;
    dest_y: C_int);
PROCEDURE XWidthMMOfScreen* (
    screen: ScreenPtr): C_int;
PROCEDURE XWidthOfScreen* (
    screen: ScreenPtr): C_int;
PROCEDURE XWindowEvent* (
    display: DisplayPtr;
    w: Window;
    event_mask: ulongmask;
    VAR event_return: XEvent);
PROCEDURE XWriteBitmapFile* (
    display: DisplayPtr;
    filename: C_string;
    bitmap: Pixmap;
    width: C_int;
    height: C_int;
    x_hot: C_int;
    y_hot: C_int): C_int;
PROCEDURE XSupportsLocale* (): Bool;
PROCEDURE XSetLocaleModifiers* (
    modifier_list: C_string): C_string;
PROCEDURE XOpenOM* (
    display: DisplayPtr;
    rdb: XrmHashBucketRecPtr;
    res_name: C_string;
    res_class: C_string): XOM;
PROCEDURE XCloseOM* (
    om: XOM): Status;
(*
PROCEDURE XSetOMValues* (
    om: XOM;
    ...): C_string;
PROCEDURE XGetOMValues* (
    om: XOM;
    ...): C_string;
*)
PROCEDURE XDisplayOfOM* (
    om: XOM): DisplayPtr;
PROCEDURE XLocaleOfOM* (
    om: XOM): C_string;
(*
PROCEDURE XCreateOC* (
    om: XOM;
    ...): XOC;
*)
PROCEDURE XDestroyOC* (
    oc: XOC);
PROCEDURE XOMOfOC* (
    oc: XOC): XOM;
(*
PROCEDURE XSetOCValues* (
    oc: XOC;
    ...): C_string;
PROCEDURE XGetOCValues* (
    oc: XOC;
    ...): C_string;
*)
PROCEDURE XCreateFontSet* (
    display: DisplayPtr;
    base_font_name_list: C_string;
    VAR missing_charset_list: C_charPtr2d;
    VAR missing_charset_count: C_int;
    VAR def_string: C_string): XFontSet;
PROCEDURE XFreeFontSet* (
    display: DisplayPtr;
    font_set: XFontSet);
PROCEDURE XFontsOfFontSet* (
    font_set: XFontSet;
    VAR font_struct_list: XFontStructPtr1d;
    VAR font_name_list: C_charPtr2d): C_int;
PROCEDURE XBaseFontNameListOfFontSet* (
    font_set: XFontSet): C_string;
PROCEDURE XLocaleOfFontSet* (
    font_set: XFontSet): C_string;
PROCEDURE XContextDependentDrawing* (
    font_set: XFontSet): Bool;
PROCEDURE XDirectionalDependentDrawing* (
    font_set: XFontSet): Bool;
PROCEDURE XContextualDrawing* (
    font_set: XFontSet): Bool;
PROCEDURE XExtentsOfFontSet* (
    font_set: XFontSet): XFontSetExtentsPtr;
PROCEDURE XmbTextEscapement* (
    font_set: XFontSet;
    text: C_string;
    bytes_text: C_int): C_int;
PROCEDURE XwcTextEscapement* (
    font_set: XFontSet;
    text: C_string;
    num_wchars: C_int): C_int;
PROCEDURE XmbTextExtents* (
    font_set: XFontSet;
    text: C_string;
    bytes_text: C_int;
    VAR overall_ink_return: XRectangle;
    VAR overall_logical_return: XRectangle): C_int;
PROCEDURE XwcTextExtents* (
    font_set: XFontSet;
    text: C_string;
    num_wchars: C_int;
    VAR overall_ink_return: XRectangle;
    VAR overall_logical_return: XRectangle): C_int;
PROCEDURE XmbTextPerCharExtents* (
    font_set: XFontSet;
    text: C_string;
    bytes_text: C_int;
    VAR ink_extents_buffer: ARRAY [untagged] OF XRectangle;
    VAR logical_extents_buffer: ARRAY [untagged] OF XRectangle;
    buffer_size: C_int;
    VAR num_chars: C_int;
    VAR overall_ink_return: XRectangle;
    VAR overall_logical_return: XRectangle): Status;
PROCEDURE XwcTextPerCharExtents* (
    font_set: XFontSet;
    text: C_longstring;
    num_wchars: C_int;
    VAR ink_extents_buffer: ARRAY [untagged] OF XRectangle;
    VAR logical_extents_buffer: ARRAY [untagged] OF XRectangle;
    buffer_size: C_int;
    VAR num_chars: C_int;
    VAR overall_ink_return: XRectangle;
    VAR overall_logical_return: XRectangle): Status;
PROCEDURE XmbDrawText* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    x: C_int;
    y: C_int;
    VAR text_items: ARRAY [untagged] OF XmbTextItem;
    nitems: C_int);
PROCEDURE XwcDrawText* (
    display: DisplayPtr;
    d: Drawable;
    gc: GC;
    x: C_int;
    y: C_int;
    VAR text_items: ARRAY [untagged] OF XwcTextItem;
    nitems: C_int);
PROCEDURE XmbDrawString* (
    display: DisplayPtr;
    d: Drawable;
    font_set: XFontSet;
    gc: GC;
    x: C_int;
    y: C_int;
    text: C_string;
    bytes_text: C_int);
PROCEDURE XwcDrawString* (
    display: DisplayPtr;
    d: Drawable;
    font_set: XFontSet;
    gc: GC;
    x: C_int;
    y: C_int;
    text: C_longstring;
    num_wchars: C_int);
PROCEDURE XmbDrawImageString* (
    display: DisplayPtr;
    d: Drawable;
    font_set: XFontSet;
    gc: GC;
    x: C_int;
    y: C_int;
    text: C_string;
    bytes_text: C_int);
PROCEDURE XwcDrawImageString* (
    display: DisplayPtr;
    d: Drawable;
    font_set: XFontSet;
    gc: GC;
    x: C_int;
    y: C_int;
    text: C_longstring;
    num_wchars: C_int);
PROCEDURE XOpenIM* (
    dpy: DisplayPtr;
    rdb: XrmHashBucketRecPtr;
    res_name: C_string;
    res_class: C_string): XIM;
PROCEDURE XCloseIM* (
    im: XIM): Status;
(*
PROCEDURE XGetIMValues* (
    im: XIM;
    ...): C_string;
*)
PROCEDURE XDisplayOfIM* (
    im: XIM): DisplayPtr;
PROCEDURE XLocaleOfIM* (
    im: XIM): C_string;
(*
PROCEDURE XCreateIC* (
    im: XIM;
    ...): XIC;
*)
PROCEDURE XDestroyIC* (
    ic: XIC);
PROCEDURE XSetICFocus* (
    ic: XIC);
PROCEDURE XUnsetICFocus* (
    ic: XIC);
PROCEDURE XwcResetIC* (
    ic: XIC): C_string;
PROCEDURE XmbResetIC* (
    ic: XIC): C_string;
(*
PROCEDURE XSetICValues* (
    ic: XIC;
    ...): C_string;
PROCEDURE XGetICValues* (
    ic: XIC;
    ...): C_string;
*)
PROCEDURE XIMOfIC* (
    ic: XIC): XIM;
PROCEDURE XFilterEvent* (
    event: XEventPtr;
    window: Window): Bool;
PROCEDURE XmbLookupString* (
    ic: XIC;
    VAR event: XKeyPressedEvent;
    VAR buffer_return: ARRAY [untagged] OF C_char;
    bytes_buffer: C_int;
    VAR keysym_return: KeySym;
    VAR status_return: Status): C_int;
PROCEDURE XwcLookupString* (
    ic: XIC;
    VAR event: XKeyPressedEvent;
    VAR buffer_return: wchar_t;
    wchars_buffer: C_int;
    VAR keysym_return: KeySym;
    VAR status_return: Status): C_int;
(*
PROCEDURE XVaCreateNestedList* (
    unused: C_int;
    ...): XVaNestedList;
*)

(* internal connections for IMs *)
PROCEDURE XRegisterIMInstantiateCallback* (
    dpy: DisplayPtr;
    rdb: XrmHashBucketRecPtr;
    res_name: C_string;
    res_class: C_string;
    callback: XIMProc;
    VAR client_data: ARRAY [untagged] OF XPointer): Bool;
PROCEDURE XUnregisterIMInstantiateCallback* (
    dpy: DisplayPtr;
    rdb: XrmHashBucketRecPtr;
    res_name: C_string;
    res_class: C_string;
    callback: XIMProc;
    VAR client_data: ARRAY [untagged] OF XPointer): Bool;
PROCEDURE XInternalConnectionNumbers* (
    dpy: DisplayPtr;
    VAR fd_return: C_intPtr1d;
    VAR count_return: C_int): Status;
PROCEDURE XProcessInternalConnection* (
    dpy: DisplayPtr;
    fd: C_int);
PROCEDURE XAddConnectionWatch* (
    dpy: DisplayPtr;
    callback: XConnectionWatchProc;
    client_data: XPointer): Status;
PROCEDURE XRemoveConnectionWatch* (
    dpy: DisplayPtr;
    callback: XConnectionWatchProc;
    client_data: XPointer);

END X11.
