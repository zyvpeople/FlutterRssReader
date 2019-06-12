import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';
import 'package:flutter_rss_reader/presentation/router/page_factory/PageFactory.dart';
import 'package:flutter_rss_reader/presentation/router/share/ShareRouter.dart';

class TabletRouter extends StatefulWidget {
  final RouterBloc _routerBloc;
  final PageFactory _pageFactory;
  final ShareRouter _shareRouter;

  TabletRouter(Key key, this._routerBloc, this._pageFactory, this._shareRouter)
      : super(key: key);

  @override
  State createState() => _State(_routerBloc, _pageFactory, _shareRouter);
}

class _State extends State<TabletRouter> {
  final RouterBloc _routerBloc;
  final PageFactory _pageFactory;
  final ShareRouter _shareRouter;
  final _detailEvents = <RouterEvent>[];
  StreamSubscription _routerBlocSubscription;

  _State(this._routerBloc, this._pageFactory, this._shareRouter);

  @override
  void initState() {
    super.initState();
    _routerBlocSubscription = _routerBloc.state.listen((state) {
      final event = state.eventOrNull;
      if (event != null) {
        if (event is OnBack) {
          if (_detailEvents.isNotEmpty) {
            setState(() {
              _detailEvents.removeLast();
            });
          }
        } else if (event is OnShare) {
          _shareRouter.shareUrl(event.url);
        } else if (event is OnAddFeed) {
          if (_detailEvents.isEmpty) {
            setState(() {
              _detailEvents.add(event);
            });
          } else {
            if (!(_detailEvents.last is OnAddFeed)){
              setState(() {
                _detailEvents.clear();
                _detailEvents.add(event);
              });
            }
          }
        } else if (event is OnFeed) {
          if (_detailEvents.isEmpty) {
            setState(() {
              _detailEvents.add(event);
            });
          } else {
            final lastEvent = _detailEvents.last;
            if (lastEvent is OnFeed) {
              if (lastEvent != event) {
                setState(() {
                  _detailEvents.removeLast();
                  _detailEvents.add(event);
                });
              }
            } else {
              setState(() {
                _detailEvents.clear();
                _detailEvents.add(event);
              });
            }
          }
        } else {
          setState(() {
            _detailEvents.add(event);
          });
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
  Widget build(BuildContext context) {
    final master = _pageFactory.feedsPage();
    final Widget detail = _detailEvents.isEmpty
        ? _pageFactory.emptyFeedPage()
        : Stack(children: _detailEvents.map(_eventToWidget).toList());
    return WillPopScope(
        child: Row(children: <Widget>[
          Flexible(flex: 1, child: master),
          Flexible(flex: 3, child: detail)
        ]),
        onWillPop: () {
          if (_detailEvents.length <= 1) {
            SystemNavigator.pop();
          } else {
            _routerBloc.dispatch(OnBack());
          }
        });
  }

  Widget _eventToWidget(RouterEvent event) {
    if (event is OnAddFeed) {
      return Container(child: _pageFactory.addFeedPage(), key: Key("addFeed"));
    } else if (event is OnFeed) {
      return Container(
          child: _pageFactory.feedPage(event.feedId),
          key: Key("feedPage${event.feedId}"));
    } else if (event is OnFeedItem) {
      return Container(
          child: _pageFactory.feedItemPage(event.feedItemId, true),
          key: Key("feedItemPage${event.feedItemId}"));
    } else if (event is OnBrowser) {
      return Container(
          child: _pageFactory.browserPage(event.url, true),
          key: Key("browser${event.url}"));
    } else {
      throw Exception("Unknown event $event");
    }
  }
}
