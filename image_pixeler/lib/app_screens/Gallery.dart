import 'dart:convert';
import 'dart:ui';
import 'package:image/image.dart' as IMG;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image_pixeler/models/database.dart' as DB;
import 'package:image_pixeler/models/Pixel.dart';
import 'package:image_pixeler/models/Utility.dart' as UTIL;
import 'dart:io' as IO;

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
                          var db_helper = DB.DBHelper();
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
                            var db_helper = DB.DBHelper();
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



List<Pixel> loadDefaultPixels(){
  List<Pixel> plist = new List<Pixel>();
  for(int i=0; i<8; i++){
    Pixel px = Pixel.fromFile(IO.File("assets/Pixel$i.jpg"));
    plist.add(px);
  }
  return plist;
}


List<Pixel> getPixelList(){
  List<Widget> row_list = new List<Widget>();
  var db_helper = DB.DBHelper();
  Future<List<Pixel>> plist_future = db_helper.getPixels();

  plist_future.timeout(const Duration (seconds:10),onTimeout : (){return loadDefaultPixels();});
  plist_future.catchError((e){return loadDefaultPixels();});
  plist_future.then( (plist){
    if( (plist?.length ?? -1) < 0 ){
      return loadDefaultPixels();
    }else{
      return plist;
    }
  });
}


List<Widget> getGalleryRows(double W){
  List<Widget> row_list = new List<Widget>();
  var db_helper = DB.DBHelper();
  List<Pixel> plist = getPixelList();

  for(Pixel pixel in plist){
    Widget px_row = new Card(
      elevation: 5,
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(child:pixel.pixel2Widget(), height: W/3, width: W/3 ,padding: const EdgeInsets.all(5.0), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],),),

            new Column(
              children: <Widget>[
                Text("average"),
                Container(
                  child: pixel.getEstimatedPixel(),
                  height: W/6,
                  width: W/6,
                )
              ],
            ),

            new IconButton(icon: Icon(Icons.delete),
                iconSize: 36,
                color: Colors.redAccent,
                onPressed: (){
                  //var db_helper_del = DBHelper();
                  //db_helper_del.deletePixel(pixel);
                }
            ),
          ]
      )
    );


    row_list.add(px_row);
  }

  return row_list;
}


