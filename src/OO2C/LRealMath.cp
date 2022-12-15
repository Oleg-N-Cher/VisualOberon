(* 	$Id: LRealMath.cp,v 1.7 2022/12/15 5:14:17 mva Exp $	 *)
MODULE [foreign] LRealMath (* INTERFACE "C"
  <* IF HAVE_LIB_M THEN *> ; LINK LIB "m" END <* END *> *);
(*  Math functions for LONGREAL.
    Copyright (C) 2002,2003  Michael van Acken

    This module is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public License
    as published by the Free Software Foundation; either version 2 of
    the License, or (at your option) any later version.

    This module is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with OOC. If not, write to the Free Software Foundation,
    59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*)

IMPORT SYSTEM;

CONST
  pi*   = 3.1415926535897932384626433832795028841972E0;
  exp1* = 2.7182818284590452353602874713526624977572E0;


PROCEDURE- Aincludemath- "#include <math.h>";

PROCEDURE- sqrt* (x: REAL): REAL "sqrt(x)";
(**Returns the positive square root of x where x >= 0.  *)

PROCEDURE- exp* (x: REAL): REAL "exp(x)";
(**Returns the exponential of x for x < Ln(MAX(SHORTREAL).  *)

PROCEDURE- ln* (x: REAL): REAL "log(x)";
(**Returns the natural logarithm of x for x > 0.  *)

PROCEDURE- sin* (x: REAL): REAL "sin(x)";

PROCEDURE- cos* (x: REAL): REAL "cos(x)";
 
PROCEDURE- tan* (x: REAL): REAL "tan(x)";
(**Returns the tangent of x where x cannot be an odd multiple of pi/2.  *)
 
PROCEDURE- arcsin* (x: REAL): REAL "asin(x)";
(**Returns the arcsine of x, in the range [-pi/2, pi/2] where -1 <= x <= 1.  *)
 
PROCEDURE- arccos* (x: REAL): REAL "acos(x)";
(**Returns the arccosine of x, in the range [0, pi] where -1 <= x <= 1.  *)

PROCEDURE- arctan* (x: REAL): REAL "atan(x)";
(**Returns the arctangent of x, in the range [-pi/2, pi/2] for all x.  *)
 
PROCEDURE- power* (base, exponent: REAL): REAL "pow(base, exponent)";
(**Returns the value of the number base raised to the power exponent 
     for base > 0.  *)

PROCEDURE- round* (x: REAL): INTEGER "((x)>=0.0?(INTEGER)(x+0.5):(INTEGER)(x-0.5))";
(**Returns the value of x rounded to the nearest integer.  *)

PROCEDURE- sincos* (x: REAL; OUT sin, cos: REAL) "sincos(x, sin, cos)";
(**More efficient sin/cos implementation if both values are needed.  *)

PROCEDURE- arctan2* (xn, xd: REAL): REAL "atan2(xn, xd)";
(**arctan2(xn,xd) is the quadrant-correct arc tangent atan(xn/xd).  If the 
   denominator xd is zero, then the numerator xn must not be zero.  All
   arguments are legal except xn = xd = 0.  *)

PROCEDURE- sinh* (x: REAL): REAL "sinh(x)";
(**sinh(x) is the hyperbolic sine of x.  The argument x must not be so large 
   that exp(|x|) overflows.  *)

PROCEDURE- cosh* (x: REAL): REAL "cosh(x)";
(**cosh(x) is the hyperbolic cosine of x.  The argument x must not be so large
   that exp(|x|) overflows.  *)   

PROCEDURE- tanh* (x: REAL): REAL "tanh(x)";
(**tanh(x) is the hyperbolic tangent of x.  All arguments are legal.  *)

PROCEDURE- arcsinh* (x: REAL): REAL "asinh(x)";
(**arcsinh(x) is the arc hyperbolic sine of x.  All arguments are legal.  *)

PROCEDURE- arccosh* (x: REAL): REAL "acosh(x)";
(**arccosh(x) is the arc hyperbolic cosine of x.  All arguments greater than 
   or equal to 1 are legal.  *)
   
PROCEDURE- arctanh* (x: REAL): REAL "tanh(x)";
(**arctanh(x) is the arc hyperbolic tangent of x.  |x| < 1 - sqrt(em), where 
   em is machine epsilon.  Note that |x| must not be so close to 1 that the 
   result is less accurate than half precision.  *)

END LRealMath.
