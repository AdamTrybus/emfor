import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NetworkView extends StatelessWidget {
  static const String routeName = "network-view";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emfor"),
        actions: [
          IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      ),
      body: WebView(
        initialUrl:
            "https://www.szkolnictwo.pl/szukaj,Komunizm", //ModalRoute.of(context).settings.arguments,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
