import 'package:flutter/material.dart';

// Import app pages:
import './app_screens/home.dart';
import './app_screens/Generate.dart';
import './app_screens/Gallery.dart';
import './app_screens/About.dart';

void main() {
  runApp(new MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Image Pixeler App',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.amber,
        primaryColor: const Color(0xFFffc107),
        accentColor: const Color(0xFFffc107),
        canvasColor: const Color(0xFFfafafa),
        fontFamily: 'Merriweather',
      ),
      //home: Homepage(),
      routes: { // Defining routs
        "/": (BuildContext context) => Homepage(),
        "/gallery": (BuildContext context) => Gallery(),
        "/generate": (BuildContext context) => Generate(),
        "/about": (BuildContext context) => About(),
      },
    );
  }
}

