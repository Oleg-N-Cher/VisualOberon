MODULE Example1;

IMPORT W := Windows, S := SYSTEM, Out := Console;

PROCEDURE TestMessage;
VAR
  result : LONGINT;
BEGIN
  result := W.MessageBoxA(0, "Hello from Example1!", "Test Message", 0);
  Out.String("MessageBox returned "); 
  Out.LongInt(result,0); 
  Out.Ln;
END TestMessage;

BEGIN
  TestMessage;
END Example1.
