import 'package:flutter/cupertino.dart';
import 'package:flutter_rss_reader/presentation/localization/Localization.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CupertinoBrowserPage extends StatelessWidget {
  final Uri _url;

  CupertinoBrowserPage(this._url);

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
      navigationBar: _navigationBar(context), child: _body());

  Widget _navigationBar(BuildContext context) => CupertinoNavigationBar(
      middle: Text(Localization.of(context).browserTitle));

  Widget _body() => SafeArea(
      child: WebView(
          initialUrl: _url.toString(),
          javascriptMode: JavascriptMode.unrestricted));
}
