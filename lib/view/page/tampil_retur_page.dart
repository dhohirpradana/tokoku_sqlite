import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ucup_bengkel/model/tokoku_model.dart';
import 'package:ucup_bengkel/provider/tokoku_db_provider.dart';
import 'package:intl/intl.dart';
import 'package:ucup_bengkel/view/page/retur_page.dart';

class TampilReturPage extends StatefulWidget {
  @override
  __TampilReturPagetate createState() => __TampilReturPagetate();
}

class __TampilReturPagetate extends State<TampilReturPage> {
  TokoDbProvider tokoDb = TokoDbProvider();
  Future<void> _pullRefresh() async {
    setState(() {
      tokoDb.fetchRetur();
    });
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  int showCode = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff9f5f80),
          title: Text("BARANG DIRETUR"),
        ),
        body: Container(
          child: FutureBuilder(
              future:
                  (showCode == 0) ? tokoDb.fetchRetur() : tokoDb.fetchRetur(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            TampilReturModel tampilReturModel =
                                snapshot.data[index];
                            final oCcy = NumberFormat("#,##0", "ind_ID");
                            return InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10, sigmaY: 10),
                                        child: AlertDialog(
                                          title: (Text(tampilReturModel.nama
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
                                                  Text(tampilReturModel
                                                      .createdAt
                                                      .toString()),
                                                ],
                                              ),
                                              Divider(
                                                color: Colors.black,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text("Banyak      : "),
                                                  Text(tampilReturModel.jumlah
                                                      .toString()),
                                                ],
                                              ),
                                              Divider(
                                                color: Colors.black,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text("Potongan   : Rp "),
                                                  Text(tampilReturModel.potongan
                                                      .toString()),
                                                ],
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  "HAPUS",
                                                  style: TextStyle(
                                                      color: Colors.red),
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
                                    ? Colors.pink[50]
                                    : Colors.white,
                                elevation: 2,
                                key: UniqueKey(),
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(tampilReturModel.nama
                                            .toUpperCase()),
                                        Text(tampilReturModel.createdAt
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
