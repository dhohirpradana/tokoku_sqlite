import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:ucup_bengkel/model/tokoku_model.dart';
import 'package:intl/intl.dart';
import 'package:ucup_bengkel/provider/tokoku_db_provider.dart';

class AddStockPage extends StatefulWidget {
  @override
  _AddStockPageState createState() => _AddStockPageState();
}

class _AddStockPageState extends State<AddStockPage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final hargaJualController = TextEditingController();
  final hargaBeliController = TextEditingController();
  final jumlahController = TextEditingController();
  final dariController = TextEditingController();
  final ketController = TextEditingController();

  final FocusNode namaNode = FocusNode();
  final FocusNode hargaJualNode = FocusNode();
  final FocusNode hargaBeliNode = FocusNode();
  final FocusNode jumlahNode = FocusNode();
  final FocusNode dariNode = FocusNode();
  final FocusNode ketNode = FocusNode();

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

  void addStock() async {
    DateTime now = DateTime.now();
    final formattedDate = int.parse(DateFormat('yyyy-MM-dd – kk:mm')
        .format(now)
        .replaceAll(RegExp(r'[^0-9]'), ''));
    final bengkel = StockModel(
        nama: namaController.text,
        hargaBeli: int.parse(
            hargaBeliController.text.replaceAll(RegExp(r'[^0-9]'), '')),
        hargaJual: int.parse(
            hargaJualController.text.replaceAll(RegExp(r'[^0-9]'), '')),
        jumlah: int.parse(jumlahController.text),
        dari: dariController.text,
        ket: ketController.text,
        createdAt: formattedDate,
        isDeleted: 0);
    await bengkelDb.addStock(bengkel);
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
    successIndicator();
  }

  void successIndicator() {
    Flushbar(
      title: 'Success',
      message: 'Berhasil Simpan Stock',
      icon: Icon(
        Icons.done_outline,
        size: 25,
        color: Colors.green.shade300,
      ),
      leftBarIndicatorColor: Colors.blue.shade300,
      duration: Duration(seconds: 2),
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Color(0xff9f5f80),
          title: Text("TAMBAH STOCK"),
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
            controller: namaController,
            focusNode: namaNode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              namaNode.unfocus();
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
            controller: hargaBeliController,
            focusNode: hargaBeliNode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              hargaBeliNode.unfocus();
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
            controller: hargaJualController,
            focusNode: hargaJualNode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              hargaJualNode.unfocus();
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
            controller: jumlahController,
            focusNode: jumlahNode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              jumlahNode.unfocus();
              FocusScope.of(context).requestFocus(dariNode);
            },
            decoration: const InputDecoration(
              labelText: 'Jumlah',
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
            controller: dariController,
            focusNode: dariNode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              dariNode.unfocus();
              FocusScope.of(context).requestFocus(ketNode);
            },
            decoration: const InputDecoration(
              labelText: 'Dari (boleh kosong)',
            ),
          ),
          TextFormField(
            controller: ketController,
            focusNode: ketNode,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (term) {
              ketNode.unfocus();
            },
            decoration: const InputDecoration(
              labelText: 'Keterangan (boleh kosong)',
            ),
          ),
          RaisedButton(
            color: Color(0xff9f5f80),
            onPressed: () {
              // Validate returns true if the form is valid, otherwise false.
              if (_formKey.currentState.validate()) {
                addStock();
              }
            },
            child: Text(
              'SIMPAN',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom)),
        ]));
  }
}
