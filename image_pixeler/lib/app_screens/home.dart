import 'dart:convert';
import 'dart:io' as IO;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pixeler/models/Pixel.dart';
import 'package:image_pixeler/models/database.dart' as DB;
import 'package:image_pixeler/models/Utility.dart' as UTIL;

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => new _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Image _board_image_img = loadArtboardImage();
  List<Pixel> header_pixels = getHeaderPixels();

  Image getHeaderIndex({int idx=0}){
    double W = MediaQuery.of(context).size.width / 3;

    if( (header_pixels?.length??-1) >= idx){
      return Image.memory(header_pixels[idx].get_core(w:W.toInt(), h:W.toInt()).getBytes());
    }else{
      String fname = "assets/Pixel$idx.jpg";
      return Image(image: AssetImage(fname), width: W, height: W);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('ImagePixelerApp'),
        ),
        body: new Container(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Showing board image:
                //TODO: Encapsule images inside fixed sized containers
                new Container(
                  child: _board_image_img,
                  padding: const EdgeInsets.all(2.0),
                ),

                FloatingActionButton.extended(
                    icon: Icon(Icons.add),
                    key: null,
                    onPressed: () async {
                      // Adding new image to database:
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.gallery);

                      var db_helper = DB.DBHelper();
                      var img_bytes = image.readAsBytes();
                      img_bytes.then((byte_list) {
                        db_helper.saveArtboard(base64Encode(byte_list));
                      });

                      // Updating the header image
                      setState(() {
                        _board_image_img = Image.memory(image.readAsBytesSync());
                      });
                      // ------------------------------
                    },
                    label: new Text(
                      "Choose artboard image",
                      style: UTIL.button_text_styles,
                    )),

                new Text(
                  "Pixel gallery",
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
                      getHeaderIndex(idx: 0),
                      getHeaderIndex(idx: 1),
                      new IconButton(icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(context, "/gallery");
                        },
                      )
                    ]),

                new FlatButton(
                    key: null,
                    onPressed: () {
                      Navigator.pushNamed(context, "/generate");
                    },
                    child: new Text(
                      "Generate",
                      style: UTIL.button_text_styles,
                    )),
                new FlatButton(
                    key: null,
                    onPressed: () {
                      Navigator.pushNamed(context, "/about");
                    },
                    child: new Text(
                      "About and License Agreement",
                      style: UTIL.button_text_styles,
                    ))
              ]),
          padding: const EdgeInsets.all(5.0),
          alignment: Alignment.center,
        ));
  }
}

List<Pixel> getHeaderPixels() {
  var db_helper = DB.DBHelper();
  var pixel_list = db_helper.getPixels(need: 2);
  pixel_list.then((plist) {
    return plist;
  });
}

Image loadArtboardImage(){
  var imloader = rootBundle.load('assets/Artboard.jpg');
  imloader.then(
      (board_bytes){
        Uint8List board_bytes_ui8 = board_bytes.buffer.asUint8List();
        return Image.memory(board_bytes_ui8);
      }
  );
}