import 'package:flutter/material.dart';
import 'dart:io' as IO;
import 'package:image_pixeler/models/database.dart' as DB;
import 'package:image_pixeler/models/Artboard.dart';
import 'package:image_pixeler/models/Pixel.dart';

class Generate extends StatefulWidget {
  Generate({Key key}) : super(key: key);
  @override
  _GenerateState createState() => new _GenerateState();
}

class _GenerateState extends State<Generate> {
  Artboard artboard = generate_artboard();

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

              new Image.memory(artboard.getTarget().getBytes()),
              new Text(
                "Pixel Image",
                style: new TextStyle(fontSize:26.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto"),
              ),

              new Image.memory(artboard.getArtBoard().getBytes()),

              new RaisedButton(key:null,
                onPressed: (){
                  Navigator.of(context).pop();
                },
                  child:
                  new Text(
                    "Back to Home",
                    style: new TextStyle(fontSize:12.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                  )
              ),

              new RaisedButton(key:null, onPressed:buttonPressed,
                  color: const Color(0xFFe0e0e0),
                  child:
                  new Text(
                    "Save Image",
                    style: new TextStyle(fontSize:12.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                  )
              )
            ]

        ),

        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.center,
      ),

    );
  }
  void buttonPressed(){}

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
