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
          created_at INTEGER,
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
          created_at INTEGER,
          is_deleted INTEGER)""");
      await db.execute("""
          CREATE TABLE Retur(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          idJual INTEGER,
          jumlah INTEGER,
          potongan INTEGER,
          created_at INTEGER,
          is_deleted INTEGER)""");
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
        "SELECT * FROM Stock WHERE nama LIKE '%$nama%' AND is_deleted='0' ORDER BY nama ASC"); //query all the rows in a table as an array of maps

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
        "SELECT Jual.id,Jual.hargaJual,Jual.jumlah,Jual.diskon,Jual.pembeli,Jual.ket,Jual.created_at,Stock.nama FROM Jual JOIN Stock ON Stock.id=Jual.idStock WHERE Jual.is_deleted='0' ORDER BY Jual.id DESC",
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

  //Table Retur
  Future<int> addRetur(ReturModel returItem) async {
    //returns number of items inserted as an integer
    final db = await init(); //open database
    return db.insert(
      "Retur", returItem.toMap(), //toMap() function from JualModel
      conflictAlgorithm:
          ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<List<TampilReturModel>> fetchRetur() async {
    //returns the Stock as a list (array)
    final db = await init();
    final maps = await db.rawQuery(
        "SELECT Retur.id,Retur.idJual,Retur.jumlah,Retur.potongan,Retur.created_at,Stock.nama FROM Retur LEFT JOIN Jual ON Retur.idJual=Jual.id LEFT JOIN Stock ON Jual.idStock=Stock.id WHERE Retur.is_deleted='0' ORDER BY Jual.id DESC",
        null); //query all the rows in a table as an array of maps
    return List.generate(maps.length, (i) {
      //create a list of tampilJual
      return TampilReturModel(
        id: maps[i]['id'],
        idJual: maps[i]['idJual'],
        nama: maps[i]['nama'],
        jumlah: maps[i]['jumlah'],
        potongan: maps[i]['potongan'],
        createdAt: maps[i]['created_at'],
      );
    });
  }

  //Tampil Pendapatan
  Future<List<PendapatanModel>> fetchPendapatan() async {
    //returns the Stock as a list (array)
    final db = await init();
    final maps = await db.rawQuery(
        "SELECT Jual.hargaJual AS harga_jual,Jual.jumlah,Jual.diskon,(Jual.hargaJual*Jual.jumlah) AS grand_harga,(Jual.hargaJual*Jual.jumlah-Jual.diskon) AS total_id,SUM(Jual.hargaJual*Jual.jumlah) AS total_harga,SUM(Jual.jumlah) AS total_jumlah,SUM(Jual.diskon) AS total_diskon,Stock.hargaBeli AS harga_beli,SUM(Stock.hargaBeli*Jual.jumlah) AS total_beli,((Jual.hargaJual*Jual.jumlah-Jual.diskon)-(Stock.hargaBeli*Jual.jumlah)) AS laba_id,SUM((Jual.hargaJual*Jual.jumlah-Jual.diskon)-(Stock.hargaBeli*Jual.jumlah)) AS total_laba FROM Jual JOIN Stock ON Jual.idStock=Stock.id WHERE Jual.is_deleted='0'",
        null); //query all the rows in a table as an array of maps
    return List.generate(maps.length, (i) {
      //create a list of tampilJual
      return PendapatanModel(
          hargaId: maps[i]['harga_jual'],
          jumlahId: maps[i]['jumlah'],
          diskonId: maps[i]['diskon'],
          grandHargaId: maps[i]['grand_harga'],
          totalId: maps[i]['total_id'],
          totalBeli: maps[i]['total_beli'],
          totalHarga: maps[i]['total_harga'],
          totalJumlah: maps[i]['total_jumlah'],
          totalDiskon: maps[i]['total_diskon'],
          totalLaba: maps[i]['total_laba']);
    });
  }
}
