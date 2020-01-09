import 'dart:convert';
import 'dart:math';
import 'package:image/image.dart';
import 'Pixel.dart';


class Artboard{

  Image target;
  // Size: (1500 x 1500) for (2m x 2m) banner

  Image get_target(){
    Image tg = this.target;
    return copyResize(tg, width: 1024, height: 1024);
  }
  Image build(List<Pixel> pList){
    Image board = this.get_target();

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
