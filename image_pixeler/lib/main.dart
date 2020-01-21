import 'package:flutter/material.dart';

// Import app pages:
import './app_screens/home.dart';
import './app_screens/Generate.dart';
import './app_screens/Gallery.dart';
import './app_screens/About.dart';
import 'package:get_it/get_it.dart' as GET_IT;


import 'package:image_pixeler/models/Artboard.dart';

// Registering Artboard in Get IT
GET_IT.GetIt locator = GET_IT.GetIt.instance;


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Artboard ab = Artboard.Default();
  locator.registerSingleton<Artboard>(ab);

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

