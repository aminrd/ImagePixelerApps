import 'package:flutter/material.dart';
import 'package:image_pixeler/models/Artboard.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart' as IMG_SAVER;
import 'package:image_pixeler/models/Utility.dart' as UTIL;
import 'package:get_it/get_it.dart' as GET_IT;
import 'package:fancy_dialog/fancy_dialog.dart' as DIALOG;
import 'package:fancy_dialog/FancyTheme.dart' as DIALOG_THEME;
import 'dart:typed_data';

class Generate extends StatefulWidget {
  Generate({Key key}) : super(key: key);
  @override
  _GenerateState createState() => new _GenerateState();
}

class _GenerateState extends State<Generate> {
  GET_IT.GetIt locator = GET_IT.GetIt.instance;

  Image getArtboadTarget(){
    Artboard abManager = locator.get<Artboard>();
    return abManager.target2Widget();
  }
  Image getArtboadBoard(){
    Artboard abManager = locator.get<Artboard>();
    return abManager.board2Widget();
  }
  Uint8List getSavable(){
    Artboard abManager = locator.get<Artboard>();
    return abManager.getSavable();
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

              Row(
                children: <Widget>[
                  new Text(
                    "Original Image",
                    style: new TextStyle(fontSize:24.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto"),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
              ),

              Container(
                child:getArtboadTarget(),
                width: getTargetSize(),
                height: getTargetSize(),
                padding: const EdgeInsets.all(5.0),
              ),
              new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text(
                  "Artboard Image",
                  style: new TextStyle(fontSize:26.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto"),
                )],
              ),

              Container(
                child: getArtboadBoard(),
                height: getArtboardSize(),
                width: getArtboardSize(),
                padding: const EdgeInsets.all(5.0),
              ),

              new FloatingActionButton.extended(
                  heroTag: "SaveImage",
                  icon: Icon(Icons.save_alt, color: Colors.white,),
                  key: null,
                  onPressed:() async{
                    // Saving the generated artboard to device gallery
                    await IMG_SAVER.ImageGallerySaver.saveImage(getSavable());
                        showDialog(context: context,
                          builder: (BuildContext context) => DIALOG.FancyDialog(
                              title: "Done",
                              okColor: Colors.blueAccent,
                              cancelColor: const Color(0xFFffc107),
                              descreption: "The artboard was successfully saved to your device gallery",
                              theme: DIALOG_THEME.FancyTheme.FANCY,
                          )
                    );
                  },
                  label: new Text(
                    "Save Image",
                    style: UTIL.buttonTextStyles,
                  ))
            ]

        ),

        padding: const EdgeInsets.all(5.0),
        alignment: Alignment.center,
      ),

    );
  }

}
