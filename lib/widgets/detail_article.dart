import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailArticle extends StatefulWidget {
  final String url;
  DetailArticle({Key key, @required this.url}) : super(key: key);
  @override
  _DetailArticleState createState() => _DetailArticleState(url);
}

class _DetailArticleState extends State<DetailArticle> {
  final String url;
  _DetailArticleState(this.url);
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black45, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Detail",
          style: TextStyle(color: Colors.black45, fontSize: 16.0),
        ),
      ),
      body: WebView(
        initialUrl: url,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
