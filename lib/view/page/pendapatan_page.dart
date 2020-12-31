import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ucup_bengkel/model/tokoku_model.dart';
import 'package:ucup_bengkel/provider/tokoku_db_provider.dart';
import 'package:intl/intl.dart';
import 'package:ucup_bengkel/view/asset/text_style.dart';

class PendapatanPage extends StatefulWidget {
  @override
  _PendapatanPageState createState() => _PendapatanPageState();
}

class _PendapatanPageState extends State<PendapatanPage> {
  TokoDbProvider tokoDb = TokoDbProvider();
  @override
  void initState() {
    super.initState();
    tokoDb.fetchPendapatan();
  }

  Future<void> _pullRefresh() async {
    setState(() {
      tokoDb.fetchPendapatan();
    });
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  int showCode = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Color(0xff9f5f80),
          title: Text("PENDAPATAN"),
        ),
        body: FutureBuilder(
            future: (showCode == 0)
                ? tokoDb.fetchPendapatan()
                : tokoDb.fetchPendapatan(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      PendapatanModel pendapatanModel = snapshot.data[0];
                      final oCcy = NumberFormat("#,##0", "ind_ID");
                      final banyak = oCcy.format(pendapatanModel.totalJumlah);
                      final laba = oCcy.format(pendapatanModel.totalLaba);
                      final totalHarga =
                          oCcy.format(pendapatanModel.totalHarga);
                      final totalDiskon =
                          oCcy.format(pendapatanModel.totalDiskon);
                      final totalBeli = oCcy.format(pendapatanModel.totalBeli);
                      final pendapatan = oCcy.format(
                          pendapatanModel.totalHarga -
                              pendapatanModel.totalDiskon);
                      return Container(
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "TOTAL BARANG TERJUAL : ",
                                  style: MyTextStyle(
                                      size: 17, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  banyak,
                                  style: MyTextStyle(
                                      size: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                              height: 35,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "TOTAL HARGA BELI : Rp ",
                                  style: MyTextStyle(
                                      size: 17, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  totalBeli.toString(),
                                  style: MyTextStyle(
                                      size: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                              height: 35,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "TOTAL HARGA JUAL : Rp ",
                                  style: MyTextStyle(
                                      size: 17, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  totalHarga.toString(),
                                  style: MyTextStyle(
                                      size: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                              height: 35,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "TOTAL DISKON : Rp ",
                                  style: MyTextStyle(
                                      size: 17, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  totalDiskon.toString(),
                                  style: MyTextStyle(
                                      size: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                              height: 35,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "TOTAL PENDAPATAN : Rp ",
                                  style: MyTextStyle(
                                      size: 17, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  pendapatan.toString(),
                                  style: MyTextStyle(
                                      size: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                              height: 35,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "TOTAL LABA : ",
                                  style: MyTextStyle(
                                      size: 17, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Rp ",
                                  style: MyTextStyle(
                                      size: 25, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  laba.toString(),
                                  style: MyTextStyle(
                                      size: 30, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                              height: 35,
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
