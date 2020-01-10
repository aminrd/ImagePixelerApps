import 'dart:convert';
import 'dart:math';
import 'package:image/image.dart';
import 'Pixel.dart';


class Artboard{
  Image target;
  Image board;
  // Size: (1500 x 1500) for (2m x 2m) banner

  Image getTarget() {
    Image tg = this.target;
    return copyResize(tg, width: 2048, height: 2048);
  }

  void fillBoard(Image frame, int x, int y){
    // Fill frame into the board
    // The top-left point is Board[x,y]
    for(var i=0; i<frame.height; i++){
      for(var j=0; j<frame.width; j++){
        this.board.setPixel(x + i, y + j, frame.getPixel(i, j));
      }
    }
  }

  Image build(List<Pixel> pList){
    this.board = this.getTarget();

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

    // TODO: Implement the image-pixeler algorithm
    for(var i=board.width - 10; i<board.width + 10; i++){
      for(var j=board.height - 10; j<board.height + 10; j++){
        board.setPixelRgba(i, j, 255, 0, 0);
      }
    }
    return board;
  }
}
