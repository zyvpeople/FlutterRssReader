import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CupertinoBrowserPage extends StatelessWidget {
  final Uri _url;

  CupertinoBrowserPage(this._url);

  @override
  Widget build(BuildContext context) =>
      CupertinoPageScaffold(navigationBar: _navigationBar(), child: _body());

  Widget _navigationBar() => CupertinoNavigationBar(middle: Text("Browser"));

  Widget _body() => SafeArea(
      child: WebView(
          initialUrl: _url.toString(),
          javascriptMode: JavascriptMode.unrestricted));
}
