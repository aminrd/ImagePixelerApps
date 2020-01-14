import 'dart:async';
import 'dart:io'; // as io
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'Artboard.dart';

// Importing this app models
import 'package:image_pixeler/models/Pixel.dart';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "image_pixeler_db.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Pixels(id INTEGER PRIMARY KEY, width INTEGER, height INTEGER, baseImage TEXT, coreImage TEXT )");

    await db.execute("CREATE TABLE Artboard(board TEXT)");
    print("Created tables");
  }

  void savePixel(Pixel pixel) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Pixels(width, height, baseImage, coreImage ) VALUES(' +
              ''' +
              pixel.getWidthRaw() +
              ''' +
              ',' +
              ''' +
              pixel.getHeightRaw() +
              ''' +
              ',' +
              ''' +
              pixel.getBaseRaw() +
              ''' +
              ',' +
              ''' +
              pixel.getCoreRaw() +
              ''' +
              ')');
    });
  }

  Future<List<Pixel>> getPixels({int need = 1024}) async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Pixels');
    List<Pixel> pixels = new List();

    int pick_number = need;
    if(list.length < pick_number){
      pick_number = list.length;
    }
    for (int i = 0; i < pick_number; i++) {
      pixels.add(new Pixel(list[i]["id"], list[i]["width"], list[i]["height"], list[i]["baseImage"], list[i]["coreImage"]));
    }
    if(pixels.length < need){
      if(need > 3){
        need = 3;
      }
      for(int i=0; i<need; i++){
        File file = File("assets/Pixel$i.jpg");
        Pixel default_pix = Pixel.fromFile(file);
        pixels.add(default_pix);
      }
    }
    return pixels;
  }

  Future<int> updatePixel(int id, Pixel update) async{
    var dbClient = await db;
    var result = await dbClient.delete("Pixels", where: "id = ?", whereArgs: [id]);
    this.savePixel(update);
    return result;
  }

  Future<int> deletePixel(Pixel pixel) async {
    var dbClient = await db;
    int id = pixel.getId();
    await dbClient.delete("Pixels", where: "id = ?", whereArgs: [id]);
  }

  Future deleteAllPixels() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("DELETE from Pixels");
    return result;
  }

  // Artboard related functions:
  Future<Artboard> getArtboard() async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Artboard');

    Artboard ab = new Artboard.fromString(list[0]["board"]);
    return ab;
  }

  void saveArtboard(String ab_base_64) async {
    var dbClient = await db;
    await dbClient.rawQuery("DELETE FROM Artboard");
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Artboard(board) VALUES(' +
              ''' +
              ab_base_64 +
              ''' +
              ')');
    });
  }
}