import 'dart:convert';
import 'dart:io' as IO;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image_pixeler/models/database.dart' as DB;

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => new _HomepageState();
}

class _HomepageState extends State<Homepage> {
  IO.File _board_image;
  
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
            new Text(
              "Choose your image",
              style: new TextStyle(
                  fontSize: 22.0,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Roboto"),
            ),
            new FlatButton(
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
                child: new Text(
                  "Flat Button 1",
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto"),
                )),

            // Showing board image:
            Image.file(_board_image),

            new Text(
              "Prepare your gallery",
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
                  new Image.network(
                    'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',
                    fit: BoxFit.fill,
                  ),
                  new Image.network(
                    'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',
                    fit: BoxFit.fill,
                  ),
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

  void buttonPressed() {}
}


