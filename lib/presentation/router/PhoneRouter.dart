import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';
import 'package:flutter_rss_reader/presentation/router/page_factory/PageFactory.dart';
import 'package:flutter_rss_reader/presentation/router/route_factory/RouteFactory.dart'
    as routeFactory;
import 'package:flutter_rss_reader/presentation/router/share/ShareRouter.dart';

class PhoneRouter extends StatefulWidget {
  final RouterBloc _routerBloc;
  final routeFactory.RouteFactory _routeFactory;
  final PageFactory _pageFactory;
  final ShareRouter _shareRouter;

  PhoneRouter(Key key, this._routerBloc, this._routeFactory, this._pageFactory,
      this._shareRouter)
      : super(key: key);

  @override
  State createState() =>
      _State(_routerBloc, _routeFactory, _pageFactory, _shareRouter);
}

class _State extends State<PhoneRouter> {
  final RouterBloc _routerBloc;
  final routeFactory.RouteFactory _routeFactory;
  final PageFactory _pageFactory;
  final ShareRouter _shareRouter;
  StreamSubscription _routerBlocSubscription;

  _State(this._routerBloc, this._routeFactory, this._pageFactory,
      this._shareRouter);

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
          _push(() => _pageFactory.feedItemPage(event.feedItemId, false));
        } else if (event is OnBrowser) {
          _push(() => _pageFactory.browserPage(event.url, false));
        } else if (event is OnShare) {
          _shareRouter.shareUrl(event.url);
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
