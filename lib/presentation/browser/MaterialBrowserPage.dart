import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/presentation/localization/Localization.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MaterialBrowserPage extends StatelessWidget {
  final Uri _url;

  MaterialBrowserPage(this._url);

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: _appBar(context), body: _body());

  Widget _appBar(BuildContext context) =>
      AppBar(title: Text(Localization.of(context).browserTitle));

  Widget _body() => WebView(
      initialUrl: _url.toString(), javascriptMode: JavascriptMode.unrestricted);
}
