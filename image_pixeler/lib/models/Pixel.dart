import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:image/image.dart';

class Pixel{
  int _id;
  // Original image of size 256x256x3
  String _base64Image;

  // Storing size for future purposes
  int _height;
  int _width;

  // Core is a 16x16x3 thumbnail that is used for comparing Pixels
  String _core;

  // Defining class constructors
  Pixel(this._id, this._width, this._height, this._base64Image, this._core);

  Pixel.fromImage(Image img){
    this._id = 0;
    this.import(img);
  }


  // DB-related functions
  int getId(){
    return _id;
  }
  int getHeightRaw(){
    return _height;
  }
  int getWidthRaw(){
    return _width;
  }
  String getCoreRaw(){
    return _core;
  }
  String getBaseRaw(){
    return _base64Image;
  }


  void import(Image image){
    int w_size = max(image.height, image.width);

    // Crop the original image into a square image
    if(w_size > image.height){
      image = copyCrop(image, (image.width - w_size) >> 1 , 0, w_size, w_size);
    }else{
      image = copyCrop(image, 0, (image.height - w_size) >> 1, w_size, w_size);
    }

    // Storing two copies of image, a core and a base
    Image base = copyResize(image, width: 256, height: 256);
    Image core = copyResize(base, width: 16, height: 16);

    _base64Image = base64Encode(base.getBytes());
    _core = base64Encode(core.getBytes());
  }

  Image resize(int h_new, int w_new){
    final bytes =  Base64Decoder().convert(_base64Image);
    Image img = decodeImage(bytes);
    return copyResize(img, width: w_new, height: h_new);
  }

  Image get_core(){
    final bytes =  Base64Decoder().convert(_core);
    Image img = decodeImage(bytes);
    return img;
  }

  int compare_pixels(int p1, int p2){
    int d_sum = 0;
    for(var i=0; i<3; i++){
      int cdiff = (p1 % (1<<8)) - (p2 % (1<<8));
      d_sum += cdiff.abs();
      p1 = p1 >> 8;
      p2 = p2 >> 8;
    }
    return d_sum;
  }

  int compare_score(Pixel other){
    // TODO: Pyramid compare, create different levels of sizes, more weight on smaller sizes
    Image img1 = this.get_core();
    Image img2 = other.get_core();

    int d_sum = 0;
    for(var i=0; i<16; i++){
      for(var j=0; j<16; j++){
        d_sum = d_sum + this.compare_pixels(img1.getPixelSafe(i, j), img2.getPixelSafe(i, j));
      }
    }
    return d_sum;
  }
}
