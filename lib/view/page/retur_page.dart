import 'dart:ui';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:ucup_bengkel/model/tokoku_model.dart';
import 'package:ucup_bengkel/provider/tokoku_db_provider.dart';
import 'package:ucup_bengkel/view/page/sold_page.dart';

class ReturPage extends StatefulWidget {
  final TampilJualModel tampilJualModel;

  const ReturPage({Key key, @required this.tampilJualModel}) : super(key: key);
  @override
  _ReturPageState createState() => _ReturPageState();
}

class _ReturPageState extends State<ReturPage> {
  final _formKey = GlobalKey<FormState>();
  final potonganController = TextEditingController();
  var jumlahController = TextEditingController();

  final FocusNode namaNode = FocusNode();
  final FocusNode potonganNode = FocusNode();
  final FocusNode jumlahNode = FocusNode();
  void addRetur() async {
    DateTime now = DateTime.now();
    final formattedDate = int.parse(DateFormat('yyyy-MM-dd – kk:mm')
        .format(now)
        .replaceAll(RegExp(r'[^0-9]'), ''));
    final stockUpdated = ReturModel(
      idJual: widget.tampilJualModel.id,
      potongan:
          int.parse(potonganController.text.replaceAll(RegExp(r'[^0-9]'), '')),
      jumlah:
          int.parse(jumlahController.text.replaceAll(RegExp(r'[^0-9]'), '')),
      createdAt: formattedDate,
      isDeleted: 0,
    );

    TokoDbProvider tokoDb = TokoDbProvider();

    await tokoDb.addRetur(stockUpdated);
    successIndicator();
    jumlahController.clear();
    namaNode.unfocus();
    jumlahNode.unfocus();
  }

  void successIndicator() {
    Flushbar(
      title: 'Success',
      message: 'Berhasil Retur',
      icon: Icon(
        Icons.done_outline,
        size: 25,
        color: Colors.green.shade300,
      ),
      leftBarIndicatorColor: Colors.blue.shade300,
      duration: Duration(seconds: 2),
    )..show(context).then((value) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => SoldPage()),
          ModalRoute.withName('/'),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Color(0xff9f5f80),
          title: Text("STOK BARANG"),
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
            readOnly: true,
            initialValue: widget.tampilJualModel.nama,
            focusNode: namaNode,
            decoration: const InputDecoration(
              labelText: 'Nama barang',
            ),
          ),
          TextFormField(
            controller: jumlahController,
            focusNode: jumlahNode,
            textInputAction: TextInputAction.next,
            onChanged: (v) => jumlahController.text = v,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(potonganNode);
            },
            decoration: const InputDecoration(
              labelText: 'Banyak',
            ),
            inputFormatters: [
              CurrencyTextInputFormatter(locale: 'id', decimalDigits: 0)
            ],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return 'Form harus diisi';
              } else if (int.parse(value.replaceAll(RegExp(r'[^0-9]'), '')) <
                  1) {
                return 'Banyak tidak boleh kurang dari 1';
              }
              return null;
            },
          ),
          TextFormField(
            controller: potonganController,
            focusNode: potonganNode,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (term) {
              if (term == "") {
                potonganController.text = '0';
                FocusScope.of(context).unfocus();
              }
              FocusScope.of(context).unfocus();
            },
            decoration: const InputDecoration(
              labelText: 'Potongan (boleh kosong)',
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
          RaisedButton(
            color: Color(0xff9f5f80),
            onPressed: () {
              final nama = widget.tampilJualModel.nama;
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
                              Text("Retur $nama?"),
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
                                  child: Text("RETUR",
                                      style: TextStyle(color: Colors.green))),
                              onTap: () {
                                addRetur();
                              },
                            ),
                          ],
                        ),
                      );
                    });
              }
            },
            child: Text(
              'RETUR',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom)),
        ]));
  }
}
