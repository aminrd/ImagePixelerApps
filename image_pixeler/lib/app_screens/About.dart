import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:io' as IO;
import 'package:image_pixeler/models/database.dart' as DB;
import 'package:image_pixeler/models/Artboard.dart';
import 'package:image_pixeler/models/Pixel.dart';
import 'package:url_launcher/url_launcher.dart' as URL;
import 'package:image_pixeler/models/Utility.dart' as UTIL;

class About extends StatefulWidget {
  About({Key key}) : super(key: key);

  @override
  _AboutState createState() => new _AboutState();
}

class _AboutState extends State<About> {
  TextStyle h1 = TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0);
  TextStyle h2 = TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0);
  TextStyle body = TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    //TODO: move the back button to the top in blue
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
              new Container(
                child: new Image(image: AssetImage("assets/Artboard_after.jpg")),
                padding: const EdgeInsets.all(2.0),
                alignment: Alignment.center,
              ),
              new Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: new RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                          text: "About and Lisence agreement\n\n",
                          style: new TextStyle(
                              fontSize: 30.0,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto"),
                          children: <TextSpan>[
                            TextSpan(
                                style: h2, text: "About Image Pixeler\n\n"),
                            TextSpan(
                                style: body,
                                text:
                                    "Image Pixeler is a platform to replace pixels, or group of pixels in an image, with other images. The initial idea was developed in Python. Details about the core engine is available at Image-Pixeler's github repository "),
                            TextSpan(
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20.0,
                                    color: Colors.blue),
                                text: "here",
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    URL.launch(
                                        'https://github.com/aminrd/Image-Pixeler/');
                                  }),
                            TextSpan(
                                style: body,
                                text:
                                    ". In this project, the main idea is expanded into iOS, Android and Web Applicatinos.\n\n"),
                            TextSpan(
                                style: body,
                                text:
                                    "This project is developed with Flutter framework which is an open-source UI software development kit created by Google. It is used to develop applications for Android, iOS, Windows, Mac, Linux, Google Fuchsia and the web. Flutter apps are written in the Dart language and make use of many of the language's more advanced features.\n\n"),
                            TextSpan(style: h2, text: "MIT License\n\n"),
                            TextSpan(
                                style: body,
                                text: "Copyright (c) 2019 Amin Aghaee\n\n"),
                            TextSpan(
                                style: body,
                                text:
                                    "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\n"),
                            TextSpan(
                                style: body,
                                text:
                                    "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n"),
                            TextSpan(
                                style: body,
                                text:
                                    "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n"),
                          ]),
                    ),
                  ))
            ]),
        padding: const EdgeInsets.all(5.0),
        alignment: Alignment.center,
      ),
    );
  }
}
