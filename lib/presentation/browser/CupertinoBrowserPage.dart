import 'package:flutter/cupertino.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoIconButton.dart';
import 'package:flutter_rss_reader/presentation/localization/Localization.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CupertinoBrowserPage extends StatelessWidget {
  final Uri _url;
  final bool _withBackButton;
  final RouterBloc _routerBloc;

  CupertinoBrowserPage(this._url, this._withBackButton, this._routerBloc);

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
      navigationBar: _navigationBar(context), child: _body());

  Widget _navigationBar(BuildContext context) => CupertinoNavigationBar(
      leading: _withBackButton
          ? CupertinoIconButton(
              Icon(CupertinoIcons.back), () => _routerBloc.dispatch(OnBack()))
          : null,
      middle: Text(Localization.of(context).browserTitle));

  Widget _body() => SafeArea(
      child: WebView(
          initialUrl: _url.toString(),
          javascriptMode: JavascriptMode.unrestricted));
}
