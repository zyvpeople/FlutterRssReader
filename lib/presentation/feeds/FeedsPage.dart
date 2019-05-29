import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rss_reader/domain/entity/Feed.dart';
import 'package:flutter_rss_reader/presentation/feeds/FeedsBloc.dart';

class FeedsPage extends StatefulWidget {
  final FeedsBlocFactory _feedsBlocFactory;

  FeedsPage(this._feedsBlocFactory);

  @override
  State createState() => _FeedsState(_feedsBlocFactory.create());
}

class _FeedsState extends State<FeedsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final FeedsBloc _feedsBloc;
  StreamSubscription _errorSubscription;

  _FeedsState(this._feedsBloc);

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
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        child: ListView.builder(
            itemCount: state.feeds.length,
            itemBuilder: (BuildContext context, int index) =>
                _listItem(state.feeds[index])),
        onRefresh: () async {
          _feedsBloc.dispatch(OnRefresh());
        });
  }

  Widget _listItem(Feed feed) => ListTile(
        title: Text(feed.title),
        onTap: () => _feedsBloc.dispatch(OnFeedTapped(feed.id)),
      );

  Widget _fab() => FloatingActionButton(
      child: Text("+"),
      onPressed: () => _feedsBloc.dispatch(OnCreateFeedClicked()));

  void _showError(String error) {
    _scaffoldKey.currentState.showSnackBar(_snackBar(error));
  }

  Widget _snackBar(String text) => SnackBar(content: Text(text));
}
