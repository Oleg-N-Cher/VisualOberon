MODULE VO_Base_Object (*OOC_EXTENSIONS*);

  (**
    Implements @otype{Object} the  baseclass for all VisualOberon objects.
    Does also define the derived class @otype{MsgObject} which implements
    message communication between @otype{Object}s. @otype{Model}, the baseclass
    for all models, is also implemented here.
  *)

(*
    Baseclass for all objects in VisualOberon.
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

IMPORT O := Object;

CONST
  broadcastMsg* = -1;
  everyMsg*     = -2;
  actionMsg*    = -3;

  customMsg*    = -4;

TYPE
  STRING = O.String;

  Object*           = POINTER TO ObjectDesc;
  MsgObject*        = POINTER TO MsgObjectDesc;
  Handler*          = POINTER TO HandlerDesc;
  Message*          = POINTER TO MessageDesc;
  ResyncMsg*        = POINTER TO ResyncMsgDesc;
  Notify*           = POINTER TO NotifyDesc;
  Action*           = POINTER TO ActionDesc;
  ActionConverter*  = POINTER TO ActionConverterDesc;
  HandlerEntry      = POINTER TO HandlerEntryDesc;
  Model*            = POINTER TO ModelDesc;
  ModelEntry        = POINTER TO ModelEntryDesc;

  ObjectDesc*       = ABSTRACT RECORD (O.ObjectDesc)
                        (**
                          The abstract baseclass for all objects in VO. Inherits
                          from the oo2c @otype{O.Object} baseclass.
                        *)
                      END;

  MsgObjectDesc*    = ABSTRACT RECORD (ObjectDesc)
                        (**
                          This is a second abstract class derived from Object.

                          @otype{MsgObject} can send and recieve messages.
                        *)
                        handlerList : HandlerEntry; (** A list of handlers, each message is send to *)
                        id-         : INTEGER;      (** All objects have an id *)
                        name-       : STRING;       (** An object can have a nmae *)
                      END;

  HandlerEntryDesc  = RECORD
                        (**
                          All handlers for an @otype{Object} are listed with this
                          class as node.
                        *)
                        next    : HandlerEntry;
                        type    : INTEGER;      (** The type of message the handler listens to *)
                        handler : Handler;      (** the handler itself *)
                      END;

  HandlerDesc*      = EXTENSIBLE RECORD
                        (**
                          All message sending between objects goes through handlers.
                          Using a @otype{Handler} between the sender and reciever of an
                          message allows us to change the messagetyp on the fly.

                          This is a simple way to get objects freely communicate
                          with each other without knowing the messages the reciever
                          knows.

                          You simply insert a handler between sender reciever that
                          converts the sender message to the reciever messsage.
                        *)
                        destination* : MsgObject; (**
                                                     The destination object all messages by this handler
                                                     should be send to. You have to initialize it
                                                     before you do MsgObject.AddHandler.
                                                   *)
                      END;

  MessageDesc*      = EXTENSIBLE RECORD
                        (**
                          The (abstract) baseclass for all messages.
                        *)
                        source* : MsgObject; (**
                                                The object the message was send
                                                from
                                              *)
                      END;

  ActionDesc*       = RECORD (MessageDesc)
                        (**
                          A special message for prameterless actions (like for
                          example a event that gets triggered when a button is
                          pressed). You store the type of the action in the
                          action memebr variable. Using action instead of a
                          self-derived class while reduce code bloat and class
                          count.
                        *)
                        action* : INTEGER;
                      END;

  ActionConverterDesc*= RECORD (HandlerDesc)
                          action* : INTEGER;
                        END;

  ResyncMsgDesc*    = EXTENSIBLE RECORD
                        (**
                          This message is the abstract baseclass for all
                          resync-messages. A model can send to its viewers
                          when the contents of the model have changed.
                        *)
                      END;

  NotifyDesc*       = RECORD (ResyncMsgDesc)
                        notify* : INTEGER;
                      END;

  ModelEntryDesc    = RECORD
                        (**
                          The list of objects (viewers) an @otype{Model} has
                          uses this as node.
                        *)
                        next   : ModelEntry;
                        object : MsgObject;  (* We could als use a pointer to Object, but this makes more sense for me *)
                      END;

  ModelDesc* = ABSTRACT RECORD (MsgObjectDesc)    (* This offers interesting features *)
                 (**
                   The abstract baseclass for all models. A model is a container
                   for an in any way designed datacollection.

                   An @otype{Object} (viewer) does not hold its values itself but
                   has a pointer to a @otype{Model}. The user changes the value
                   of the @otype{Model} and not the value of the @otype{Object}.
                   The @otype{Model} then sends an @otype{ResyncMsg} to all its
                   viewers to make them update the representation of the data
                   the @otype{Model} holds.
                 *)
                 objectList : ModelEntry; (** The list of objects *)
                 lastObject : ModelEntry;
                 on         : BOOLEAN;
               END;

  PROCEDURE (o : Object) Init*, NEW, EXTENSIBLE;
  (**
    Each object has an initialisation routine.

    If an object initializes itself, it must call the init-method of the baseclass.

    Note, that this method does not prevent a class to implement initialize-functions,
    but they must then call this method.
  *)

  BEGIN
    (* no code *)
  END Init;

  PROCEDURE (o : Object) Free*, NEW;
  (**
    All object have some kind of finalizer method. Such a method is needed
    for OS-specific ressources like filehandles or GUI stuff that does not get
    freed automatically by garbage collection.

    Later versions of oo2c/VisualOberon may have an direct interface to
    the GC to realize finalisation, since then me must use a not that nice
    method: objects can register themself a a window. The window will call
    Free for all registered objects on deletion.
  *)

  BEGIN
    (* no code *)
  END Free;

  PROCEDURE (m : MsgObject) Init*, EXTENSIBLE;
  (**
    MsgObject inherits the Init-function from Object.
  *)

  BEGIN
    m.Init^;
    m.handlerList:=NIL;
    m.name:=NIL;
  END Init;

  PROCEDURE (m : MsgObject) SetId*(id : INTEGER), NEW;
  (**
    We must have the ability to set the id of an object
  *)

  BEGIN
    m.id:=id;
  END SetId;

  PROCEDURE (o : MsgObject) SetName*(name : STRING), NEW;
    (**
      You can give an object a name. This can be usefull for automatically
      matching models (which also can have a name) with objects.
    *)
  BEGIN
    o.name:=name;
  END SetName;

  PROCEDURE (m : MsgObject) Receive*(message : Message), NEW;
  (**
    This method of an object gets called when someone sends a method
    to it.
  *)

  BEGIN
    (* no code *)
  END Receive;

  PROCEDURE (m : MsgObject) AddHandler*(handler : Handler; type : INTEGER), NEW;
  (**
    You can add a handler to an object.

    The handler gets then called after the sender sends the object
    and before the receiver recieves it.

    type defines the type of message the handler wants to get called for.
    The objects have to suply constants for that.
  *)

  VAR
    hdlEntry : HandlerEntry;

  BEGIN
    NEW(hdlEntry);
    hdlEntry.type:=type;
    hdlEntry.handler:=handler;
    hdlEntry.next:=m.handlerList;
    m.handlerList:=hdlEntry;
  END AddHandler;

  PROCEDURE (m : MsgObject) RemoveHandler*(handler : Handler), NEW;
  (**
    You also can remove a handler anytime.
  *)

  VAR
    help,
    last : HandlerEntry;

  BEGIN
    IF (m.handlerList#NIL) & (m.handlerList.handler=handler) THEN
      m.handlerList:=m.handlerList.next;
      RETURN;
    END;

    help:=m.handlerList.next;
    last:=m.handlerList;
    WHILE (help#NIL) & (help.handler#handler) DO
      last:=help;
      help:=help.next;
    END;
    IF help#NIL THEN
      last.next:=help.next;
    END;
  END RemoveHandler;

  PROCEDURE (m : MsgObject) HasHandler*(type : INTEGER):BOOLEAN, NEW;
    (**
      returns @code{TRUE} if the object has a handler for the given type..
    *)

  VAR
    help : HandlerEntry;

  BEGIN
    help:=m.handlerList;
    WHILE (help#NIL) DO
      IF (help.type=type) THEN
        RETURN TRUE;
      END;
      help:=help.next;
    END;

    RETURN FALSE;
  END HasHandler;

  PROCEDURE (m : MsgObject) Forward*(type : INTEGER; destination : MsgObject), NEW;
  (**
    You can also tell the object to send msgs of a specific type
    simply to another object.

    This is done by simply adding a default handler.
  *)

  VAR
    handler : Handler;

  BEGIN
    NEW(handler);
    handler.destination:=destination;
    m.AddHandler(handler,type);
 END Forward;

  PROCEDURE (h : Handler) Convert*(message : Message):Message, NEW, EXTENSIBLE;
  (**
    This function of the handler gets called after the sender sends the object
    and before the receiver recieves it. This gives you the possibility to
    change the type of the message. Just create the new message and return it.

    You don't have copy the destination field, that will be done by Handler.Send
    automatically.
  *)

  BEGIN
    RETURN message;
  END Convert;

  PROCEDURE (h : Handler) Send*(message : Message), NEW;
  (**
    This method gets called by an object for each handler which is interested
    in the message.
  *)

  VAR
    newMsg : Message;

  BEGIN
    newMsg:=h.Convert(message);
    IF newMsg#NIL THEN
      newMsg.source:=message.source;
      IF h.destination#NIL THEN
        h.destination.Receive(newMsg);
      END;
    END;
  END Send;

  PROCEDURE (m : MsgObject) Send*(message : Message; type : INTEGER), NEW;
  (**
    Call this method if you want to send a message with a given type.
  *)

  VAR
    hdlEntry : HandlerEntry;

  BEGIN
    message.source:=m;
    hdlEntry:=m.handlerList;
    WHILE hdlEntry#NIL DO
      IF (type=broadcastMsg)
      OR (hdlEntry.type=type)
      OR (hdlEntry.type=everyMsg) THEN
        hdlEntry.handler.Send(message);
      END;
      hdlEntry:=hdlEntry.next;
    END;
  END Send;

  PROCEDURE (m : MsgObject) Resync*(model : Model; msg : ResyncMsg), NEW;
  (**
    This method gets called when a model wants you to resync yourself with
    its contents.
  *)

  BEGIN
  END Resync;

  PROCEDURE (m : Model) Init*;
  (**
    Initializes an freshly allocated @otype{Model}. You must call this method
    right after allocation and before any other method call.

    The model is by default switched on.
  *)

  BEGIN
    m.Init^;
    m.objectList:=NIL;
    m.lastObject:=NIL;
    m.on:=TRUE;
  END Init;

  PROCEDURE (m : Model) Push*, NEW;

    (**
      Make a new working copy of the current value. The original value can be made
      available again by calling @oproc{Model.Undo}. It can be overwritten by
      calling @oproc{Model.Save} and the current copy can we thrown away by calling
      @oproc{Model.Pop}.

      Using these method syou can implement backup/restore semantics
      (normaly by using some value stack).

      A @otype{Model} does not need to implement these methods, for some models
      this would be difficult or just would not make sense (like lists and
      table models), however since some code relies on it, it should clearly
      mark this fact.
    *)

  BEGIN
  END Push;

  PROCEDURE (m : Model) Undo*, NEW;

    (**
      See Push.
    *)

  BEGIN
  END Undo;

  PROCEDURE (m : Model) Save*, NEW;

    (**
      See Push.
    *)

  BEGIN
  END Save;

  PROCEDURE (m : Model) Pop*, NEW;

    (**
      See Push.
    *)

  BEGIN
  END Pop;

  PROCEDURE (m : Model) AddObject*(object : MsgObject), NEW;
  (**
    Add an object (viewer) to a model
  *)

  VAR
    entry : ModelEntry;

  BEGIN
    NEW(entry);
    entry.object:=object;
    entry.next:=NIL;
    IF m.objectList=NIL THEN
      m.objectList:=entry;
    ELSE
      m.lastObject.next:=entry;
    END;
    m.lastObject:=entry;
  END AddObject;

  PROCEDURE (m : Model) RemoveObject*(object : MsgObject), NEW;
  (**
    Remove an object from an model.
  *)

  VAR
    help,
    last  : ModelEntry;

  BEGIN
    help:=m.objectList;
    last:=NIL;
    WHILE (help#NIL) & (help.object#object) DO
      last:=help;
      help:=help.next;
    END;
    IF help#NIL THEN
      IF last=NIL THEN
        m.objectList:=m.objectList.next;
      ELSE
        last.next:=help.next;
      END;
    END;
  END RemoveObject;

  PROCEDURE (m : Model) Notify*(msg : ResyncMsg), NEW;
  (**
    A model should call this method with an optional resynmessage
    when you want your viewers to resync themselfs.
  *)

  VAR
    entry : ModelEntry;

  BEGIN
    IF ~m.on THEN
      RETURN;
    END;

    entry:=m.objectList;
    WHILE entry#NIL DO
      entry.object.Resync(m,msg);
      entry:=entry.next;
    END;
  END Notify;

  PROCEDURE (m : Model) On*, NEW;

    (**
      Switch on communication between the @otype{Model} and its
      listeners/viewers (derived from @otype{MsgObject}.

      If the model was switched of before @oproc{Model.Notify} will be
      called with parameter @code{NIL} signaling a major change to the
      listeners.
    *)

  BEGIN
    IF ~m.on THEN
      m.on:=TRUE;
      m.Notify(NIL);
    END;
  END On;

  PROCEDURE (m : Model) Off*, NEW;

    (**
      Switch off communication between the @otype{Model} and its
      listeners/viewers (derived from @otype{MsgObject}.

      Use this method before starting some major change to a model and do
      not want the listeners to refresh for every single action. Call
      @oproc{Model.On} to turn on communication and the initiate a major
      refresh for all listeners.
    *)

  BEGIN
    m.on:=FALSE;
  END Off;

  PROCEDURE (m : Model) IsOn*():BOOLEAN, NEW;

    (**
      Tell if the @otype{Model} is currently switch on or off.
    *)

  BEGIN
    RETURN m.on;
  END IsOn;

  PROCEDURE (m : MsgObject) UnattachModel*(model : Model), NEW;
  (**
    Deattach the @otype{MsgObject} from the given @oparam{model}.
  *)

  BEGIN
    model.RemoveObject(m);
  END UnattachModel;

  PROCEDURE (m : MsgObject) AttachModel*(model : Model), NEW;
  (**
    Use this function to attach an @otype{MsgObject} to the given @oparam{model}.

    Normaly you should not call this method directly, the
    object should offer special methods for this.
  *)

  BEGIN
    model.AddObject(m);
    m.Resync(model,NIL);
  END AttachModel;

  PROCEDURE (a : ActionConverter) Convert*(message : Message):Message;

  VAR
    msg : Action;

  BEGIN
    NEW(msg);
    msg.action:=a.action;

    RETURN msg;
  END Convert;

END VO_Base_Object.
