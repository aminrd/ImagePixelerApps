import 'dart:convert';
import 'dart:ui';
import 'package:image/image.dart' as IMG;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image_pixeler/models/database.dart';
import 'package:image_pixeler/models/Pixel.dart';
import 'package:image_pixeler/models/Utility.dart' as UTIL;

class Gallery extends StatefulWidget {
  Gallery({Key key}) : super(key: key);
  @override
  _GalleryState createState() => new _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:
      new Container(
        child:
        new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Text(
                "Your Pixel Gallery",
                textAlign: TextAlign.center,
                style: new TextStyle(fontSize:20.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto"),
              ),

              new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new FlatButton(key:null,
                        onPressed:() async{
                          // Adding new image to database:
                          var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                          //Image uiImage = new Image.file(image);
                          IMG.Image img = IMG.decodeImage(image.readAsBytesSync());
                          Pixel new_pixel = new Pixel.fromImage(img);
                          var db_helper = DBHelper();
                          db_helper.savePixel(new_pixel);
                          // ------------------------------
                        },
                        child:
                        new Text(
                          "Add new pixel",
                          style: UTIL.button_text_styles,
                        )
                    ),
                    new FlatButton(key:null,
                        onPressed:(){
                          Navigator.pop(context);
                        },
                        child:
                        new Text(
                          "Back to Home",
                          style: UTIL.button_text_styles,
                        )
                    ),
                    new FlatButton(key:null,
                        onPressed:(){
                            //TODO: Add confirm dialog before deleting all pixels
                            var db_helper = DBHelper();
                            db_helper.deleteAllPixels();
                        },
                        child:
                        new Text(
                          "Remove all",
                          style: UTIL.button_text_styles,
                        )
                    )
                  ]

              ),

              ListView( children: getGalleryRows(), scrollDirection: Axis.vertical, shrinkWrap: true)
            ]

        ),

        padding: const EdgeInsets.all(5.0),
        alignment: Alignment.center,
      ),

    );
  }
}


//TODO: handle even if no image was given
List<Widget> getGalleryRows(){
  List<Widget> row_list = new List<Widget>();
  var db_helper = DBHelper();
  Future<List<Pixel>> plist_future = db_helper.getPixels();
  
  plist_future.then( (plist) {

    for(Pixel pixel in plist){
     Widget px_row = new Row(
         mainAxisAlignment: MainAxisAlignment.start,
         mainAxisSize: MainAxisSize.max,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: <Widget>[
           new Image.memory(pixel.get_core(w: 16, h:16).getBytes()),
           new IconButton(icon: Icon(Icons.delete),
               onPressed: (){
                 var db_helper_del = DBHelper();
                 db_helper_del.deletePixel(pixel);
               }
           ),
         ]
     );

     row_list.add(px_row);
    }
  });
  return row_list;
}
