import 'package:image/image.dart' as IMG;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image_pixeler/models/database.dart' as DB;
import 'package:image_pixeler/models/Pixel.dart';
import 'package:image_pixeler/models/Utility.dart' as UTIL;
import 'package:fancy_dialog/fancy_dialog.dart' as DIALOG;
import 'package:fancy_dialog/FancyTheme.dart' as DIALOG_THEME;

class Gallery extends StatefulWidget {
  Gallery({Key key}) : super(key: key);
  @override
  _GalleryState createState() => new _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<Pixel> pList = new List<Pixel>();

  @override
  void initState(){
    var getPlistAsync = getPixelList();
    getPlistAsync.then((plist){
     setState(() {
       this.pList = plist;
     });
    });
    super.initState();
  }

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
                      child: new OutlineButton(key: null,
                          onPressed: () async {
                            // Adding new image to database:
                            var image = await ImagePicker.pickImage(
                                source: ImageSource.gallery);

                            IMG.Image img = IMG.decodeImage(
                                image.readAsBytesSync());
                            Pixel newPixel = new Pixel.fromImage(img);
                            var dbHelper = DB.DBHelper();
                            dbHelper.savePixel(newPixel);
                            // ------------------------------
                            var plist = await getPixelList();
                            setState(() { this.pList = plist; });
                          },
                          child:
                          new Text(
                            "Add new pixel",
                            style: UTIL.buttonTextStylesFlat,
                          )
                      ),
                      padding: const EdgeInsets.all(5.0),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2.1,
                    ),
                    Container(
                      child: new OutlineButton(key: null,
                          onPressed: (){
                            showDialog(context: context,
                                builder: (BuildContext context) => DIALOG.FancyDialog(
                                    title: "Remove all pixels?",
                                    descreption: "Are you sure you want to delete all pixels at onces?",
                                    ok: "Yes",
                                    cancel: "No",
                                    okColor: Colors.lightGreen,
                                    cancelColor: Colors.redAccent,
                                    theme: DIALOG_THEME.FancyTheme.FANCY,
                                    okFun: ()async {
                                      var dbHelper = DB.DBHelper();
                                      await dbHelper.deleteAllPixels();
                                      var plist = await getPixelList();
                                      setState(() {
                                        this.pList = plist;
                                      });
                                      },
                                    cancelFun: (){},
                                )
                            );
                          },
                          child:
                          new Text(
                            "Remove all",
                            style: UTIL.buttonTextStylesFlat,
                          )
                      ),
                      padding: const EdgeInsets.all(5.0),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2.1,
                    ),

                  ]

              ),

              new Expanded(child: ListView(children: getGalleryRows(MediaQuery.of(context).size.width), scrollDirection: Axis.vertical, shrinkWrap: true))

            ]

        ),

        padding: const EdgeInsets.all(5.0),
        alignment: Alignment.center,
      ),
    );
  }


  List<Pixel> loadDefaultPixels() {
    List<Pixel> plist = new List<Pixel>();
    for (int i = 0; i < 8; i++) {
      Pixel px = Pixel.fromFileName("assets/Pixel$i.jpg");
      px.is_default = true;
      plist.add(px);
    }
    return plist;
  }


  Future <List<Pixel>> getPixelList() async{
    //return loadDefaultPixels();
    var dbHelper = DB.DBHelper();
    var plist = await dbHelper.getPixels();

      if ((plist?.length ?? -1) <= 0) {
        plist = loadDefaultPixels();
      }

    return plist;
  }

  void deleteSinglePixel(bool is_default, int pixleId) async{
    if (!is_default) {

      bool okToDelete = false;

      showDialog(context: context,
          builder: (BuildContext context) => DIALOG.FancyDialog(
            title: "Remove this pixel?",
            descreption: "Are you sure you want to delete this pixel?",
            ok: "Yes",
            cancel: "No",
            okColor: Colors.lightGreen,
            cancelColor: Colors.redAccent,
            theme: DIALOG_THEME.FancyTheme.FANCY,
            okFun: (){ okToDelete = true;},
            cancelFun: (){ okToDelete = false;},
          )
      );

      if(okToDelete){
        var db_helper = DB.DBHelper();
        await db_helper.deletePixelById( pixleId );
        var plist = await getPixelList();
        setState((){ this.pList = plist; });
      }
    }
  }

 List<Widget>  getGalleryRows(double W){
    List<Widget> rowList = new List<Widget>();
    List<Pixel> plist = pList;

    for (int it = 0; it < plist.length; it++) {
      Widget pxRow = new Card(
          elevation: 5,
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(child: plist[it].pixel2Widget(),
                  height: W / 3,
                  width: W / 3,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5)
                    ],),),

                new Column(
                  children: <Widget>[
                    Text("average"),
                    Container(
                      child: plist[it].getEstimatedPixel(),
                      height: W / 6,
                      width: W / 6,
                    )
                  ],
                ),

                new IconButton(icon: Icon(Icons.delete),
                    iconSize: 36,
                    color: Colors.redAccent,
                    onPressed: () => {this.deleteSinglePixel(plist[it].is_default, plist[it].getId())}
                ),
              ]
          )
      );

      rowList.add(pxRow);
    }
    return rowList;
  }


}