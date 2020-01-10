import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

              new ListView(
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Image.network(
                          'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',
                          fit:BoxFit.fill,
                        ),

                        new Radio(key:null, groupValue: null, value: .5, onChanged: radioChanged)
                      ]

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

  void radioChanged(double value) {}

}