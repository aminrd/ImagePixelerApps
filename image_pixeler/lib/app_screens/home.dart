import 'dart:convert';
import 'dart:io' as IO;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pixeler/models/Pixel.dart';

import 'package:image_pixeler/models/database.dart' as DB;

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => new _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //TODO: how to define a default state in flutter
  IO.File _board_image = IO.File("./assets/Artboard.jpg");
  List<Pixel> header_pixels = getHeaderPixels();

  @override
  void setState(fn) {
    _board_image = IO.File("./assets/Artboard.jpg");
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('ImagePixelerApp'),
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Showing board image:
            //TODO: Encapsule images inside fixed sized containers
            Image.file(_board_image),

            FloatingActionButton.extended(
                icon: Icon(Icons.add),
                key: null,
                onPressed: () async {
                  // Adding new image to database:
                  var image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);

                  var db_helper = DB.DBHelper();
                  var img_bytes = image.readAsBytes();
                  img_bytes.then( (byte_list){ db_helper.saveArtboard(base64Encode(byte_list)); } );

                  // Updating the header image
                  setState(() {
                    _board_image = image;
                  });
                  // ------------------------------
                },
                label: new Text(
                  "Choose artboard image",
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto"),
                )),

            new Text(
              "Edit your gallery",
              style: new TextStyle(
                  fontSize: 25.0,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Roboto"),
            ),
            new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //TODO: Get top two list
                  Image.memory(header_pixels[0].get_core().getBytes()),
                  Image.memory(header_pixels[1].get_core().getBytes()),
                  new FlatButton(
                      key: null,
                      onPressed: () {
                        Navigator.pushNamed(context, "/gallery");
                      },
                      child: new Text(
                        "Edit",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto"),
                      ))
                ]),
            new FlatButton(
                key: null,
                onPressed: () {
                  Navigator.pushNamed(context, "/generate");
                },
                child: new Text(
                  "Generate",
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto"),
                )),
            new FlatButton(
                key: null,
                onPressed: (){
                  Navigator.pushNamed(context, "/about");
                },
                child: new Text(
                  "About and License Agreement",
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto"),
                ))
          ]),
    );
  }

}


List<Pixel> getHeaderPixels(){
  var db_helper = DB.DBHelper();
  var pixel_list =  db_helper.getPixels(need: 2);
  pixel_list.then(
      (plist){
        return plist;
      }
  );
}