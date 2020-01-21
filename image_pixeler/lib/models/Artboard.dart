import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as IMG;
import 'Pixel.dart';
import 'dart:io' as IO;


class Artboard{
  IMG.Image target;
  IMG.Image board;
  // Size: (1500 x 1500) for (2m x 2m) banner

  Artboard.fromString(String str){
    final bytes = Base64Decoder().convert(str);
    target = IMG.decodeImage(bytes);
    this.board = this.getTarget();
  }

  Artboard.Default(){
    IO.File default_file = IO.File("assets/Artboard.jpg");
    final byte_stream = default_file.readAsBytesSync();
    this.target = IMG.decodeImage(byte_stream);
    this.board = this.getTarget();
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

    /*
    int step = 128;
    for(var i=0; i+step < board.width; i = i+step){
      for(var j=0; j+step < board.height; j = j+step){
        Pixel frame = Pixel.fromImage(copyCrop(board, i, j, step, step));

        int minIdx = 0;
        int minDist = frame.compare_score(pList[k]);
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

    */

    // Set some pixels to red for now

    for(int i=board.width - 10; i<board.width + 10; i++){
      for(int j=board.height - 10; j<board.height + 10; j++){
        board.setPixelRgba(i, j, 255, 0, 0);
      }
    }
    return board;
  }
}
