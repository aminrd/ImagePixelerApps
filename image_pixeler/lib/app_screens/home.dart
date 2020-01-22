import 'dart:io' as IO;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pixeler/models/Artboard.dart';
import 'package:image_pixeler/models/Pixel.dart';
import 'package:image_pixeler/models/database.dart' as DB;
import 'package:image_pixeler/models/Utility.dart' as UTIL;
import 'package:get_it/get_it.dart' as GET_IT;

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => new _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Image _board_image_img = Image(image: AssetImage('assets/Artboard.jpg'));
  List<Pixel> header_pixels = getHeaderPixels();
  GET_IT.GetIt locator = GET_IT.GetIt.instance;

  double getArtboardSize() {
    double W = MediaQuery.of(context).size.width;
    double H = MediaQuery.of(context).size.height;
    if (W > H) {
      return H / 1.5;
    } else {
      return W / 1.2;
    }
  }

  Image getHeaderIndex({int idx = 0}) {
    if ((header_pixels?.length ?? -1) > idx) {
      return header_pixels[idx].pixel2Widget();
    } else {
      String fname = "assets/Pixel$idx.jpg";
      return Image(image: AssetImage(fname));
    }
  }

  List<Widget> getSampleRow() {
    List<Widget> myRow = new List<Widget>();

    double W = MediaQuery.of(context).size.width;
    double H = MediaQuery.of(context).size.height;

    if (H > W) {
      for (int i = 0; i < 2; i++) {
        myRow.add(Container(
          child: getHeaderIndex(idx: i),
          padding: const EdgeInsets.all(4.0),
          height: W/4,
          width: W/4,
        ));
      }
    } else {
      for (int i = 0; i < 8; i++) {
        myRow.add(Container(
          child: getHeaderIndex(idx: i),
          padding: const EdgeInsets.all(4.0),
          width: W / 10,
          height: W / 10,
        ));
      }
    }

    // Static add
    myRow.add(Icon(
      Icons.view_week,
      color: Colors.black38,
      size: 40.0,
      semanticLabel: 'and more',
    ));

    // Static add
    myRow.add(Center(
      child: Ink(
        decoration: const ShapeDecoration(
          color: Colors.blueAccent,
          shape: CircleBorder(),
        ),
        child: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(context, "/gallery");
          },
          padding: const EdgeInsets.all(20.0),
          color: Colors.white,
        ),
      ),
    ));

    return myRow;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome to Image Pixeler'),
        ),
        body: new Container(
          child: new ListView(
              //mainAxisAlignment: MainAxisAlignment.start,
              //mainAxisSize: MainAxisSize.max,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Showing board image:
                new Container(
                  child: _board_image_img,
                  width: getArtboardSize(),
                  height: getArtboardSize(),
                  padding: const EdgeInsets.all(5.0),
                ),

                new Container(
                  child: FloatingActionButton.extended(
                    heroTag: "Choosing Image",
                      icon: Icon(Icons.add_a_photo, color: Colors.white,),
                      key: null,
                      onPressed: () async {
                        // Adding new image to database:
                        var image = await ImagePicker.pickImage(
                            source: ImageSource.gallery);

                        Artboard abManager = locator.get<Artboard>();
                        abManager.importFile(image);

                        // Updating the header image
                        setState(() {
                          _board_image_img =
                              Image.memory(image.readAsBytesSync());

                          Artboard abManager = locator.get<Artboard>();
                          abManager.importFile(image);
                        });
                        // ------------------------------
                      },
                      label: new Text(
                        "Choose artboard image",
                        style: UTIL.buttonTextStyles,
                      )),
                  width: getArtboardSize(),
                ),

                new Container(
                  child: new Text(
                    "Pixel gallery",
                    style: new TextStyle(
                        fontSize: 25.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto"),
                  ),
                  padding: const EdgeInsets.all(15.0),
                  alignment: Alignment.center,
                ),

                Container(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: getSampleRow(),
                  ),
                  alignment: Alignment.center,
                ),

                Container(
                  child: FloatingActionButton.extended(
                      heroTag: "Generating Image",
                      icon: Icon(Icons.star_half, color: Colors.white,),
                      key: null,
                      onPressed: () {
                        Artboard abManager = locator.get<Artboard>();
                        abManager.build( getPixelList() );
                        Navigator.pushNamed(context, "/generate");
                      },
                      label: new Text(
                        "Generate",
                        style: UTIL.buttonTextStyles,
                      )),
                  padding: const EdgeInsets.all(10.0),
                ),

                new FlatButton(
                    key: null,
                    onPressed: () {
                      Navigator.pushNamed(context, "/about");
                    },
                    child: new Text(
                      "About and License Agreement",
                      style: UTIL.buttonTextStylesFlat,
                    ))
              ]),
          padding: const EdgeInsets.all(5.0),
          alignment: Alignment.center,
        ));
  }
}

List<Pixel> getHeaderPixels() {
  var dbHelper = DB.DBHelper();
  List<Pixel> retVal = new List<Pixel>();
  var pixelList = dbHelper.getPixels(need: 2);
  pixelList.then((plist) {
    retVal =  plist;
  });
  return retVal;
}

List<Pixel> getPixelList(){
  var dbHelper = DB.DBHelper();
  Future<List<Pixel>> plistFuture = dbHelper.getPixels();
  List<Pixel> retVal = new List<Pixel>();

  plistFuture.then( (plist){
   if( (plist?.length ?? -1) <= 0 ){
      retVal = loadDefaultPixels();
    }else{
      retVal = plist;
    }
  });
  return retVal;
}

List<Pixel> loadDefaultPixels(){
  List<Pixel> plist = new List<Pixel>();
  for(int i=0; i<8; i++){
    Pixel px = Pixel.fromFile(IO.File("assets/Pixel$i.jpg"));
    px.is_default = true;
    plist.add(px);
  }
  return plist;
}