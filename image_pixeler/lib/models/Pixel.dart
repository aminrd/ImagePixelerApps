import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as IMG;
import 'dart:io' as IO;


List<int> getRandomImage({size:256}){
  int R = Random().nextInt(255);
  int G = Random().nextInt(255);
  int B = Random().nextInt(255);

  IMG.Image rnd_image = new IMG.Image.rgb(size, size);
  for(int i=0; i<size; i++){
    for(int j=0; j<size; j++){
      rnd_image.setPixelRgba(i, j, R, G, B);
    }
  }
  return IMG.encodeJpg(rnd_image);
}


class Pixel{
  int _id = 0;
  // Original image of size 256x256x3
  String _base64Image = base64Encode( getRandomImage(size:256) );

  // Storing size for future purposes
  int _height = 0;
  int _width = 0;

  bool is_default = false;

  // Core is a 16x16x3 thumbnail that is used for comparing Pixels
  String _core = base64Encode( getRandomImage(size:16) );

  // Defining class constructors
  Pixel(this._id, this._width, this._height, this._base64Image, this._core);

  Pixel.fromImage(IMG.Image img){
    this._id = 0;
    this.import(img);
  }

  Pixel.fromFile(IO.File file){
    this._id = 0;
    IMG.Image load_image_converted = IMG.decodeImage(file.readAsBytesSync());
    this.import(load_image_converted);
  }

  Pixel.fromFileName(String name){
    var fname_future = rootBundle.load(name);
    fname_future.then((byte_data){
      this._id = 0;
      IMG.Image load_image = IMG.decodeImage(byte_data.buffer.asUint8List());
      this.import(load_image);
    });
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

  void import(IMG.Image image){
    int w_size = min(image.height, image.width);

    // Crop the original image into a square image
    if(w_size < image.width){
      image = IMG.copyCrop(image, (image.width - w_size) >> 1 , 0, w_size, w_size);
    }else{
      image = IMG.copyCrop(image, 0, (image.height - w_size) >> 1, w_size, w_size);
    }

    // Storing two copies of image, a core and a base
    IMG.Image base = IMG.copyResize(image, width: 256, height: 256);
    IMG.Image core = IMG.copyResize(base, width: 16, height: 16);
    
    this._base64Image = base64Encode(IMG.encodeJpg(base));
    this._core = base64Encode(IMG.encodeJpg((core)));

  }

  IMG.Image resize(int h_new, int w_new){
    final bytes =  Base64Decoder().convert(_base64Image);
    IMG.Image img = IMG.decodeImage(bytes);
    return IMG.copyResize(img, width: w_new, height: h_new);
  }

  IMG.Image get_core({int w = -1, int h = -1}){
    final bytes =  base64Decode(this._core);
    IMG.Image img = IMG.decodeImage(bytes);
    if(w < 0 || h < 0){
      return img;
    }else{
      return IMG.copyResize(img, width: w, height: h);
    }
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
    IMG.Image img1 = this.get_core();
    IMG.Image img2 = other.get_core();

    int d_sum = 0;
    for(var i=0; i<16; i++){
      for(var j=0; j<16; j++){
        d_sum = d_sum + this.compare_pixels(img1.getPixelSafe(i, j), img2.getPixelSafe(i, j));
      }
    }
    return d_sum;
  }

  Image pixel2Widget(){
    final _byteImage = base64.decode(this._base64Image);
    Widget image = Image.memory(_byteImage);
    return image;
  }

  Image ImageConvertFlutter2Dart(IMG.Image img){
    String base64Image = base64Encode(IMG.encodeJpg(img));
    final _byteImage = Base64Decoder().convert(base64Image);
    Widget image = Image.memory(_byteImage);
    return image;
  }

  Image getEstimatedPixel({W:16, H:16}){
    IMG.Image cr = this.get_core();

    double avg = 0;
    for(int i=0; i<16; i++){
      for(int j=0; j<16; j++){
        avg += ( cr.getPixelSafe(i, j) / 256);
      }
    }

    IMG.Image output = IMG.Image.rgb(W, H);
    for(int i=0; i<W; i++){
      for(int j=0; j<H; j++){
        output.setPixelSafe(i, j, avg.toInt());
      }
    }
    return this.ImageConvertFlutter2Dart(output);
  }

  // Implementing operators


  Map<String, dynamic> toMap(){
    return{
      'width': _width,
      'height': _height,
      'baseImage': this.getBaseRaw(),
      'coreImage': this.getCoreRaw()
    };
  }
}
