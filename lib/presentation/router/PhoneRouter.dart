import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';
import 'package:flutter_rss_reader/presentation/router/page_factory/PageFactory.dart';
import 'package:share/share.dart';
import 'package:flutter_rss_reader/presentation/router/route_factory/RouteFactory.dart'
    as routeFactory;

class PhoneRouter extends StatefulWidget {
  final RouterBloc _routerBloc;
  final routeFactory.RouteFactory _routeFactory;
  final PageFactory _pageFactory;

  PhoneRouter(this._routerBloc, this._routeFactory, this._pageFactory);

  @override
  State createState() => _State(_routerBloc, _routeFactory, _pageFactory);
}

class _State extends State<PhoneRouter> {
  final RouterBloc _routerBloc;
  final routeFactory.RouteFactory _routeFactory;
  final PageFactory _pageFactory;
  StreamSubscription _routerBlocSubscription;

  _State(this._routerBloc, this._routeFactory, this._pageFactory);

  @override
  void initState() {
    super.initState();
    _routerBlocSubscription = _routerBloc.state.listen((state) {
      final event = state.eventOrNull;
      if (event != null) {
        if (event is OnBack) {
          Navigator.pop(context);
        } else if (event is OnAddFeed) {
          _push(_pageFactory.addFeedPage);
        } else if (event is OnFeed) {
          _push(() => _pageFactory.feedPage(event.feedId));
        } else if (event is OnFeedItem) {
          _push(() => _pageFactory.feedItemPage(event.feedItemId));
        } else if (event is OnBrowser) {
          _push(() => _pageFactory.browserPage(event.url));
        } else if (event is OnShare) {
          //TODO: encapsulate
          Share.share(event.url.toString());
        }
      }
    });
  }

  void _push(Widget pageBuilder()) =>
      Navigator.push(context, _routeFactory.create(pageBuilder));

  @override
  void dispose() {
    _routerBlocSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _pageFactory.feedsPage();
}
