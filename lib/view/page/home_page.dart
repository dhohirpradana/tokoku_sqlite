import 'package:flutter/material.dart';
import 'package:ucup_bengkel/view/page/sold_page.dart';
import 'package:ucup_bengkel/view/page/stock_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9f5f80),
        title: Text("TOKOKU"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () => Navigator.push(context,
                  PageRouteBuilder(pageBuilder: (c, a1, a2) => StockPage())),
              child: Material(
                elevation: 4,
                child: Container(
                  width: MediaQuery.of(context).size.width * 2 / 3,
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Center(
                    child: Text(
                      "STOK BARANG",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () => Navigator.push(context,
                  PageRouteBuilder(pageBuilder: (c, a1, a2) => SoldPage())),
              child: Material(
                elevation: 4,
                child: Container(
                  width: MediaQuery.of(context).size.width * 2 / 3,
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Center(
                    child: Text(
                      "TERJUAL",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {},
              child: Material(
                elevation: 4,
                child: Container(
                  width: MediaQuery.of(context).size.width * 2 / 3,
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Center(
                    child: Text(
                      "SETTING",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
