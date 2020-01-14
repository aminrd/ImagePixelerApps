import 'package:flutter/material.dart';
import 'dart:io' as IO;
import 'package:image_pixeler/models/database.dart' as DB;
import 'package:image_pixeler/models/Artboard.dart';
import 'package:image_pixeler/models/Pixel.dart';

class About extends StatelessWidget {
  About({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //TODO: move the back button to the top in blue
    //TODO: make a scrollable about
    return new Scaffold(
      body:
      new Container(
        child:
        new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Image(image: AssetImage("assets/Artboard.jpg")),

              new RichText(
                text: TextSpan(
                    text: "About",
                    style: new TextStyle(fontSize:30.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto"),
                    children: <TextSpan>[
                      // TODO: Replace with Github project's Readme
                      TextSpan(text: "MIT License"),
                      TextSpan(text: "Copyright (c) 2019 Amin Aghaee"),
                      TextSpan(text: "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:"),
                      TextSpan(text: "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software."),
                      TextSpan(text: "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."),
                    ]
                ),
              ),


              new RichText(
                text: TextSpan(
                  text: "License",
                  style: new TextStyle(fontSize:30.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto"),
                      children: <TextSpan>[
                        TextSpan(text: "MIT License"),
                        TextSpan(text: "Copyright (c) 2019 Amin Aghaee"),
                        TextSpan(text: "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:"),
                        TextSpan(text: "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software."),
                        TextSpan(text: "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."),
                      ]
                ),
              ),

              new RaisedButton(key:null,
                  onPressed:(){
                    Navigator.of(context).pop();
                  },
                  color: const Color(0xFFe0e0e0),
                  child:
                  new Text(
                    "Save Image",
                    style: new TextStyle(fontSize:12.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w400,
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
}
