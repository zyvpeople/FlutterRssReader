import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserPage extends StatelessWidget {
  final Uri _url;

  BrowserPage(this._url);

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: _appBar(), body: _body());

  Widget _appBar() => AppBar(title: Text("Browser"));

  Widget _body() => WebView(
      initialUrl: _url.toString(), javascriptMode: JavascriptMode.unrestricted);
}
