/*	$Id: HashCode.c,v 1.2 2003/08/14 21:19:43 mva Exp $	*/
/*  Hash functions for basic types.
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
*/

#include "SYSTEM.oh"
#include "HashCode.oh"

typedef INTEGER HashCode_Hash;
typedef INTEGER UCS4CHAR;

#define AS_HASH(x) ((HashCode_Hash)(x))
#define COMBINE(x,y) ((x)^(y))

HashCode_Hash HashCode_Boolean (BOOLEAN x) {
  return (x != 0)+1;
}

HashCode_Hash HashCode_Real (SHORTREAL x) {
  union {
    SHORTREAL real;
    HashCode_Hash hash;
  } p;
  
  p.real = x;
  return p.hash;
}

HashCode_Hash HashCode_LongReal (REAL x) {
  union {
    REAL real;
    HashCode_Hash hash[2];
  } p;
  
  p.real = x;
  return COMBINE(p.hash[0], p.hash[1]);
}

HashCode_Hash HashCode_Set (SET x) {
  return AS_HASH(x);
}

HashCode_Hash HashCode_Ptr (void* x) {
#if (__SIZEOF_POINTER__ == 8) || defined (_LP64) || defined(__LP64__) || defined(_WIN64)
  union {
    void* ptr;
    HashCode_Hash hash[2];
  } p;

  p.ptr = x;
  return COMBINE(p.hash[0], p.hash[1]);  /* 64 bit systems */
#else
  return AS_HASH(x);  /* 32 bit systems */
#endif
}

HashCode_Hash HashCode_CharRegion (CHAR *data, INTEGER data_0d,
				    INTEGER start, INTEGER end) {
  /* taken from Python's dist/src/Objects/stringobject.c */
  register CHAR *p, *s;
  register HashCode_Hash x;
  
  s = (CHAR *)(data+end);
  p = (CHAR *)(data+start);
  if (p == s) {
    return 0;
  } else {
    x = *p << 7;
    while (p != s)
      x = (1000003*x) ^ *p++;
    return x ^ (end-start);
  }
}

HashCode_Hash HashCode_LongCharRegion (LONGCHAR *data, INTEGER data_0d,
					INTEGER start, INTEGER end) {
  /* taken from Python's dist/src/Objects/stringobject.c */
  register LONGCHAR *p, *s;
  register HashCode_Hash x;
  
  s = (LONGCHAR *)(data+end);
  p = (LONGCHAR *)(data+start);
  if (p == s) {
    return 0;
  } else {
    x = *p << 7;
    while (p != s)
      x = (1000003*x) ^ *p++;
    return x ^ (end-start);
  }
}

HashCode_Hash HashCode_UCS4CharRegion (UCS4CHAR *data, INTEGER data_0d,
					INTEGER start, INTEGER end) {
  /* taken from Python's dist/src/Objects/stringobject.c */
  register UCS4CHAR *p, *s;
  register HashCode_Hash x;
  
  s = (UCS4CHAR *)(data+end);
  p = (UCS4CHAR *)(data+start);
  if (p == s) {
    return 0;
  } else {
    x = *p << 7;
    while (p != s)
      x = (1000003*x) ^ *p++;
    return x ^ (end-start);
  }
}

void HashCode_Append (HashCode_Hash x, HashCode_Hash *hash) {
  *hash ^= x;
}
