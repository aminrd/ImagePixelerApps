import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as IMG;
import 'dart:io' as IO;
import 'dart:math' as MATH;


List<int> getRandomImage({size:256}){
  int R = Random().nextInt(255);
  int G = Random().nextInt(255);
  int B = Random().nextInt(255);

  IMG.Image rndImage = new IMG.Image.rgb(size, size);
  for(int i=0; i<size; i++){
    for(int j=0; j<size; j++){
      rndImage.setPixelRgba(i, j, R, G, B);
    }
  }
  return IMG.encodeJpg(rndImage);
}


class Pixel{
  int _id = 0;
  // Original image of size 256x256x3
  String _base64Image = base64Encode( getRandomImage(size:256) );

  // Storing size for future purposes
  int _height = 256;
  int _width = 256;

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
    IMG.Image loadImageConverted = IMG.decodeImage(file.readAsBytesSync());
    this.import(loadImageConverted);
  }

  Pixel.fromFileName(String name){
    var fnameFuture = rootBundle.load(name);
    fnameFuture.then((byteData){
      this._id = 0;
      IMG.Image loadImage = IMG.decodeImage(byteData.buffer.asUint8List());
      this.import(loadImage);
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
    int wSize = min(image.height, image.width);

    // Crop the original image into a square image
    if(image.height != image.width){
      if(wSize < image.width){
        image = IMG.copyCrop(image, (image.width - wSize) >> 1 , 0, wSize, wSize);
      }else{
        image = IMG.copyCrop(image, 0, (image.height - wSize) >> 1, wSize, wSize);
      }
    }
    // Storing two copies of image, a core and a base
    IMG.Image base = IMG.copyResize(image, width: 256, height: 256);
    IMG.Image core = IMG.copyResize(base, width: 16, height: 16);
    
    this._base64Image = base64Encode(IMG.encodeJpg(base));
    this._core = base64Encode(IMG.encodeJpg((core)));
  }

  IMG.Image resize(int hNew, int wNew){
    final bytes =  Base64Decoder().convert(_base64Image);
    IMG.Image img = IMG.decodeImage(bytes);
    return IMG.copyResize(img, width: wNew, height: hNew);
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

  IMG.Image getBase({int w = -1, int h = -1}){
    final bytes =  base64Decode(this._base64Image);
    IMG.Image img = IMG.decodeImage(bytes);
    if(w < 0 || h < 0){
      return img;
    }else{
      return IMG.copyResize(img, width: w, height: h);
    }
  }

  double compare_pixels(int p1, int p2){
    int dSum = 0;
    for(var i=0; i<3; i++){
      int cdiff = (p1 % (1<<8)) - (p2 % (1<<8));
      dSum += cdiff * cdiff;
      p1 = p1 >> 8;
      p2 = p2 >> 8;
    }
    return MATH.sqrt(dSum);
  }

  double compare2Image(IMG.Image img1, IMG.Image img2){
    if(img1.width != img2.width || img1.height != img2.height){
      return (1<<30).toDouble(); // A large number
    }
    double dSum = 0.0;
    for(int i=0; i<img1.width; i++){
      for(int j=0; j<img1.height; j++){
        dSum += this.compare_pixels(img1.getPixelSafe(i, j), img2.getPixelSafe(i, j));
      }
    }
    return dSum;
  }

  double compare_score(Pixel other){
    // Pyramid comparison
    IMG.Image img1 = this.get_core();
    IMG.Image img2 = other.get_core();

    double dSum = 0;
    int wSum = 0;

    // Main size is 16x16
    List<int> slist = [1,2,4,8];
    for(int k=0; k<slist.length; k++){
      int weight = slist[k] * slist[k];
      int newSize = 16 ~/ slist[k];
      wSum += weight;
      dSum += weight * this.compare2Image(IMG.copyResize(img1, width: newSize, height: newSize), IMG.copyResize(img2, width: newSize, height: newSize));
    }

    return dSum / wSum;
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


  Map<String, dynamic> toMap(){
    return{
      'width': _width,
      'height': _height,
      'baseImage': this.getBaseRaw(),
      'coreImage': this.getCoreRaw()
    };
  }
}
