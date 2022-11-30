MODULE VO:Base:Image;

IMPORT D   := VO:Base:Display,
       U   := VO:Base:Util,
       V   := VO:Base:VecImage,

       I   := VO:Image:Image,
              VO:Image:Loader,
  <*PUSH; Warnings:=FALSE; *>
              VO:Image:Loader:All,
  <* POP *>

        PP := VO:Prefs:Parser,

              Err;

  (*
    Unified wrapper classes for vector and file based bitmap Images.
    Copyright (C) 2003 Tim Teulings (rael@edge.ping.de)

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

TYPE
  Image*           = POINTER TO ImageDesc;
  ImageDesc*       = RECORD
                       width-,
                       height-  : LONGINT;
                       alpha-   : BOOLEAN;
                       drawCap- : SET;
                     END;

  FileImage*       = POINTER TO FileImageDesc;
  FileImageDesc*   = RECORD (ImageDesc)
                       normalName-,
                       selectName- : U.Text;
                       normal-,
                       select-     : I.Image;
                     END;

  BitmapImage*     = POINTER TO BitmapImageDesc;
  BitmapImageDesc* = RECORD (ImageDesc)
                       normal,
                       select : I.Image;
                   END;

  VecImage*        = POINTER TO VecImageDesc;
  VecImageDesc*    = RECORD (ImageDesc)
                       image- : V.VecImage; (* TODO: Remove it *)
                     END;

  PROCEDURE (i : Image) Init*;

  BEGIN
    IF D.display.displayType=D.displayTypeTextual THEN
      i.width:=1;
      i.height:=1;
    ELSE
      i.width:=20;
      i.height:=20;
    END;

    i.drawCap:={};
    i.alpha:=FALSE;
  END Init;

  PROCEDURE (i : Image) Draw*(draw : D.DrawInfo; x,y,w,h : LONGINT);

  BEGIN
  END Draw;

  PROCEDURE (i : Image) Free*;

  BEGIN
  END Free;

  PROCEDURE (i : FileImage) Init*;

  BEGIN
    i.Init^;

    i.normal:=NIL;
    i.select:=NIL;
  END Init;

  PROCEDURE (i : FileImage) SetNormal*(name : ARRAY OF CHAR);

    (**
      Set the filename of the image. Must be set before use.
    *)

  BEGIN
    i.normalName:=U.StringToText(name);
    IF I.factory#NIL THEN
      i.normal:=I.factory.CreateImage();
      IF ~Loader.manager.LoadThemed(name,i.normal) THEN
        Err.String("Error loading "); Err.String(name); Err.Ln;
      END;

      i.width:=i.normal.width;
      i.height:=i.normal.height;
      i.alpha:=i.normal.alpha;
    ELSE
      IF D.display.displayType=D.displayTypeTextual THEN
        i.width:=1;
        i.height:=1;
      ELSE
        i.width:=20;
        i.height:=20;
      END;
    END;
  END SetNormal;

  PROCEDURE (i : FileImage) SetSelect*(name : ARRAY OF CHAR);

    (**
      Set the filename of the image. Must be set before use.
    *)

  BEGIN
    i.selectName:=U.StringToText(name);
    IF I.factory#NIL THEN
      i.select:=I.factory.CreateImage();
      IF ~Loader.manager.LoadThemed(name,i.select) THEN
        Err.String("Error loading "); Err.String(name); Err.Ln;
        (*i.image.InitializeEmpty;*)
      END;

      i.width:=i.select.width;
      i.height:=i.select.height;
      i.alpha:=i.select.alpha;
    ELSE
      IF D.display.displayType=D.displayTypeTextual THEN
        i.width:=1;
        i.height:=1;
      ELSE
        i.width:=20;
        i.height:=20;
      END;
    END;
  END SetSelect;

  PROCEDURE (i : FileImage) Draw*(draw : D.DrawInfo; x,y,w,h : LONGINT);

  BEGIN
    IF (D.selected IN draw.mode) & (i.select#NIL) THEN
      i.select.Resize(w,h);
      i.select.Draw(draw,x,y);
    ELSIF i.normal#NIL THEN
      i.normal.Resize(w,h);
      i.normal.Draw(draw,x,y);
    ELSE
      IF (D.selected IN draw.mode) THEN
        draw.PushForeground(D.fillColor);
      ELSE
        draw.PushForeground(D.backgroundColor);
      END;
      draw.FillRectangle(x,y,w,h);
      draw.PopForeground;
    END;
  END Draw;

  PROCEDURE (i : FileImage) Free*;

  BEGIN
    IF i.normal#NIL THEN
      i.normal.Free;
      i.normal:=NIL;
    END;

    IF i.select#NIL THEN
      i.select.Free;
      i.select:=NIL;
    END;
  END Free;

  PROCEDURE CreateFileImage*(normal,select : ARRAY OF CHAR):Image;

  VAR
    file : FileImage;

  BEGIN
    NEW(file);
    file.Init;
    file.SetNormal(normal);
    IF select#"" THEN
      file.SetSelect(select);
    END;

    RETURN file;
  END CreateFileImage;




  PROCEDURE (i : BitmapImage) Init*;

  BEGIN
    i.Init^;

    i.normal:=NIL;
    i.select:=NIL;
  END Init;

  PROCEDURE (i : BitmapImage) SetImage*(normal,selected : I.Image);

    (**
      Set the image to use.
    *)

  BEGIN
    i.normal:=normal;
    i.select:=selected;
    i.width:=i.normal.width;
    i.height:=i.normal.height;
    i.alpha:=i.normal.alpha;
  END SetImage;

  PROCEDURE (i : BitmapImage) Draw*(draw : D.DrawInfo; x,y,w,h : LONGINT);

  BEGIN
    IF (D.selected IN draw.mode) & (i.select#NIL) THEN
      i.select.Resize(w,h);
      i.select.Draw(draw,x,y);
    ELSIF i.normal#NIL THEN
      i.normal.Resize(w,h);
      i.normal.Draw(draw,x,y);
    ELSE
      IF (D.selected IN draw.mode) THEN
        draw.PushForeground(D.fillColor);
      ELSE
        draw.PushForeground(D.backgroundColor);
      END;
      draw.FillRectangle(x,y,w,h);
      draw.PopForeground;
    END;
  END Draw;

  PROCEDURE (i : BitmapImage) Free*;

  BEGIN
    IF i.normal#NIL THEN
      i.normal.Free;
      i.normal:=NIL;
    END;

    IF i.select#NIL THEN
      i.select.Free;
      i.select:=NIL;
    END;
  END Free;

  PROCEDURE CreateBitmapImage*(normal,selected : I.Image):Image;

  VAR
    bitmap : BitmapImage;

  BEGIN
    NEW(bitmap);
    bitmap.Init;
    bitmap.SetImage(normal,selected);

    RETURN bitmap;
  END CreateBitmapImage;

  PROCEDURE (i : VecImage) Init*;

  BEGIN
    i.Init^;

    NEW(i.image);
    i.image.Init;
  END Init;

  PROCEDURE (i : VecImage) SetType*(type : LONGINT);

    (**
      Set the type of the vector image. Must be set before use.
    *)

  BEGIN
    i.image.Set(type);
    i.width:=i.image.width;
    i.height:=i.image.height;
    i.alpha:=i.image.alpha;
    i.drawCap:=i.image.drawCap;
  END SetType;

  PROCEDURE (i : VecImage) Draw*(draw : D.DrawInfo; x,y,w,h : LONGINT);

  BEGIN
    i.image.Draw(draw,x,y,w,h);
  END Draw;

  PROCEDURE CreateVecImage*(type : LONGINT):Image;

  VAR
    vec : VecImage;

  BEGIN
    NEW(vec);
    vec.Init;
    vec.SetType(type);

    RETURN vec;
  END CreateVecImage;

  PROCEDURE LoadImage*(top : PP.Item; name : ARRAY OF CHAR; VAR image : Image);

  VAR
    data,
    data2 : ARRAY 256 OF CHAR;
    type  : LONGINT;

  BEGIN
    top:=top.GetEntry(name);
    IF top=NIL THEN
      RETURN;
    END;

    IF top.GetStringEntry("type",data) THEN
      IF data="internal" THEN
        IF top.GetStringEntry("image",data) THEN
          type:=V.GetImageEntry(data);
          IF type>=0 THEN
            image:=CreateVecImage(type);
          ELSE
            image:=CreateVecImage(V.none);
          END;
        END;
      ELSIF data="file" THEN
        IF top.GetStringEntry("normal",data) THEN
          data2:="";
          IF top.GetStringEntry("selected",data2) THEN
          END;
          image:=CreateFileImage(data,data2);
        END;
      END;
    END;
  END LoadImage;

  PROCEDURE SaveImage*(top : PP.BlockItem; name : ARRAY OF CHAR; image : Image);

  VAR
    block : PP.BlockItem;

  BEGIN
    block:=PP.CreateBlockItem(name);
    top.AddItem(block);

    IF image#NIL THEN
      WITH
        image : VecImage DO
        block.AddItemValue("type","internal");
        block.AddItemValue("image",V.images[image.image.type]);
      | image : FileImage DO
        block.AddItemValue("type","file");
        block.AddItemValue("normal",image.normalName^);
        IF (image.selectName#NIL) & (image.selectName^#"") THEN
          block.AddItemValue("selected",image.selectName^);
        END;
      END;
    END;
  END SaveImage;

END VO:Base:Image.