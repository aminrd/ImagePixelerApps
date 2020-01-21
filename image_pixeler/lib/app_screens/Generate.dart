import 'package:flutter/material.dart';
import 'dart:io' as IO;
import 'package:image_pixeler/models/database.dart' as DB;
import 'package:image_pixeler/models/Artboard.dart';
import 'package:image_pixeler/models/Pixel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart' as IMG_SAVER;
import 'package:image_pixeler/models/Utility.dart' as UTIL;
import 'package:get_it/get_it.dart' as GET_IT;
import 'dart:typed_data';

class Generate extends StatefulWidget {
  Generate({Key key}) : super(key: key);
  @override
  _GenerateState createState() => new _GenerateState();
}

class _GenerateState extends State<Generate> {
  GET_IT.GetIt locator = GET_IT.GetIt.instance;

  Image getArtboadTarget(){
    Artboard ab_manager = locator.get<Artboard>();
    return ab_manager.target2Widget();
  }
  Image getArtboadBoard(){
    Artboard ab_manager = locator.get<Artboard>();
    return ab_manager.board2Widget();
  }
  Uint8List getSavable(){
    Artboard ab_manager = locator.get<Artboard>();
    return ab_manager.getSavable();
  }
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
                "Original Image",
                style: new TextStyle(fontSize:24.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto"),
              ),

              getArtboadTarget(),
              new Text(
                "Pixel Image",
                style: new TextStyle(fontSize:26.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto"),
              ),

              getArtboadBoard(),

              new RaisedButton(key:null,
                onPressed: (){
                  Navigator.of(context).pop();
                },
                  child:
                  new Text(
                    "Back to Home",
                    style: UTIL.button_text_styles,
                  )
              ),

              new RaisedButton(key:null,
                  onPressed:() async{
                    // Saving the generated artboard to device gallery
                    final result = await IMG_SAVER.ImageGallerySaver.saveImage(getSavable());
                    print("Saving the generated image");
                  },
                  color: const Color(0xFFe0e0e0),
                  child:
                  new Text(
                    "Save Image",
                    style: UTIL.button_text_styles,
                  )
              )
            ]

        ),

        padding: const EdgeInsets.all(5.0),
        alignment: Alignment.center,
      ),

    );
  }

}


Artboard generate_artboard(){
  var db_helper = DB.DBHelper();
  var future_artboard = db_helper.getArtboard();
  var future_pixel_list = db_helper.getPixels();

  future_artboard.then(
      (artboard){
        future_pixel_list.then( (plist){
          artboard.build(plist);
        }
        );
        return artboard;
      }
  );
}
