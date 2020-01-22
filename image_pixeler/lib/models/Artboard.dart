import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as IMG;
import 'Pixel.dart';
import 'dart:io' as IO;


class Artboard{
  IMG.Image target = IMG.decodeJpg(getRandomImage()) ;
  IMG.Image board = IMG.decodeJpg(getRandomImage()) ;
  // Size: (1500 x 1500) for (2m x 2m) banner

  Artboard.fromString(String str){
    final bytes = Base64Decoder().convert(str);
    target = IMG.decodeImage(bytes);
    this.board = this.getTarget();
  }

  Artboard.Default(){
    var content_data_future = rootBundle.load("assets/Artboard.jpg");
    content_data_future.then((byte_data){
      this.target = IMG.decodeImage(byte_data.buffer.asUint8List());
      this.board = this.getTarget();
    });
  }

  // Constructor
  Artboard(IMG.Image targ){
    this.target = targ;
    this.board = this.getTarget();
  }

  void importFile(IO.File file){
    final byte_stream = file.readAsBytesSync();
    this.target = IMG.decodeImage(byte_stream);
    this.board = this.getTarget();
  }

  IMG.Image getTarget({int w: 2048, int h: 2048}) {
    IMG.Image tg = this.target;
    return IMG.copyResize(tg, width: w, height: h);
  }

  IMG.Image getArtBoard(){
    return this.board;
  }

  void fillBoard(IMG.Image frame, int x, int y){
    // Fill frame into the board
    // The top-left point is Board[x,y]
    for(var i=0; i<frame.height; i++){
      for(var j=0; j<frame.width; j++){
        this.board.setPixel(x + i, y + j, frame.getPixel(i, j));
      }
    }
  }

  Image ImageConvertFlutter2Dart(IMG.Image img){
    String base64Image = base64Encode(IMG.encodeJpg(img));
    final _byteImage = Base64Decoder().convert(base64Image);
    Widget image = Image.memory(_byteImage);
    return image;
  }

  Image target2Widget(){
    return this.ImageConvertFlutter2Dart(this.target);
  }

  Image board2Widget(){
    return this.ImageConvertFlutter2Dart(this.board);
  }

  Uint8List getSavable(){
    String base64Image = base64Encode(IMG.encodeJpg(this.board));
    final _byteImage = Base64Decoder().convert(base64Image);
    return _byteImage;
  }

  IMG.Image build(List<Pixel> pList){

    int step = 128;
    for(var i=0; i+step < board.width; i = i+step){
      for(var j=0; j+step < board.height; j = j+step){
        Pixel frame = Pixel.fromImage(IMG.copyCrop(board, i, j, step, step));

        int minIdx = 0;
        int minDist = frame.compare_score(pList[0]);
        for(var k=1; k<pList.length; k++){
          int new_diff = frame.compare_score(pList[k]);
          if(new_diff < minDist){
            minDist = new_diff;
            minIdx = k;
          }
        }

        fillBoard(frame.get_core(), i, j);
      }
    }
    return board;

  }
}
