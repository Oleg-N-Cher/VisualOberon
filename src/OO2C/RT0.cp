MODULE RT0; IMPORT SYSTEM;

TYPE
  Name* = POINTER TO ARRAY [notag] OF SHORTCHAR;

  Module* = POINTER TO ModuleDesc;
  ModuleDesc = RECORD
    name-: Name;
    (**Name of the module.  *)

    typeDescriptors-: POINTER TO ARRAY [notag] OF Struct;
    (**All type descriptors of this module that correspond to named types
       defined on the top level.  Descriptors are listed in no particular
       order.  The last element of the array has the value @code{NIL}.  *)
  END;

  Struct* = POINTER TO StructDesc;
  StructDesc = RECORD
    module-: Module;
    name-: Name;
  END;

PROCEDURE TypeOf* (ptr: SYSTEM.PTR): Struct;
  BEGIN RETURN NIL
END TypeOf;

END RT0.
