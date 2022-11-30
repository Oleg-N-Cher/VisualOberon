MODULE Example4;

(* Minimalist example that imports nothing from the OOC Core. This should
** result in a reasonably small binary *)

IMPORT W := Windows;

PROCEDURE TestMessage;
VAR
  result : LONGINT;
BEGIN
  result := W.MessageBoxA(0, "Hello from Example4!", "Test Message", 0);
END TestMessage;

BEGIN
  TestMessage;
END Example4.
