import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:ucup_bengkel/model/tokoku_model.dart';
import 'package:intl/intl.dart';
import 'package:ucup_bengkel/provider/tokoku_db_provider.dart';
import 'package:ucup_bengkel/view/page/stock_page.dart';

class OutStockPage extends StatefulWidget {
  // Declare a field that holds the Todo.
  final StockModel stockModel;

  const OutStockPage({Key key, @required this.stockModel}) : super(key: key);

  @override
  _OutStockPageState createState() => _OutStockPageState();
}

class _OutStockPageState extends State<OutStockPage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final hargaJualController = TextEditingController();
  final jumlahController = TextEditingController();
  final diskonController = TextEditingController();

  final FocusNode namaNode = FocusNode();
  final FocusNode hargaJualNode = FocusNode();
  final FocusNode jumlahNode = FocusNode();
  final FocusNode diskonNode = FocusNode();

  void updateStock() async {
    DateTime now = DateTime.now();
    final formattedDate = int.parse(DateFormat('yyyy-MM-dd – kk:mm')
        .format(now)
        .replaceAll(RegExp(r'[^0-9]'), ''));
    final stockUpdated = StockModel(
      id: widget.stockModel.id,
      nama: widget.stockModel.nama,
      hargaBeli: widget.stockModel.hargaBeli,
      hargaJual: widget.stockModel.hargaJual,
      // int.parse(hargaJualController.text.replaceAll(RegExp(r'[^0-9]'), '')),
      dari: widget.stockModel.dari.toString(),
      ket: widget.stockModel.ket.toString(),
      jumlah: widget.stockModel.jumlah - int.parse(jumlahController.text),
      createdAt: formattedDate,
      isDeleted: 0,
    );

    final stockOut = JualModel(
        idStock: widget.stockModel.id,
        hargaJual: int.parse(
            hargaJualController.text.replaceAll(RegExp(r'[^0-9]'), '')),
        jumlah: int.parse(jumlahController.text),
        diskon: int.parse(diskonController.text),
        pembeli: '',
        ket: '',
        createdAt: formattedDate,
        isDeleted: 0);

    TokoDbProvider tokoDb = TokoDbProvider();

    await tokoDb.updateStock(widget.stockModel.id, stockUpdated);
    await tokoDb.addJual(stockOut);
    successIndicator();
    hargaJualController.text = widget.stockModel.hargaJual.toString();
    jumlahController.clear();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    hargaJualController.dispose();
    hargaJualNode.dispose();
    jumlahController.dispose();
    jumlahNode.dispose();
    diskonController.dispose();
    diskonNode.dispose();
  }

  void successIndicator() {
    Flushbar(
      title: 'Success',
      message: 'Berhasil Jual',
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
    // Use the Todo to create the UI.
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Color(0xff9f5f80),
          title: Text("PENJUALAN"),
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
          IgnorePointer(
            child: TextFormField(
              initialValue: widget.stockModel.nama.toString().toUpperCase(),
              focusNode: namaNode,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nama barang',
              ),
              readOnly: true,
            ),
          ),
          TextFormField(
            controller: hargaJualController
              ..text = widget.stockModel.hargaJual.toString(),
            focusNode: hargaJualNode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              hargaJualNode.unfocus();
              FocusScope.of(context).requestFocus(jumlahNode);
            },
            decoration: const InputDecoration(
              labelText: 'Harga jual satuan',
            ),
            inputFormatters: [
              CurrencyTextInputFormatter(
                  locale: 'id', decimalDigits: 0, symbol: 'Rp ')
            ],
            keyboardType: TextInputType.number,
            validator: (value) {
              final hargaBeli = widget.stockModel.hargaBeli;
              if (value.isEmpty) {
                return 'Form harus diisi';
              } else if (int.parse(value.replaceAll(RegExp(r'[^0-9]'), '')) <=
                  widget.stockModel.hargaBeli) {
                return 'Harga jual harus lebih dari Harga beli : $hargaBeli';
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
              FocusScope.of(context).requestFocus(diskonNode);
            },
            decoration: const InputDecoration(
              labelText: 'Banyak',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              final jumlah = widget.stockModel.jumlah;
              if (value.isEmpty) {
                return 'Form harus diisi';
              } else if (int.parse(value.replaceAll(RegExp(r'[^0-9]'), '')) >
                  widget.stockModel.jumlah) {
                return 'Jumlah jual tidak boleh lebih dari Jumlah stok : $jumlah';
              }
              return null;
            },
          ),
          TextFormField(
            controller: diskonController..text = '0',
            // initialValue: widget.stockModel.hargaJual.toString(),
            focusNode: diskonNode,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (term) {
              diskonNode.unfocus();
              hargaJualNode.unfocus();
              jumlahNode.unfocus();
            },
            decoration: const InputDecoration(
              labelText: 'Diskon',
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
              // Validate returns true if the form is valid, otherwise false.
              if (_formKey.currentState.validate()) {
                updateStock();
              }
            },
            child: Text(
              'JUAL',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom)),
        ]));
  }
}
