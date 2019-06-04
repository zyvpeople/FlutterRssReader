import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rss_reader/domain/entity/Feed.dart';
import 'package:flutter_rss_reader/presentation/common/WidgetFactory.dart';
import 'package:flutter_rss_reader/presentation/feeds/FeedsBloc.dart';
import 'package:flutter_rss_reader/presentation/online_status/OnlineStatus.dart';
import 'package:flutter_rss_reader/presentation/online_status/OnlineStatusBloc.dart';
import 'package:transparent_image/transparent_image.dart';

class FeedsPage extends StatefulWidget {
  final FeedsBlocFactory _feedsBlocFactory;
  final OnlineStatusBlocFactory _onlineStatusBlocFactory;
  final WidgetFactory _widgetFactory;

  FeedsPage(this._feedsBlocFactory, this._onlineStatusBlocFactory,
      this._widgetFactory);

  @override
  State createState() => _FeedsState(
      _feedsBlocFactory.create(), _onlineStatusBlocFactory, _widgetFactory);
}

class _FeedsState extends State<FeedsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final FeedsBloc _feedsBloc;
  final OnlineStatusBlocFactory _onlineStatusBlocFactory;
  final WidgetFactory _widgetFactory;
  StreamSubscription _errorSubscription;

  _FeedsState(
      this._feedsBloc, this._onlineStatusBlocFactory, this._widgetFactory);

  @override
  void initState() {
    super.initState();
    _errorSubscription = _feedsBloc.errorStream.listen(_showError);
  }

  @override
  void dispose() {
    _feedsBloc.dispose();
    _errorSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      body: BlocBuilder<FeedsEvent, FeedsState>(
          bloc: _feedsBloc,
          builder: (BuildContext context, FeedsState state) => _body(state)),
      floatingActionButton: _fab());

  AppBar _appBar() => AppBar(title: Text("Feeds"));

  Widget _body(FeedsState state) {
    if (state.progress) {
      _refreshIndicatorKey.currentState.show();
    }
    return Column(
      children: [
        OnlineStatus(_onlineStatusBlocFactory),
        Expanded(
          child: RefreshIndicator(
              key: _refreshIndicatorKey,
              child: ListView.builder(
                  itemCount: state.feeds.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _listItem(state.feeds[index])),
              onRefresh: () async {
                _feedsBloc.dispatch(OnRefresh());
              }),
        ),
      ],
    );
  }

  Widget _listItem(Feed feed) => Dismissible(
      key: Key(feed.id.toString()),
      onDismissed: (_) => _feedsBloc.dispatch(OnDeleteFeedItem(feed.id)),
      direction: DismissDirection.endToStart,
      child: ListTile(
          leading: _image(feed),
          title: Text(feed.title),
          onTap: () => _feedsBloc.dispatch(OnFeedTapped(feed.id))));

  Widget _image(Feed feed) => FadeInImage.memoryNetwork(
      width: 36,
      height: 36,
      image: feed.imageUrl.toString(),
      placeholder: kTransparentImage);

  Widget _imagePlaceholder() =>
      Container(color: Colors.white, width: 36, height: 36);

  Widget _fab() => FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => _feedsBloc.dispatch(OnCreateFeedClicked()));

  void _showError(String error) {
    _scaffoldKey.currentState
        .showSnackBar(_widgetFactory.createSnackBar(error));
  }
}
