(*	$Id: HashCode.cp,v 1.1 2022/12/14 4:19:04 mva Exp $	*)
MODULE [foreign] HashCode (* FOREIGN "C"; LINK FILE "HashCode.c" END *);
(*  Hash functions for basic types.
    Copyright (C) 2003  Michael van Acken

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

IMPORT
  SYSTEM;
  
TYPE
  Hash* = INTEGER;
  (**The integer type used to store hash values.  *)
  UCS4CHAR = INTEGER;

CONST
  init* = 257;
  (**When computing a hash from a set of hash codes, do something along the
     lines of

     @example
     x := HashCode.init;
     FOREACH y IN (set of hashes) DO
       HashCode.Append(y, x);
     END;
     @end example  *)
     
PROCEDURE- Boolean*(x: BOOLEAN): Hash;
PROCEDURE- Real*(x: SHORTREAL): Hash;
PROCEDURE- LongReal*(x: REAL): Hash;
PROCEDURE- LongInt*(x: LONGINT): Hash;
PROCEDURE- Set*(x: SET): Hash;
PROCEDURE- Ptr*(x: SYSTEM.PTR): Hash;
(* FIXME... there are more basic types ;-)  *)

PROCEDURE- CharRegion*(IN data: ARRAY OF SHORTCHAR; start, end: INTEGER): Hash;
PROCEDURE- LongCharRegion*(IN data: ARRAY OF CHAR; start, end: INTEGER): Hash;
PROCEDURE- UCS4CharRegion*(IN data: ARRAY OF UCS4CHAR; start, end: INTEGER): Hash;

PROCEDURE- Append*(x: Hash; VAR hash: Hash);
  
END HashCode.
