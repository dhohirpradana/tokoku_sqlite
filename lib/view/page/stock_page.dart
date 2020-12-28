import 'dart:async';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:ucup_bengkel/model/tokoku_model.dart';
import 'package:ucup_bengkel/provider/tokoku_db_provider.dart';
import 'package:ucup_bengkel/view/page/add_stock_page.dart';

import 'out_stock_page.dart';

class StockPage extends StatefulWidget {
  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  TokoDbProvider tokoDb = TokoDbProvider();
  Future<void> _pullRefresh() async {
    setState(() {
      tokoDb.fetchStockWhere(cariController.text);
    });
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  final cariController = TextEditingController();
  final FocusNode cariNode = FocusNode();

  bool isVisible = false;

  void successDeleteIndicator() {
    Flushbar(
      title: 'Success',
      message: 'Berhasil Hapus Stock',
      icon: Icon(
        Icons.done_outline,
        size: 25,
        color: Colors.green.shade300,
      ),
      leftBarIndicatorColor: Colors.blue.shade300,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  @override
  void dispose() {
    super.dispose();
    cariController.dispose();
    cariNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff9f5f80),
          child: Icon(Icons.add),
          onPressed: () => Navigator.push(context,
              PageRouteBuilder(pageBuilder: (c, a1, a2) => AddStockPage()))),
      appBar: AppBar(
        backgroundColor: Color(0xff9f5f80),
        title: Text("STOK BARANG"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.grey[10],
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.search),
                    title: TextField(
                      focusNode: cariNode,
                      controller: cariController,
                      decoration: InputDecoration(
                          hintText: 'Cari barang', border: InputBorder.none),
                      onChanged: (v) {
                        setState(() {
                          (v != "") ? isVisible = true : isVisible = false;
                          tokoDb.fetchStockWhere(cariController.text);
                        });
                      },
                    ),
                    trailing: isVisible
                        ? IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              isVisible = false;
                              cariNode.unfocus();
                              cariController.clear();
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.transparent,
                            ),
                            onPressed: () {},
                          ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: tokoDb.fetchStockWhere(cariController.text),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return RefreshIndicator(
                        onRefresh: _pullRefresh,
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            StockModel stockModel = snapshot.data[index];
                            final no = (index + 1).toString();
                            final jumlah = stockModel.jumlah.toString();
                            final nama =
                                stockModel.nama.toString().toUpperCase();
                            final oCcy = NumberFormat("#,##0", "ind_ID");
                            final jual =
                                oCcy.format(stockModel.hargaJual).toString();
                            final beli =
                                oCcy.format(stockModel.hargaBeli).toString();
                            final dari = (stockModel.dari != "")
                                ? stockModel.dari.toString()
                                : "-";
                            final ket = (stockModel.dari != "")
                                ? stockModel.ket.toString()
                                : "-";
                            final stockUpdated = StockModel(
                              id: stockModel.id,
                              nama: stockModel.nama,
                              hargaBeli: stockModel.hargaBeli,
                              hargaJual: stockModel.hargaJual,
                              // int.parse(hargaJualController.text.replaceAll(RegExp(r'[^0-9]'), '')),
                              dari: stockModel.dari.toString(),
                              ket: stockModel.ket.toString(),
                              jumlah: stockModel.jumlah,
                              createdAt: stockModel.createdAt,
                              isDeleted: 1,
                            );
                            return
                                // Widget to display the list of project
                                InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            (stockModel.nama).toUpperCase()),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Divider(
                                              color: Colors.black,
                                            ),
                                            Text(
                                                "Stock              :  $jumlah"),
                                            Divider(
                                              color: Colors.black,
                                            ),
                                            Text("Harga Beli     :  Rp $beli"),
                                            Divider(
                                              color: Colors.black,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text("Harga Jual    :  "),
                                                Text(
                                                  'Rp $jual',
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              21,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                )
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.black,
                                            ),
                                            Text(
                                                "Dari                :  $dari"),
                                            Divider(
                                              color: Colors.black,
                                            ),
                                            Text("Keterangan  :  $ket"),
                                            Divider(
                                              color: Colors.black,
                                            )
                                          ],
                                        ),
                                        actions: <Widget>[
                                          InkWell(
                                            onTap: () =>
                                                Navigator.pushReplacement(
                                                    context,
                                                    PageRouteBuilder(
                                                        pageBuilder: (c, a1,
                                                                a2) =>
                                                            OutStockPage(
                                                                stockModel:
                                                                    stockModel))),
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text("JUAL",
                                                  style: TextStyle(
                                                      color: Colors.blue)),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text("UPDATE",
                                                style: TextStyle(
                                                    color: Colors.green)),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Row(
                                                          children: <Widget>[
                                                            Text(
                                                                "Yakin hapus $nama?"),
                                                          ],
                                                        ),
                                                        actions: <Widget>[
                                                          InkWell(
                                                            child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                child: Text(
                                                                    "TIDAK",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue))),
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          InkWell(
                                                            child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                child: Text(
                                                                    "YA",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red))),
                                                            onTap: () {
                                                              tokoDb.deleteStock(
                                                                  stockModel.id,
                                                                  stockUpdated);
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  context);
                                                              setState(() {
                                                                tokoDb.fetchStockWhere(
                                                                    cariController
                                                                        .text);
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  "HAPUS",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              )),
                                        ],
                                      );
                                    });
                              },
                              child: Card(
                                color: (int.parse(no) % 2 != 0)
                                    ? Colors.lightBlue[50]
                                    : Colors.white,
                                key: UniqueKey(),
                                elevation: 2,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text('$no.'),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text((stockModel.nama)
                                                      .toUpperCase()),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    ' [$jumlah]',
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    ' Rp $jual',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
