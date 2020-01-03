import 'dart:convert';
import 'package:image/image.dart';

class Pixel{
  // Original image of size 256x256x3
  String _base64Image;

  // Storing size for future purposes
  int _height;
  int _width;

  // Core is a 16x16x3 thumbnail that is used for comparing Pixels
  String _core;

  Image resize(int h_new, int w_new){
    final bytes =  Base64Decoder().convert(_base64Image);
    Image img = decodeImage(bytes);
    return copyResize(img, width: w_new, height: h_new);
  }
  int compare_score(Pixel other){

  }
}