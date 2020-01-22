import 'dart:convert';
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
    var contentDataFuture = rootBundle.load("assets/Artboard.jpg");
    contentDataFuture.then((byteData){
      this.target = IMG.decodeImage(byteData.buffer.asUint8List());
      this.board = this.getTarget();
    });
  }

  // Constructor
  Artboard(IMG.Image targ){
    this.target = targ;
    this.board = this.getTarget();
  }

  void importFile(IO.File file){
    final byteStream = file.readAsBytesSync();
    this.target = IMG.decodeImage(byteStream);
    this.board = this.getTarget();
  }

  void importByteStream(Uint8List byteStream){
    this.target = IMG.decodeImage(byteStream);
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

    if(pList.length <= 0){
      return this.board;
    }

    int step = 64;
    for(int i=0; i+step <= board.width; i = i+step){
      for(int j=0; j+step <= board.height; j = j+step){
        Pixel frame = Pixel.fromImage(IMG.copyCrop(board, i, j, step, step));

        int minIdx = 0;
        double minDist = frame.compare_score(pList[0]);
        for(var k=1; k<pList.length; k++){
          double newDiff = frame.compare_score(pList[k]);
          if(newDiff < minDist){
            minDist = newDiff;
            minIdx = k;
          }
        }

        IMG.Image newFrame = pList[minIdx].getBase(w:step, h:step);
        fillBoard(newFrame, i, j);
      }
    }
    return board;

  }
}
