MODULE [foreign] Xutil;

IMPORT
  X := X11;

(*
 * Bitmask returned by XParseGeometry().  Each bit tells if the corresponding
 * value (x, y, width, height) was found in the parsed string.
 *)
CONST
  NoValue* = 00000H;
  XValue* = 00001H;
  YValue* = 00002H;
  WidthValue* = 00004H;
  HeightValue* = 00008H;
  AllValues* = 0000FH;
  XNegative* = 00010H;
  YNegative* = 00020H;

(*
 * new version containing base_width, base_height, and win_gravity fields;
 * used with WM_NORMAL_HINTS.
 *)
TYPE
  XSizeHintsPtr* = POINTER TO XSizeHints;
  XSizeHints* = RECORD [untagged]
    flags*: X.ulongmask;        (* marks which fields in this structure are defined *)
    x*, y*: X.C_int;              (* obsolete for new window mgrs, but clients *)
    width*, height*: X.C_int;     (* should set so old wm's don't mess up *)
    min_width*, min_height*: X.C_int;
    max_width*, max_height*: X.C_int;
    width_inc*, height_inc*: X.C_int;
    min_aspect*, max_aspect*: RECORD [untagged]
      x*: X.C_int;                (* numerator *)
      y*: X.C_int;                (* denominator *)
    END;
    base_width*, base_height*: X.C_int;(* added by ICCCM version 1 *)
    win_gravity*: X.C_int;        (* added by ICCCM version 1 *)
  END;

(*
 * The next block of definitions are for window manager properties that
 * clients and applications use for communication.
 *)
CONST
(* flags argument in size hints *)
  USPosition* = {0};            (* user specified x, y *)
  USSize* = {1};                (* user specified width, height *)
  PPosition* = {2};             (* program specified position *)
  PSize* = {3};                 (* program specified size *)
  PMinSize* = {4};              (* program specified minimum size *)
  PMaxSize* = {5};              (* program specified maximum size *)
  PResizeInc* = {6};            (* program specified resize increments *)
  PAspect* = {7};               (* program specified min and max aspect ratios *)
  PBaseSize* = {8};             (* program specified base for incrementing *)
  PWinGravity* = {9};           (* program specified window gravity *)
(* obsolete *)
  PAllHints* = PPosition+PSize+PMinSize+PMaxSize+PResizeInc+PAspect;

TYPE
  XWMHintsPtr* = POINTER TO XWMHints;
  XWMHints* = RECORD [untagged]
    flags*: X.ulongmask;(* marks which fields in this structure are defined *)
    input*: X.Bool;   (* does this application rely on the window manager to
			get keyboard input? *)
    initial_state*: X.C_int;        (* see below *)
    icon_pixmap*: X.Pixmap;       (* pixmap to be used as icon *)
    icon_window*: X.Window;       (* window to be used as icon *)
    icon_x*, icon_y*: X.C_int;      (* initial position of icon *)
    icon_mask*: X.Pixmap;         (* icon mask bitmap *)
    window_group*: X.XID;         (* id of related window group *)
  END;

CONST
(* definition for flags of XWMHints *)
  InputHint* = {0};
  StateHint* = {1};
  IconPixmapHint* = {2};
  IconWindowHint* = {3};
  IconPositionHint* = {4};
  IconMaskHint* = {5};
  WindowGroupHint* = {6};
  AllHints* = InputHint+StateHint+IconPixmapHint+IconWindowHint+IconPositionHint+IconMaskHint+WindowGroupHint;
  XUrgencyHint* = {8};
(* definitions for initial window state *)
  WithdrawnState* = 0;          (* for windows that are not mapped *)
  NormalState* = 1;             (* most applications want to start this way *)
  IconicState* = 3;             (* application wants to start as an icon *)

(*
 * Obsolete states no longer defined by ICCCM
 *)
CONST
  DontCareState* = 0;           (* don't know or care *)
  ZoomState* = 2;               (* application wants to start zoomed *)
  InactiveState* = 4;           (* application believes it is seldom used; *)
                                (* some wm's may put it on inactive menu *)
(*
 * new structure for manipulating TEXT properties; used with WM_NAME,
 * WM_ICON_NAME, WM_CLIENT_MACHINE, and WM_COMMAND.
 *)
TYPE
  XTextPropertyPtr* = POINTER TO XTextProperty;
  XTextProperty* = RECORD [untagged]
    value*: X.C_string;        (* same as Property routines *)
    encoding*: X.Atom;          (* prop type *)
    format*: X.C_int;             (* prop data format: 8, 16, or 32 *)
    nitems*: X.C_longint;         (* number of data items in value *)
  END;

CONST
  XNoMemory* = 1;
  XLocaleNotSupported* = 2;
  XConverterNotFound* = 3;

CONST  (* enum XICCEncodingStyle *)
  XStringStyle* = 0;
  XCompoundTextStyle* = 1;
  XTextStyle* = 2;
  XStdICCTextStyle* = 3;

TYPE
  XICCEncodingStyle* = X.C_enum1;
  XIconSizePtr* = POINTER TO XIconSize;
  XIconSize* = RECORD [untagged]
    min_width*, min_height*: X.C_int;
    max_width*, max_height*: X.C_int;
    width_inc*, height_inc*: X.C_int;
  END;
  XClassHintPtr* = POINTER TO XClassHint;
  XClassHint* = RECORD [untagged]
    res_name*: X.C_string;
    res_class*: X.C_string;
  END;

(*
 * These macros are used to give some sugar to the image routines so that
 * naive people are more comfortable with them.
 *)
(* can't define any macros here *)

(*
 * Compose sequence status structure, used in calling XLookupString.
 *)
TYPE
  XComposeStatusPtr* = POINTER TO XComposeStatus;
  XComposeStatus* = RECORD [untagged]
    compose_ptr*: X.XPointer;     (* state table pointer *)
    chars_matched*: X.C_int;      (* match state *)
  END;

(*
 * Keysym macros, used on Keysyms to test for classes of symbols
 *)
(* can't define any macros here *)

(*
 * opaque reference to Region data type
 *)
TYPE
  XRegion* = RECORD [untagged] END;
  Region* = POINTER TO XRegion;

(* Return values from XRectInRegion() *)
CONST
  RectangleOut* = 0;
  RectangleIn* = 1;
  RectanglePart* = 2;

(*
 * Information used by the visual utility routines to find desired visual
 * type from the many visuals a display may support.
 *)
TYPE
  XVisualInfoPtr* = POINTER TO XVisualInfo;
  XVisualInfo* = RECORD [untagged]
    visual*: X.VisualPtr;
    visualid*: X.VisualID;
    screen*: X.C_int;
    depth*: X.C_int;
    class*: X.C_int;
    red_mask*: X.ulongmask;
    green_mask*: X.ulongmask;
    blue_mask*: X.ulongmask;
    colormap_size*: X.C_int;
    bits_per_rgb*: X.C_int;
  END;

CONST
  VisualNoMask* = 00H;
  VisualIDMask* = 01H;
  VisualScreenMask* = 02H;
  VisualDepthMask* = 04H;
  VisualClassMask* = 08H;
  VisualRedMaskMask* = 010H;
  VisualGreenMaskMask* = 020H;
  VisualBlueMaskMask* = 040H;
  VisualColormapSizeMask* = 080H;
  VisualBitsPerRGBMask* = 0100H;
  VisualAllMask* = 01FFH;

(*
 * This defines a window manager property that clients may use to
 * share standard color maps of type RGB_COLOR_MAP:
 *)
TYPE
  XStandardColormapPtr* = POINTER TO XStandardColormap;
  XStandardColormap* = RECORD [untagged]
    colormap*: X.Colormap;
    red_max*: X.C_longint;
    red_mult*: X.C_longint;
    green_max*: X.C_longint;
    green_mult*: X.C_longint;
    blue_max*: X.C_longint;
    blue_mult*: X.C_longint;
    base_pixel*: X.C_longint;
    visualid*: X.VisualID;        (* added by ICCCM version 1 *)
    killid*: X.XID;               (* added by ICCCM version 1 *)
  END;

CONST
  ReleaseByFreeingColormap* = 1;(* for killid field above *)

(*
 * return codes for XReadBitmapFile and XWriteBitmapFile
 *)
CONST
  BitmapSuccess* = 0;
  BitmapOpenFailed* = 1;
  BitmapFileInvalid* = 2;
  BitmapNoMemory* = 3;


(****************************************************************
 *
 * Context Management
 *
 ****************************************************************)
(* Associative lookup table return codes *)
CONST
  XCSUCCESS* = 0;               (* No error. *)
  XCNOMEM* = 1;                 (* Out of memory *)
  XCNOENT* = 2;                 (* No entry in table *)

TYPE
  XContext* = X.C_int;


(* The following declarations are alphabetized. *)
PROCEDURE XAllocClassHint* (): XClassHintPtr;
PROCEDURE XAllocIconSize* (): XIconSizePtr;
PROCEDURE XAllocSizeHints* (): XSizeHintsPtr;
PROCEDURE XAllocStandardColormap* (): XStandardColormapPtr;
PROCEDURE XAllocWMHints* (): XWMHintsPtr;
PROCEDURE XClipBox* (
    r: Region;
    VAR rect_return: X.XRectangle);
PROCEDURE XCreateRegion* (): Region;
PROCEDURE XDefaultString* (): X.C_string;
PROCEDURE XDeleteContext* (
    display: X.DisplayPtr;
    rid: X.XID;
    context: XContext): X.C_int;
PROCEDURE XDestroyRegion* (
    r: Region);
PROCEDURE XEmptyRegion* (
    r: Region);
PROCEDURE XEqualRegion* (
    r1: Region;
    r2: Region);
PROCEDURE XFindContext* (
    display: X.DisplayPtr;
    rid: X.XID;
    context: XContext;
    VAR data_return: X.XPointer): X.C_int;
PROCEDURE XGetClassHint* (
    display: X.DisplayPtr;
    w: X.Window;
    VAR class_hints_return: XClassHint): X.Status;
PROCEDURE XGetIconSizes* (
    display: X.DisplayPtr;
    w: X.Window;
    VAR size_list_return: XIconSize;
    VAR count_return: X.C_int): X.Status;
PROCEDURE XGetNormalHints* (
    display: X.DisplayPtr;
    w: X.Window;
    VAR hints_return: XSizeHints): X.Status;
PROCEDURE XGetRGBColormaps* (
    display: X.DisplayPtr;
    w: X.Window;
    VAR stdcmap_return: XStandardColormap;
    VAR count_return: X.C_int;
    property: X.Atom): X.Status;
PROCEDURE XGetSizeHints* (
    display: X.DisplayPtr;
    w: X.Window;
    VAR hints_return: XSizeHints;
    property: X.Atom): X.Status;
PROCEDURE XGetStandardColormap* (
    display: X.DisplayPtr;
    w: X.Window;
    VAR colormap_return: XStandardColormap;
    property: X.Atom): X.Status;
PROCEDURE XGetTextProperty* (
    display: X.DisplayPtr;
    window: X.Window;
    VAR text_prop_return: XTextProperty;
    property: X.Atom): X.Status;
PROCEDURE XGetVisualInfo* (
    display: X.DisplayPtr;
    vinfo_mask: X.ulongmask;
    vinfo_template: XVisualInfoPtr;
    VAR nitems_return: X.C_int): XVisualInfoPtr;
PROCEDURE XGetWMClientMachine* (
    display: X.DisplayPtr;
    w: X.Window;
    VAR text_prop_return: XTextProperty): X.Status;
PROCEDURE XGetWMHints* (
    display: X.DisplayPtr;
    w: X.Window): XWMHintsPtr;
PROCEDURE XGetWMIconName* (
    display: X.DisplayPtr;
    w: X.Window;
    VAR text_prop_return: XTextProperty): X.Status;
PROCEDURE XGetWMName* (
    display: X.DisplayPtr;
    w: X.Window;
    VAR text_prop_return: XTextProperty): X.Status;
PROCEDURE XGetWMNormalHints* (
    display: X.DisplayPtr;
    w: X.Window;
    VAR hints_return: XSizeHints;
    VAR supplied_return: X.C_longint): X.Status;
PROCEDURE XGetWMSizeHints* (
    display: X.DisplayPtr;
    w: X.Window;
    VAR hints_return: XSizeHints;
    VAR supplied_return: X.C_longint;
    property: X.Atom): X.Status;
PROCEDURE XGetZoomHints* (
    display: X.DisplayPtr;
    w: X.Window;
    VAR zhints_return: XSizeHints): X.Status;
PROCEDURE XIntersectRegion* (
    sra, srb, dr_return: Region);  (* ??? *)
PROCEDURE XConvertCase* (
    sym: X.KeySym;
    VAR lower: X.KeySym;
    VAR upper: X.KeySym);
PROCEDURE XLookupString* (
    VAR event_struct: X.XKeyEvent;
    VAR buffer_return: ARRAY [untagged] OF X.C_char;
    bytes_buffer: X.C_int;
    VAR keysym_return: X.KeySym;
    (* VAR [nil] status_in_out: XComposeStatus): X.C_int; *)
    status_in_out: XComposeStatusPtr): X.C_int;
PROCEDURE XMatchVisualInfo* (
    display: X.DisplayPtr;
    screen: X.C_int;
    depth: X.C_int;
    class: X.C_int;
    VAR vinfo_return: XVisualInfo): X.Status;
PROCEDURE XOffsetRegion* (
    r: Region;
    dx: X.C_int;
    dy: X.C_int);
PROCEDURE XPointInRegion* (
    r: Region;
    x: X.C_int;
    y: X.C_int): X.Bool;
PROCEDURE XPolygonRegion* (
    VAR points: ARRAY [untagged] OF X.XPoint;
    n: X.C_int;
    fill_rule: X.C_int): Region;
PROCEDURE XRectInRegion* (
    r: Region;
    x: X.C_int;
    y: X.C_int;
    width: X.C_int;
    height: X.C_int): X.C_int;
PROCEDURE XSaveContext* (
    display: X.DisplayPtr;
    rid: X.XID;
    context: XContext;
    VAR data: ARRAY [untagged] OF X.C_char): X.C_int;
PROCEDURE XSetClassHint* (
    display: X.DisplayPtr;
    w: X.Window;
    class_hints: XClassHintPtr);
PROCEDURE XSetIconSizes* (
    display: X.DisplayPtr;
    w: X.Window;
    size_list: XIconSizePtr;
    count: X.C_int);
PROCEDURE XSetNormalHints* (
    display: X.DisplayPtr;
    w: X.Window;
    hints: XSizeHintsPtr);
PROCEDURE XSetRGBColormaps* (
    display: X.DisplayPtr;
    w: X.Window;
    stdcmaps: XStandardColormapPtr;
    count: X.C_int;
    property: X.Atom);
PROCEDURE XSetSizeHints* (
    display: X.DisplayPtr;
    w: X.Window;
    hints: XSizeHintsPtr;
    property: X.Atom);
PROCEDURE XSetStandardProperties* (
    display: X.DisplayPtr;
    w: X.Window;
    window_name: X.C_string;
    icon_name: X.C_string;
    icon_pixmap: X.Pixmap;
    argv: X.C_charPtr2d;
    argc: X.C_int;
    hints: XSizeHintsPtr);
PROCEDURE XSetTextProperty* (
    display: X.DisplayPtr;
    w: X.Window;
    text_prop: XTextPropertyPtr;
    property: X.Atom);
PROCEDURE XSetWMClientMachine* (
    display: X.DisplayPtr;
    w: X.Window;
    text_prop: XTextPropertyPtr);
PROCEDURE XSetWMHints* (
    display: X.DisplayPtr;
    w: X.Window;
    wm_hints: XWMHintsPtr);
PROCEDURE XSetWMIconName* (
    display: X.DisplayPtr;
    w: X.Window;
    text_prop: XTextPropertyPtr);
PROCEDURE XSetWMName* (
    display: X.DisplayPtr;
    w: X.Window;
    text_prop: XTextPropertyPtr);
PROCEDURE XSetWMNormalHints* (
    display: X.DisplayPtr;
    w: X.Window;
    hints: XSizeHintsPtr);
PROCEDURE XSetWMProperties* (
    display: X.DisplayPtr;
    w: X.Window;
    window_name: XTextPropertyPtr;
    icon_name: XTextPropertyPtr;
    argv: X.C_charPtr2d;
    argc: X.C_int;
    normal_hints: XSizeHintsPtr;
    wm_hints: XWMHintsPtr;
    class_hints: XClassHintPtr);
PROCEDURE XmbSetWMProperties* (
    display: X.DisplayPtr;
    w: X.Window;
    window_name: X.C_string;
    icon_name: X.C_string;
    argv: X.C_charPtr2d;
    argc: X.C_int;
    normal_hints: XSizeHintsPtr;
    wm_hints: XWMHintsPtr;
    class_hints: XClassHintPtr);
PROCEDURE XSetWMSizeHints* (
    display: X.DisplayPtr;
    w: X.Window;
    hints: XSizeHintsPtr;
    property: X.Atom);
PROCEDURE XSetRegion* (
    display: X.DisplayPtr;
    gc: X.GC;
    r: Region);
PROCEDURE XSetStandardColormap* (
    display: X.DisplayPtr;
    w: X.Window;
    colormap: XStandardColormapPtr;
    property: X.Atom);
PROCEDURE XSetZoomHints* (
    display: X.DisplayPtr;
    w: X.Window;
    zhints: XSizeHintsPtr);
PROCEDURE XShrinkRegion* (
    r: Region;
    dx: X.C_int;
    dy: X.C_int);
PROCEDURE XStringListToTextProperty* (
    list: X.C_charPtr2d;
    count: X.C_int;
    VAR text_prop_return: XTextProperty): X.Status;
PROCEDURE XSubtractRegion* (
    sra, srb, dr_return: Region);  (* ??? *)
PROCEDURE XmbTextListToTextProperty* (
    display: X.DisplayPtr;
    list: X.C_charPtr2d;
    count: X.C_int;
    style: XICCEncodingStyle;
    VAR text_prop_return: XTextProperty): X.C_int;
PROCEDURE XwcTextListToTextProperty* (
    display: X.DisplayPtr;
    list: X.C_longstring;
    count: X.C_int;
    style: XICCEncodingStyle;
    VAR text_prop_return: XTextProperty): X.C_int;
PROCEDURE XwcFreeStringList* (
    list: X.wcharPtr2d);
PROCEDURE XTextPropertyToStringList* (
    text_prop: XTextPropertyPtr;
    VAR list_return: X.C_charPtr2d;
    VAR count_return: X.C_int): X.Status;
PROCEDURE XTextPropertyToTextList* (
    display: X.DisplayPtr;
    text_prop: XTextPropertyPtr;
    VAR list_return: X.C_charPtr2d;
    VAR count_return: X.C_int): X.Status;
PROCEDURE XwcTextPropertyToTextList* (
    display: X.DisplayPtr;
    text_prop: XTextPropertyPtr;
    VAR list_return: X.wcharPtr2d;
    VAR count_return: X.C_int): X.Status;
PROCEDURE XUnionRectWithRegion* (
    rectangle: X.XRectanglePtr;
    src_region: Region;
    dest_region_return: Region);  (* ??? *)
PROCEDURE XUnionRegion* (
    sra, srb, dr_return: Region);  (* ??? *)
PROCEDURE XWMGeometry* (
    display: X.DisplayPtr;
    screen_number: X.C_int;
    user_geometry: X.C_string;
    default_geometry: X.C_string;
    border_width: X.C_int;
    hints: XSizeHintsPtr;
    VAR x_return: X.C_int;
    VAR y_return: X.C_int;
    VAR width_return: X.C_int;
    VAR height_return: X.C_int;
    VAR gravity_return: X.C_int): X.C_int;
PROCEDURE XXorRegion* (
    sra, srb, dr_return: Region);  (* ??? *)

END Xutil.
