import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ucup_bengkel/model/tokoku_model.dart';
import 'package:ucup_bengkel/provider/tokoku_db_provider.dart';
import 'package:intl/intl.dart';
import 'package:ucup_bengkel/view/page/retur_page.dart';

class SoldPage extends StatefulWidget {
  @override
  _SoldPageState createState() => _SoldPageState();
}

class _SoldPageState extends State<SoldPage> {
  TokoDbProvider tokoDb = TokoDbProvider();
  Future<void> _pullRefresh() async {
    setState(() {
      tokoDb.fetchJual();
    });
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  int showCode = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff9f5f80),
          title: Text("BARANG TERJUAL"),
        ),
        body: Container(
          child: FutureBuilder(
              future: (showCode == 0) ? tokoDb.fetchJual() : tokoDb.fetchJual(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            TampilJualModel tampilJualModel =
                                snapshot.data[index];
                            final oCcy = NumberFormat("#,##0", "ind_ID");
                            final jual = oCcy
                                .format(tampilJualModel.hargaJual)
                                .toString();
                            final pembeli = (tampilJualModel.pembeli == "")
                                ? "-"
                                : tampilJualModel.pembeli;
                            final ket = (tampilJualModel.ket == "")
                                ? "-"
                                : tampilJualModel.ket;
                            final total = oCcy.format(
                                tampilJualModel.hargaJual *
                                        tampilJualModel.jumlah -
                                    tampilJualModel.diskon);
                            return InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10, sigmaY: 10),
                                        child: AlertDialog(
                                          title: (Text(tampilJualModel.nama
                                              .toUpperCase())),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Divider(
                                                color: Colors.black,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(tampilJualModel.createdAt
                                                      .toString()),
                                                ],
                                              ),
                                              Divider(
                                                color: Colors.black,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text("Harga Jual  : Rp "),
                                                  Text(jual),
                                                ],
                                              ),
                                              Divider(
                                                color: Colors.black,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text("Banyak        : "),
                                                  Text(tampilJualModel.jumlah
                                                      .toString()),
                                                ],
                                              ),
                                              Divider(
                                                color: Colors.black,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text("Diskon        : Rp "),
                                                  Text(tampilJualModel.diskon
                                                      .toString()),
                                                ],
                                              ),
                                              Divider(
                                                color: Colors.black,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text("Pembeli      : "),
                                                  Text(pembeli),
                                                ],
                                              ),
                                              Divider(
                                                color: Colors.black,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text("Keterangan: "),
                                                  Text(ket),
                                                ],
                                              ),
                                              Divider(
                                                color: Colors.black,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Rp ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    total.toString(),
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            InkWell(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                      pageBuilder: (c, a1,
                                                              a2) =>
                                                          ReturPage(
                                                              tampilJualModel:
                                                                  tampilJualModel))),
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  "RETUR",
                                                  style: TextStyle(
                                                      color: Colors.pink),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Card(
                                color: ((index + 1) % 2 != 0)
                                    ? Colors.green[50]
                                    : Colors.white,
                                elevation: 2,
                                key: UniqueKey(),
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                            tampilJualModel.nama.toUpperCase()),
                                        Text(tampilJualModel.createdAt
                                            .toString())
                                      ],
                                    )),
                              ),
                            );
                          }));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ));
  }
}
