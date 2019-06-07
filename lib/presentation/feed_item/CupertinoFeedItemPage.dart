import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoIconButton.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoWidgetFactory.dart';
import 'package:flutter_rss_reader/presentation/feed_item/FeedItemBloc.dart';
import 'package:transparent_image/transparent_image.dart';

class CupertinoFeedItemPage extends StatefulWidget {
  final FeedItemBlocFactory _feedItemBlocFactory;
  final CupertinoWidgetFactory _widgetFactory;

  CupertinoFeedItemPage(this._feedItemBlocFactory, this._widgetFactory);

  @override
  State createState() => _State(_feedItemBlocFactory.create(), _widgetFactory);
}

class _State extends State<CupertinoFeedItemPage> {
  final FeedItemBloc _feedItemBloc;
  final CupertinoWidgetFactory _widgetFactory;
  StreamSubscription _errorSubscription;

  _State(this._feedItemBloc, this._widgetFactory);

  @override
  void initState() {
    super.initState();
    _errorSubscription = _feedItemBloc.errorStream.listen(_showError);
  }

  @override
  void dispose() {
    _feedItemBloc.dispose();
    _errorSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
      navigationBar: _navigationBar(),
      child: BlocBuilder<FeedItemEvent, FeedItemState>(
          bloc: _feedItemBloc, builder: (context, state) => _body(state)));

  Widget _navigationBar() => CupertinoNavigationBar(
      middle: Text("Feed item"),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        CupertinoIconButton(Icon(CupertinoIcons.info),
            () => _feedItemBloc.dispatch(OnOpenInBrowserTapped())),
        CupertinoIconButton(Icon(CupertinoIcons.share),
            () => _feedItemBloc.dispatch(OnShareTapped()))
      ]));

  Widget _body(FeedItemState state) => ListView(children: <Widget>[
        FadeInImage.memoryNetwork(
            height: 200,
            fit: BoxFit.fill,
            image: state.imageUrl,
            placeholder: kTransparentImage),
        Container(
            child: Text(state.title,
                style: TextStyle(fontWeight: FontWeight.bold)),
            margin: EdgeInsets.all(16)),
        Container(
            child: Text(state.date),
            margin: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16)),
        Container(
            child: Text(state.summary),
            margin: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16))
      ]);

  void _showError(String error) {
    showCupertinoDialog(
        context: context,
        builder: (_) => _widgetFactory.createErrorDialog(context, error));
  }
}
