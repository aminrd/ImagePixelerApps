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
      appBar: new AppBar(
        title: new Text('Pixel Gallery'),
      ),
      body:
      new Container(
        child:
        new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                    child: new OutlineButton(key:null,
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
                          style: UTIL.button_text_styles_flat,
                        )
                    ),
                      padding: const EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width / 2.1,
                    ),
                    Container(
                      child: new OutlineButton(key:null,
                          onPressed:(){
                            //TODO: Add confirm dialog before deleting all pixels
                            var db_helper = DBHelper();
                            db_helper.deleteAllPixels();
                          },
                          child:
                          new Text(
                            "Remove all",
                            style: UTIL.button_text_styles_flat,
                          )
                      ),
                      padding: const EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width / 2.1,
                    ),

                  ]

              ),

              new Expanded(child: ListView( children: getGalleryRows( MediaQuery.of(context).size.width ), scrollDirection: Axis.vertical, shrinkWrap: true))

            ]

        ),

        padding: const EdgeInsets.all(5.0),
        alignment: Alignment.center,
      ),

    );
  }
}


//TODO: handle even if no image was given**
List<Widget> getGalleryRows(double W){
  List<Widget> row_list = new List<Widget>();


  for(int i=0; i<8; i++){
    Widget px_row = new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(child:Image(image: AssetImage("assets/Pixel$i.jpg"), width: W/3, height: W/3),padding: const EdgeInsets.all(5.0),),
          new IconButton(icon: Icon(Icons.delete),
              onPressed: (){
                //var db_helper_del = DBHelper();
                //db_helper_del.deletePixel(pixel);
              }
          ),
        ]
    );

    row_list.add(px_row);
  }
  //TODO: Make rows beautiful with lines and alignment, ...
  return row_list;


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
