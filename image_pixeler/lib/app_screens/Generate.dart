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

  double getArtboardSize() {
    double W = MediaQuery.of(context).size.width;
    double H = MediaQuery.of(context).size.height;
    if (W > H) {
      return H / 3;
    } else {
      return W / 1.2;
    }
  }

  double getTargetSize() {
    double W = MediaQuery.of(context).size.width;
    double H = MediaQuery.of(context).size.height;
    if (W > H) {
      return H / 6;
    } else {
      return W / 2.4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Artboard generated successfuly'),
      ),
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

              Container(
                child:getArtboadTarget(),
                width: getTargetSize(),
                height: getTargetSize(),
              ),
              new Text(
                "Pixel Image",
                style: new TextStyle(fontSize:26.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto"),
              ),

              Container(
                child: getArtboadBoard(),
                height: getArtboardSize(),
                width: getArtboardSize(),
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
