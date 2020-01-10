import 'dart:async';
import 'dart:io'; // as io
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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
    print("Created tables");
  }

  void savePixel(Pixel pixel) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Pixels(width, height, baseImage, coreImage ) VALUES(' +
              ''' +
              pixel.get_width_raw() +
              ''' +
              ',' +
              ''' +
              pixel.get_height_raw() +
              ''' +
              ',' +
              ''' +
              pixel.get_base_raw() +
              ''' +
              ',' +
              ''' +
              pixel.get_core_raw() +
              ''' +
              ')');
    });
  }

  Future<List<Pixel>> getPixels() async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Pixels');
    List<Pixel> pixels = new List();
    for (int i = 0; i < list.length; i++) {
      pixels.add(new Pixel(list[i]["width"], list[i]["height"], list[i]["baseImage"], list[i]["coreImage"]));
    }
    print(pixels.length);
    return pixels;
  }

}