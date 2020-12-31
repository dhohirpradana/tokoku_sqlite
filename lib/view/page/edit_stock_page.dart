import 'dart:ui';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:ucup_bengkel/model/tokoku_model.dart';
import 'package:intl/intl.dart';
import 'package:ucup_bengkel/provider/tokoku_db_provider.dart';
import 'package:ucup_bengkel/view/page/stock_page.dart';

class EditStockPage extends StatefulWidget {
  // Declare a field that holds the Todo.
  final StockModel stockModel;

  const EditStockPage({Key key, @required this.stockModel}) : super(key: key);
  @override
  _EditStockPageState createState() => _EditStockPageState();
}

class _EditStockPageState extends State<EditStockPage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final hargaJualController = TextEditingController();
  final hargaBeliController = TextEditingController();
  var jumlahController = TextEditingController();
  final dariController = TextEditingController();
  final ketController = TextEditingController();

  final FocusNode namaNode = FocusNode();
  final FocusNode hargaJualNode = FocusNode();
  final FocusNode hargaBeliNode = FocusNode();
  final FocusNode jumlahNode = FocusNode();
  final FocusNode dariNode = FocusNode();
  final FocusNode ketNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    namaController.dispose();
    hargaJualController.dispose();
    hargaBeliController.dispose();
    jumlahController.dispose();
    dariController.dispose();
    ketController.dispose();

    namaNode.dispose();
    hargaBeliNode.dispose();
    hargaJualNode.dispose();
    jumlahNode.dispose();
    dariNode.dispose();
    ketNode.dispose();
  }

  TokoDbProvider bengkelDb = TokoDbProvider();

  void updateStock() async {
    DateTime now = DateTime.now();
    final formattedDate = int.parse(DateFormat('yyyy-MM-dd – kk:mm')
        .format(now)
        .replaceAll(RegExp(r'[^0-9]'), ''));
    final stockUpdated = StockModel(
      id: widget.stockModel.id,
      nama: namaController.text,
      hargaBeli:
          int.parse(hargaBeliController.text.replaceAll(RegExp(r'[^0-9]'), '')),
      hargaJual:
          int.parse(hargaJualController.text.replaceAll(RegExp(r'[^0-9]'), '')),
      // int.parse(hargaJualController.text.replaceAll(RegExp(r'[^0-9]'), '')),
      dari: dariController.text,
      ket: ketController.text,
      jumlah:
          int.parse(jumlahController.text.replaceAll(RegExp(r'[^0-9]'), '')),
      createdAt: formattedDate,
      isDeleted: 0,
    );

    TokoDbProvider tokoDb = TokoDbProvider();

    await tokoDb.updateStock(widget.stockModel.id, stockUpdated);
    successIndicator();
    namaController.clear();
    hargaBeliController.clear();
    hargaJualController.clear();
    jumlahController.clear();
    dariController.clear();
    ketController.clear();
    namaNode.unfocus();
    hargaBeliNode.unfocus();
    hargaJualNode.unfocus();
    jumlahNode.unfocus();
    dariNode.unfocus();
    ketNode.unfocus();
  }

  void successIndicator() {
    Flushbar(
      title: 'Success',
      message: 'Berhasil Update Stock',
      icon: Icon(
        Icons.done_outline,
        size: 25,
        color: Colors.green.shade300,
      ),
      leftBarIndicatorColor: Colors.blue.shade300,
      duration: Duration(seconds: 2),
    )..show(context).then((value) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => StockPage()),
          ModalRoute.withName('/'),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Color(0xff9f5f80),
          title: Text("UPDATE STOCK"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          reverse: true,
          child: Container(
            padding: EdgeInsets.all(9),
            child: Material(
              child: formWidget(),
            ),
          ),
        ));
  }

  Widget formWidget() {
    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TextFormField(
            initialValue: widget.stockModel.nama,
            focusNode: namaNode,
            textInputAction: TextInputAction.next,
            onChanged: (v) => namaController.text = v,
            onFieldSubmitted: (v) {
              namaController.text = v;
              FocusScope.of(context).requestFocus(hargaBeliNode);
            },
            decoration: const InputDecoration(
              labelText: 'Nama barang',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Form harus diisi';
              }
              return null;
            },
          ),
          TextFormField(
            controller: hargaBeliController
              ..text = widget.stockModel.hargaBeli.toString(),
            focusNode: hargaBeliNode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(hargaJualNode);
            },
            decoration: const InputDecoration(
              labelText: 'Harga Beli',
            ),
            inputFormatters: [
              CurrencyTextInputFormatter(
                  locale: 'id', decimalDigits: 0, symbol: 'Rp ')
            ],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return 'Form harus diisi';
              }
              return null;
            },
          ),
          TextFormField(
            controller: hargaJualController
              ..text = widget.stockModel.hargaJual.toString(),
            focusNode: hargaJualNode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(jumlahNode);
            },
            decoration: const InputDecoration(
              labelText: 'Harga jual',
            ),
            inputFormatters: [
              CurrencyTextInputFormatter(
                  locale: 'id', decimalDigits: 0, symbol: 'Rp ')
            ],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return 'Form harus diisi';
              } else if (int.parse(value.replaceAll(RegExp(r'[^0-9]'), '')) <=
                  int.parse(hargaBeliController.text
                      .replaceAll(RegExp(r'[^0-9]'), ''))) {
                return 'Harga jual harus lebih dari Harga beli';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: widget.stockModel.jumlah.toString(),
            focusNode: jumlahNode,
            textInputAction: TextInputAction.next,
            onChanged: (v) {
              final val =
                  TextSelection.collapsed(offset: jumlahController.text.length);
              jumlahController.selection = val;
              jumlahController.text = v;
            },
            onFieldSubmitted: (v) {
              jumlahController.text = v;
              FocusScope.of(context).requestFocus(dariNode);
            },
            inputFormatters: [
              CurrencyTextInputFormatter(
                  locale: 'id', decimalDigits: 0, symbol: '')
            ],
            decoration: const InputDecoration(
              labelText: 'Banyak',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return 'Form harus diisi';
              }
              return null;
            },
          ),
          TextFormField(
            controller: dariController
              ..text = widget.stockModel.dari.toUpperCase(),
            focusNode: dariNode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(hargaBeliNode);
            },
            decoration: const InputDecoration(
              labelText: 'Dari (boleh kosong)',
            ),
          ),
          TextFormField(
            controller: ketController..text = widget.stockModel.ket,
            focusNode: ketNode,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (term) {
              FocusScope.of(context).unfocus();
            },
            decoration: const InputDecoration(
              labelText: 'Keterangan (boleh kosong)',
            ),
          ),
          RaisedButton(
            color: Color(0xff9f5f80),
            onPressed: () {
              final nama = widget.stockModel.nama;
              if (_formKey.currentState.validate()) {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: AlertDialog(
                          title: Row(
                            children: <Widget>[
                              Text("Update $nama?"),
                            ],
                          ),
                          actions: <Widget>[
                            InkWell(
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text("BATAL",
                                      style: TextStyle(color: Colors.blue))),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            InkWell(
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text("UPDATE",
                                      style: TextStyle(color: Colors.green))),
                              onTap: () {
                                updateStock();
                              },
                            ),
                          ],
                        ),
                      );
                    });
              }
            },
            child: Text(
              'UPDATE',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom)),
        ]));
  }
}
