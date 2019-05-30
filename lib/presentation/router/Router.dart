import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/domain/service/FeedService.dart';
import 'package:flutter_rss_reader/domain/service/NetworkService.dart';
import 'package:flutter_rss_reader/presentation/add_feed/AddFeedBloc.dart';
import 'package:flutter_rss_reader/presentation/add_feed/AddFeedPage.dart';
import 'package:flutter_rss_reader/presentation/browser/BrowserPage.dart';
import 'package:flutter_rss_reader/presentation/common/WidgetFactory.dart';
import 'package:flutter_rss_reader/presentation/feed/FeedBloc.dart';
import 'package:flutter_rss_reader/presentation/feed/FeedPage.dart';
import 'package:flutter_rss_reader/presentation/feed_item/FeedItemBloc.dart';
import 'package:flutter_rss_reader/presentation/feed_item/FeedItemPage.dart';
import 'package:flutter_rss_reader/presentation/feeds/FeedsBloc.dart';
import 'package:flutter_rss_reader/presentation/feeds/FeedsPage.dart';
import 'package:flutter_rss_reader/presentation/online_status/OnlineStatusBloc.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart'
    as router;
import 'package:share/share.dart';

class Router extends StatefulWidget {
  final router.RouterBloc _routerBloc;
  final FeedService _feedService;
  final NetworkService _networkService;
  final WidgetFactory _widgetFactory;

  const Router(this._routerBloc, this._feedService, this._networkService,
      this._widgetFactory);

  @override
  State createState() =>
      _State(_routerBloc, _feedService, _networkService, _widgetFactory);
}

class _State extends State<Router> {
  final router.RouterBloc _routerBloc;
  final FeedService _feedService;
  final NetworkService _networkService;
  final WidgetFactory _widgetFactory;

  StreamSubscription _routerBlocSubscription;

  _State(this._routerBloc, this._feedService, this._networkService,
      this._widgetFactory);

  @override
  void initState() {
    super.initState();
    _routerBlocSubscription = _routerBloc.state.listen((state) {
      final event = state.eventOrNull;
      if (event != null) {
        if (event is router.OnBack) {
          Navigator.pop(context);
        } else if (event is router.OnAddFeed) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => _addFeedPage()));
        } else if (event is router.OnFeed) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => _feedPage(event.feedId)));
        } else if (event is router.OnFeedItem) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => _feedItemPage(event.feedItemId)));
        } else if (event is router.OnBrowser) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => _browserPage(event.url)));
        } else if (event is router.OnShare) {
          Share.share(event.url.toString());
        }
      }
    });
  }

  @override
  void dispose() {
    _routerBlocSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _feedsPage();

  Widget _feedsPage() => FeedsPage(
      _feedsBlocFactory(), _onlineStatusBlocFactory(), _widgetFactory);

  FeedsBlocFactory _feedsBlocFactory() =>
      FeedsBlocFactory(_feedService, _routerBloc);

  Widget _addFeedPage() => AddFeedPage(_addFeedBlocFactory(), _widgetFactory);

  AddFeedBlocFactory _addFeedBlocFactory() =>
      AddFeedBlocFactory(_feedService, _routerBloc);

  Widget _feedPage(int feedId) => FeedPage(
      _feedBlocFactory(feedId), _onlineStatusBlocFactory(), _widgetFactory);

  FeedBlocFactory _feedBlocFactory(int feedId) =>
      FeedBlocFactory(feedId, _feedService, _routerBloc);

  Widget _feedItemPage(int feedItemId) =>
      FeedItemPage(_feedItemBlocFactory(feedItemId), _widgetFactory);

  FeedItemBlocFactory _feedItemBlocFactory(int feedItemId) =>
      FeedItemBlocFactory(feedItemId, _feedService, _routerBloc);

  BrowserPage _browserPage(Uri url) => BrowserPage(url);

  OnlineStatusBlocFactory _onlineStatusBlocFactory() =>
      OnlineStatusBlocFactory(_networkService);
}
