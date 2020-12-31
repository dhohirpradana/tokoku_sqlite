class StockModel {
  final int id;
  final String nama;
  final int hargaBeli;
  final int hargaJual;
  final int jumlah;
  final String dari;
  final String ket;
  final int createdAt;
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
  final int createdAt;
  final int isDeleted;

  JualModel({
    this.id,
    this.idStock,
    this.jumlah,
    this.hargaJual,
    this.diskon,
    this.pembeli,
    this.ket,
    this.createdAt,
    this.isDeleted,
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
      "created_at": createdAt,
      "is_deleted": isDeleted
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
  final int createdAt;

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

class ReturModel {
  final int id;
  final int idJual;
  final int potongan;
  final int jumlah;
  final int createdAt;
  final int isDeleted;

  ReturModel({
    this.id,
    this.idJual,
    this.jumlah,
    this.potongan,
    this.createdAt,
    this.isDeleted,
  });

  Map<String, dynamic> toMap() {
    // used when inserting data to the database
    return <String, dynamic>{
      "id": id,
      "idJual": idJual,
      "jumlah": jumlah,
      "potongan": potongan,
      "created_at": createdAt,
      "is_deleted": isDeleted
    };
  }
}

class TampilReturModel {
  final int id;
  final int idJual;
  final String nama;
  final int potongan;
  final int jumlah;
  final int createdAt;
  final int isDeleted;

  TampilReturModel({
    this.id,
    this.idJual,
    this.nama,
    this.jumlah,
    this.potongan,
    this.createdAt,
    this.isDeleted,
  });

  Map<String, dynamic> toMap() {
    // used when inserting data to the database
    return <String, dynamic>{
      "id": id,
      "idJual": idJual,
      "nama": nama,
      "jumlah": jumlah,
      "potongan": potongan,
      "created_at": createdAt,
      "is_deleted": isDeleted
    };
  }
}

class PendapatanModel {
  final int hargaId;
  final int jumlahId;
  final int diskonId;
  final int grandHargaId;
  final int totalId;
  final int totalBeli;
  final int totalHarga;
  final int totalJumlah;
  final int totalDiskon;
  final int totalLaba;

  PendapatanModel({
    this.hargaId,
    this.jumlahId,
    this.diskonId,
    this.grandHargaId,
    this.totalId,
    this.totalBeli,
    this.totalHarga,
    this.totalJumlah,
    this.totalDiskon,
    this.totalLaba,
  });

  Map<String, dynamic> toMap() {
    // used when inserting data to the database
    return <String, dynamic>{
      "harga_id": hargaId,
      "jumlah_id": jumlahId,
      "potongan_id": diskonId,
      "grand_harga_id": grandHargaId,
      "total_id": totalId,
      "total_beli": totalBeli,
      "total_harga": totalHarga,
      "total_jumlah": totalJumlah,
      "total_diskon": totalDiskon,
      "total_laba": totalLaba
    };
  }
}
