class StockModel {
  final int id;
  final String nama;
  final int hargaBeli;
  final int hargaJual;
  final int jumlah;
  final String dari;
  final String ket;
  final String createdAt;
  final int isDeleted;

  StockModel({
    this.id,
    this.nama,
    this.hargaBeli,
    this.hargaJual,
    this.jumlah,
    this.dari,
    this.ket,
    this.createdAt,
    this.isDeleted,
  });

  Map<String, dynamic> toMap() {
    // used when inserting data to the database
    return <String, dynamic>{
      "id": id,
      "nama": nama,
      "hargaBeli": hargaBeli,
      "hargaJual": hargaJual,
      "jumlah": jumlah,
      "dari": dari,
      "ket": ket,
      "created_at": createdAt,
      "is_deleted": isDeleted
    };
  }
}

class JualModel {
  final int id;
  final int idStock;
  final int jumlah;
  final int hargaJual;
  final int diskon;
  final String pembeli;
  final String ket;
  final String createdAt;

  JualModel({
    this.id,
    this.idStock,
    this.jumlah,
    this.hargaJual,
    this.diskon,
    this.pembeli,
    this.ket,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    // used when inserting data to the database
    return <String, dynamic>{
      "id": id,
      "idStock": idStock,
      "jumlah": jumlah,
      "hargaJual": hargaJual,
      "diskon": diskon,
      "pembeli": pembeli,
      "ket": ket,
      "created_at": createdAt
    };
  }
}

class TampilJualModel {
  final int id;
  final String nama;
  final int jumlah;
  final int hargaJual;
  final int diskon;
  final String pembeli;
  final String ket;
  final String createdAt;

  TampilJualModel({
    this.id,
    this.nama,
    this.jumlah,
    this.hargaJual,
    this.diskon,
    this.pembeli,
    this.ket,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    // used when inserting data to the database
    return <String, dynamic>{
      "id": id,
      "nama": nama,
      "jumlah": jumlah,
      "hargaJual": hargaJual,
      "diskon": diskon,
      "pembeli": pembeli,
      "ket": ket,
      "created_at": createdAt
    };
  }
}
