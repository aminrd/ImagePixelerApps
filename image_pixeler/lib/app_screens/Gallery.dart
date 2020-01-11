import 'package:flutter/material.dart';
import 'package:image_pixeler/models/database.dart';
import 'package:image_pixeler/models/Pixel.dart';

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
        title: new Text('App Name'),
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
                "Your Pixel Gallery",
                style: new TextStyle(fontSize:20.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto"),
              ),

              new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new FlatButton(key:null, onPressed:buttonPressed,
                        child:
                        new Text(
                          "Add new pixel",
                          style: new TextStyle(fontSize:20.0,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto"),
                        )
                    ),

                    new FlatButton(key:null, onPressed:buttonPressed,
                        child:
                        new Text(
                          "Remove selected",
                          style: new TextStyle(fontSize:16.0,
                              color: const Color(0xFFce2323),
                              fontWeight: FontWeight.w300,
                              fontFamily: "Roboto"),
                        )
                    ),

                    new FlatButton(key:null, onPressed:buttonPressed,
                        child:
                        new Text(
                          "Remove all",
                          style: new TextStyle(fontSize:12.0,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w200,
                              fontFamily: "Roboto"),
                        )
                    )
                  ]

              ),

              ListView( children: getGalleryRows())
            ]

        ),

        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.center,
      ),

    );
  }
  void buttonPressed(){}

  void radioChanged(double value) {}

}



List<Widget> getGalleryRows(){
  List<Widget> row_list = new List<Widget>();
  var db_helper = DBHelper();
  Future<List<Pixel>> plist_future = db_helper.getPixels();
  
  plist_future.then( (plist) {

    for(Pixel pixel in plist){
     Widget px_row = new Row(
         mainAxisAlignment: MainAxisAlignment.start,
         mainAxisSize: MainAxisSize.max,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: <Widget>[
           new Image.network(
             'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',
             fit:BoxFit.fill,
           ),

           new RaisedButton(key:null,
               onPressed: (){
                 var db_helper_del = DBHelper();
                 db_helper_del.deletePixel(pixel);
               },
               child:
               new Text(
                 "Delete",
                 style: new TextStyle(fontSize:12.0,
                     color: const Color(0xFF000000),
                     fontWeight: FontWeight.w200,
                     fontFamily: "Roboto"),
               )
           ),

         ]

     );

     row_list.add(px_row);
    }
  });
  return row_list;
}
