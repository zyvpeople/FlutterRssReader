import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/presentation/localization/Localization.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MaterialBrowserPage extends StatelessWidget {
  final Uri _url;
  final bool _withBackButton;
  final RouterBloc _routerBloc;

  MaterialBrowserPage(this._url, this._withBackButton, this._routerBloc);

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: _appBar(context), body: _body());

  Widget _appBar(BuildContext context) => AppBar(
      leading: _withBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => _routerBloc.dispatch(OnBack()))
          : null,
      title: Text(Localization.of(context).browserTitle));

  Widget _body() => WebView(
      initialUrl: _url.toString(), javascriptMode: JavascriptMode.unrestricted);
}
