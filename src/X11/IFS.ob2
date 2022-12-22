MODULE IFS;
(* Iterated Function System, see page 92 in
   Reiser, M., Wirth, N: "Programming in Oberon"  *)

IMPORT
  RandomNumbers:=ooc2RandomNumbers, XYplane:=OakXYplane;

VAR
  a1, b1, c1, d1, e1, f1, p1: REAL;   (* IFS parameters *)
  a2, b2, c2, d2, e2, f2, p2: REAL;   (* IFS parameters *)
  a3, b3, c3, d3, e3, f3, p3: REAL;   (* IFS parameters *)
  a4, b4, c4, d4, e4, f4, p4: REAL;   (* IFS parameters *)
  X, Y: REAL;     (* the position of the pen *)
  x0: INTEGER;    (* Distance of origin fm left edge[pixels] *)
  y0: INTEGER;    (* Distance of origin from bottom edge[pixels] *)
  e: INTEGER;     (* Size of unit interval [pixels] *)

PROCEDURE  Draw;
  VAR
    x, y: REAL;                         (* new position *)
    xi, eta: INTEGER;                   (* pixel coordinates of pen *)
    rn: REAL;
  BEGIN
    REPEAT
      rn := RandomNumbers.Random();
      IF rn < p1 THEN
        x := a1 * X + b1 * Y + e1;      y := c1 * X + d1 * Y + f1
      ELSIF rn < (p1 + p2) THEN
        x := a2 * X + b2 * Y + e2;      y := c2 * X + d2 * Y + f2
      ELSIF rn < (p1 + p2 + p3) THEN
        x := a3 * X + b3 * Y + e3;      y := c3 * X + d3 * Y + f3
      ELSE
        x := a4 * X + b4 * Y + e4;      y := c4 * X + d4 * Y + f4
      END;
      X := x;  xi := x0 + SHORT(ENTIER(X*e));
      Y := y;  eta := y0 + SHORT(ENTIER(Y*e));
      XYplane.Dot(xi, eta, XYplane.draw)
    UNTIL "s" = XYplane.Key()
  END Draw;

PROCEDURE Init;
  BEGIN
    X := 0.0;   Y := 0.0;           (* Initial position of pen *)
    
    (* Fern: *)
    x0 := 320; y0 := 75; e := 64;
    a1 := 0.0;    a2 := 0.85;   a3 := 0.2;    a4 := -0.15;
    b1 := 0.0;    b2 := 0.04;   b3 := -0.26;  b4 := 0.28;
    c1 := 0.0;    c2 := -0.04;  c3 := 0.23;   c4 := 0.26;
    d1 := 0.16;   d2 := 0.85;   d3 := 0.22;   d4 := 0.24;
    e1 := 0.0;    e2 := 0.0;    e3 := 0.0;    e4 := 0.0;
    f1 := 0.0;    f2 := 1.6;    f3 := 1.6;    f4 := 0.44;
    p1 := 0.01;   p2 := 0.85;   p3 := 0.07;   p4 := 0.07;

    (*
    (* Leaf: *)
    x0 := 90; y0 := 100; e := 450;
    a1 := 0.65;   a2 := 0.65;   a3 := 0.32;   a4 := -0.32;  
    b1 := -0.013; b2 := -0.026; b3 := -0.32;  b4 := 0.32;  
    c1 := 0.013;  c2 := 0.026;  c3 := 0.32;   c4 := 0.32;
    d1 := 0.65;   d2 := 0.65;   d3 := 0.32;   d4 := 0.32;
    e1 := 0.175;  e2 := 0.175;  e3 := 0.2;    e4 := 0.8;
    f1 := 0.0;    f2 := 0.35;   f3 := 0.0;    f4 := 0.0;
    p1 := 0.3;    p2 := 0.3;    p3 := 0.2;    p4 := 0.2;
    *)
    
    XYplane.Open;
  END Init;

BEGIN
  Init; Draw
END IFS.
