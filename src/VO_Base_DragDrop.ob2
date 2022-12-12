(**
  This class iimplements the necessary classes for drag and drop data exchange.
**)

MODULE VO:Base:DragDrop;

(*
    Classes for drag and drop data exchange.
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

CONST

  initialListSize = 20;

  (* a special joker group/type *)
  joker * = -1;

  (* Another special group/type. *)
  none*   = 0;

  (* datatype groups *)

  text*     = 1;
  image*    = 2;
  custom*   = 3;

  (* special datatypes *)

  filename* = 1;

  (* a number of actions *)

  move*    = 1;
  copy*    = 2;
  link*    = 3;
  default* = 4;
  insert*  = 5;  (* insert can be used for simulating selection insertion
                   using dragging *)

TYPE

  (**
    Represents entry in the datatype table of DnDdataInfo.
  **)

  DnDDataInfoEntryDesc* = RECORD
                            group-,type-   : LONGINT;
                            actions-       : SET;
                            defaultAction- : LONGINT;
                          END;

  DnDDataInfoList = POINTER TO ARRAY OF DnDDataInfoEntryDesc;

  DnDDataInfo*     = POINTER TO DnDDataInfoDesc;

  (**
    DnDDataInfo has to be used to define the datatypes and object
    support for drag and drop. If the object has be the source of an
    drag action and a valid drop zone can be found, the drag object
    will be asked to fill a given instance of DnDDataInfo with a
    description of the supported datatypes. This list will than handed
    to the drop object, which can then analyse the best to fit datatype, which
    in turn then can be requested from the drag object.
  **)

  DnDDataInfoDesc* = RECORD
                       entries- : DnDDataInfoList;
                       count-   : LONGINT;
                     END;

  DnDData*     = POINTER TO DnDDataDesc;

  (**
    Baseclass for all drag and drop data exchange.
  **)

  DnDDataDesc* = RECORD
                 END;

  DnDStringData*     = POINTER TO DnDStringDataDesc;

  (**
    A special datat exchnage class for simple strings.
  **)

  DnDStringDataDesc* = RECORD (DnDDataDesc)
                         string* : STRING;
                       END;

  (**
    Initialisation. Must be called before first use.
  **)

  PROCEDURE (d : DnDDataInfo) Init*;

  BEGIN
    NEW(d.entries,initialListSize);
    d.count:=0;
  END Init;

  (**
    Add a new datatype to the list of supported datatypes.
    A datatypes is described by a datatype group which defines a physical
    representation (text, image ...) , a type that more closely describes the
    pysical structure (image/gif) or or the logical structure (text/file).
  **)

  PROCEDURE (d : DnDDataInfo) AddDataType*(group, type : LONGINT;
                                           actions : SET; defaultAction : LONGINT);

  VAR
    help : DnDDataInfoList;
    x    : LONGINT;

  BEGIN
    IF d.count>=LEN(d.entries^) THEN
      NEW(help,LEN(d.entries^)+initialListSize);
      FOR x:=0 TO LEN(d.entries^)-1 DO
        help[x]:=d.entries[x];
      END;
      d.entries:=help;
    END;

    d.entries[d.count].group:=group;
    d.entries[d.count].type:=type;
    d.entries[d.count].actions:=actions;
    d.entries[d.count].defaultAction:=defaultAction;

    INC(d.count);
  END AddDataType;

  (**
    Search in the list of supported datatypes for the occurence of this special
    group and type. You can give joker as group or type name. In that case the
    match will be skiped for that part. The actuall found group and type will
    be returned if found.
  **)

  PROCEDURE (d : DnDDataInfo) FindDataType*(VAR group,type,action : LONGINT):BOOLEAN;

  VAR
    x : LONGINT;

  BEGIN
    FOR x:=0 TO d.count-1 DO
      IF ((group=joker) OR (d.entries[x].group=group))
      & ((type=joker) OR (d.entries[x].type=type))
      & ((action IN d.entries[x].actions)
        OR ((action=default) & (d.entries[x].defaultAction#none))) THEN
        group:=d.entries[x].group;
        type:=d.entries[x].type;
        IF action=default THEN
          action:=d.entries[x].defaultAction;
        END;
        RETURN TRUE;
      END;
    END;

    RETURN FALSE;
  END FindDataType;


END VO:Base:DragDrop.