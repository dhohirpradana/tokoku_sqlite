import 'package:sqflite/sqflite.dart'; //sqflite package
import 'package:path_provider/path_provider.dart'; //path_provider package
import 'package:path/path.dart'; //used to join paths
import 'package:ucup_bengkel/model/tokoku_model.dart'; //import model class
import 'dart:io';
import 'dart:async';

class TokoDbProvider {
  Future<Database> init() async {
    Directory directory =
        await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path = join(directory.path, "tokos.db"); //create path to database

    return await openDatabase(
        //open the database or create a database if there isn't any
        path,
        version: 1, onCreate: (Database db, int version) async {
      await db.execute("""
          CREATE TABLE Stock(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          nama TEXT,
          hargaBeli INTEGER,
          hargaJual INTEGER,
          jumlah INTEGER,
          dari TEXT,
          ket TEXT,
          created_at TEXT,
          is_deleted INTEGER)""");
      await db.execute("""
          CREATE TABLE Jual(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          idStock TEXT,
          jumlah INTEGER,
          hargaJual INTEGER,
          diskon INTEGER,
          pembeli TEXT,
          ket TEXT,
          created_at TEXT)""");
    });
  }

//Table Stock
  Future<int> addStock(StockModel item) async {
    //returns number of items inserted as an integer

    final db = await init(); //open database

    return db.insert(
      "Stock", item.toMap(), //toMap() function from JualModel
      conflictAlgorithm:
          ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<List<StockModel>> fetchStock() async {
    //returns the Stock as a list (array)

    final db = await init();
    final maps = await db
        .query("Stock"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) {
      //create a list of memos
      return StockModel(
        id: maps[i]['id'],
        nama: maps[i]['nama'],
        hargaBeli: maps[i]['hargaBeli'],
        hargaJual: maps[i]['hargaJual'],
        jumlah: maps[i]['jumlah'],
        dari: maps[i]['dari'],
        ket: maps[i]['ket'],
        createdAt: maps[i]['created_at'],
      );
    });
  }

  Future<List<StockModel>> fetchStockWhere(String nama) async {
    //returns the Stock as a list (array)

    final db = await init();
    final maps = await db.rawQuery(
        "SELECT * FROM Stock WHERE nama LIKE '%$nama%' AND is_deleted='0'"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) {
      //create a list of Stock
      return StockModel(
        id: maps[i]['id'],
        nama: maps[i]['nama'],
        hargaBeli: maps[i]['hargaBeli'],
        hargaJual: maps[i]['hargaJual'],
        jumlah: maps[i]['jumlah'],
        dari: maps[i]['dari'],
        ket: maps[i]['ket'],
        createdAt: maps[i]['created_at'],
      );
    });
  }

  // Future<int> deleteStock(int id) async {
  //   //returns number of items deleted
  //   final db = await init();

  //   int result = await db.delete("Stock", //table name
  //       where: "id = ?",
  //       whereArgs: [id] // use whereArgs to avoid SQL injection
  //       );

  //   return result;
  // }

  Future<int> deleteStock(int id, StockModel stockItem) async {
    // returns the number of rows updated
    final db = await init();

    int result = await db
        .update("Stock", stockItem.toMap(), where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<int> updateStock(int id, StockModel stockItem) async {
    // returns the number of rows updated
    final db = await init();

    int result = await db
        .update("Stock", stockItem.toMap(), where: "id = ?", whereArgs: [id]);
    return result;
  }

//Table Jual
  Future<int> addJual(JualModel jualItem) async {
    //returns number of items inserted as an integer
    final db = await init(); //open database
    return db.insert(
      "Jual", jualItem.toMap(), //toMap() function from JualModel
      conflictAlgorithm:
          ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<List<TampilJualModel>> fetchJual() async {
    //returns the Stock as a list (array)
    final db = await init();
    final maps = await db.rawQuery(
        "SELECT Jual.id,Jual.hargaJual,Jual.jumlah,Jual.diskon,Jual.pembeli,Jual.ket,Jual.created_at,Stock.nama FROM Jual JOIN Stock ON Stock.id=Jual.idStock ORDER BY Jual.id DESC",
        null); //query all the rows in a table as an array of maps
    return List.generate(maps.length, (i) {
      //create a list of tampilJual
      return TampilJualModel(
        id: maps[i]['id'],
        nama: maps[i]['nama'],
        hargaJual: maps[i]['hargaJual'],
        jumlah: maps[i]['jumlah'],
        diskon: maps[i]['diskon'],
        pembeli: maps[i]['pembeli'],
        ket: maps[i]['ket'],
        createdAt: maps[i]['created_at'],
      );
    });
  }
}
