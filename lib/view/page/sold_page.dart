import 'package:flutter/material.dart';
import 'package:ucup_bengkel/model/tokoku_model.dart';
import 'package:ucup_bengkel/provider/tokoku_db_provider.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff9f5f80),
          title: Text("BARANG TERJUAL"),
        ),
        body: Container(
          child: FutureBuilder(
              future: tokoDb.fetchJual(),
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
                                      return AlertDialog(
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
                                                Text(tampilJualModel.createdAt),
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
                                      );
                                    });
                              },
                              child: Card(
                                color: ((index + 1) % 2 != 0)
                                    ? Colors.lightBlue[50]
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
