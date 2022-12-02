(*
** This simple example program demostrates the Windows module for oo2c.
**
** It opens a window, with a centred text message. Any characters typed into
** the window will be echoed to standard output.
**
** - Stewart Greenhill
*)

MODULE Example3 (*OOC_EXTENSIONS*);

IMPORT W := Windows, S := SYSTEM, Out := Console, LongStrings;

CONST
  className = "Example2Class";
  title = "Test Window";
  iconId = 1;

TYPE
  LONGCHAR = S.CHAR16;

VAR
  instance : W.HINSTANCE;		(* program instance handle *)
  window : W.HWND;			(* handle for main window *)

  message : ARRAY 256 OF LONGCHAR;	(* text to be displayed in window *)
  messageLen : INTEGER;			(* length of displayed text *)

(*
** MessageHandler - handle events in our window
** MessageHandler is called by Windows and must be declared "Pascal" so that
** StdCall (pascal) calling conventions are used. 
*)

PROCEDURE [stdcall] MessageHandler (wnd : W.HWND; msg : W.UINT; wParam : W.WPARAM; lParam : W.LPARAM) : W.LRESULT;
VAR
  dc : W.HDC;
  ps : W.PAINTSTRUCT;
  res : W.BOOL;
  r : W.RECT;
  s : W.SIZE;
  x, y : W.LONG;
BEGIN
  CASE msg OF
  | W.WM_DESTROY:
    W.PostQuitMessage(0)
  | W.WM_PAINT:
    dc := W.BeginPaint(wnd, ps);

    (* calculate extent of window and text *)
    res := W.GetClientRect(wnd, r);
    res := W.GetTextExtentPoint32W(dc, message, messageLen, s);

    (* calculate position for centered text *)
    x := r.left + (r.right - r.left - s.cx) DIV 2;
    y := r.top + (r.bottom - r.top - s.cy) DIV 2;

    (* paint text to window *)
    res := W.TextOutW(dc, x, y, message, messageLen);
    res := W.EndPaint(wnd, ps);
  | W.WM_CHAR:
    Out.Char(CHR(wParam));
    Out.Flush;
  ELSE
    RETURN W.DefWindowProcA(wnd, msg, wParam, lParam);
  END;
  RETURN 0;
END MessageHandler;

(*
** OpenWindow - register window class and open main window
*)

PROCEDURE OpenWindow;
VAR
  class : W.WNDCLASS;
  res : W.BOOL;
BEGIN
  class.hCursor := W.LoadCursorA(0, S.VAL(W.LPCSTR, W.IDC_ARROW));
  class.hIcon := W.LoadIconA(instance, S.VAL(W.LPCSTR, iconId));
  class.lpszMenuName := NIL;
  class.lpszClassName := className;
  class.hbrBackground := W.GetStockObject(W.WHITE_BRUSH);
  class.style := W.CS_VREDRAW + W.CS_HREDRAW;
  class.hInstance := instance;
  class.lpfnWndProc := MessageHandler;
  class.cbClsExtra := 0;
  class.cbWndExtra := 0;
  res := W.RegisterClassA(class);
  window := W.CreateWindowExA(0, className, title,
    W.WS_OVERLAPPEDWINDOW,
    W.CW_USEDEFAULT, W.CW_USEDEFAULT,
    W.CW_USEDEFAULT, W.CW_USEDEFAULT,
    0, 0, instance, 0);
  res := W.ShowWindow(window, W.SW_SHOWDEFAULT);
  res := W.UpdateWindow(window);
END OpenWindow;

PROCEDURE EventLoop;
VAR
  msg: W.MSG;
  lRes: W.LONG;
  bRes : W.BOOL;
BEGIN
  WHILE W.GetMessageA(msg, 0, 0, 0) # 0 DO
    bRes := W.TranslateMessage(msg);
    lRes := W.DispatchMessageA(msg);
  END;
  W.ExitProcess(msg.wParam)
END EventLoop;

BEGIN
  instance := W.GetModuleHandleA(NIL);
  message := "Hello from Example3! (LONGCHAR)";
  messageLen := LongStrings.Length(message);
  OpenWindow;
  EventLoop
END Example3.
