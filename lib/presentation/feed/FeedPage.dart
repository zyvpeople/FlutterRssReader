import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rss_reader/domain/entity/FeedItem.dart';
import 'package:flutter_rss_reader/presentation/feed/FeedBloc.dart';
import 'package:flutter_rss_reader/presentation/online_status/OnlineStatus.dart';
import 'package:flutter_rss_reader/presentation/online_status/OnlineStatusBloc.dart';

class FeedPage extends StatefulWidget {
  final FeedBlocFactory _feedBlocFactory;
  final OnlineStatusBlocFactory _onlineStatusBlocFactory;

  FeedPage(this._feedBlocFactory, this._onlineStatusBlocFactory);

  @override
  State createState() =>
      _State(_feedBlocFactory.create(), _onlineStatusBlocFactory);
}

class _State extends State<FeedPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final FeedBloc _feedBloc;
  final OnlineStatusBlocFactory _onlineStatusBlocFactory;
  StreamSubscription _errorSubscription;

  _State(this._feedBloc, this._onlineStatusBlocFactory);

  @override
  void initState() {
    super.initState();
    _errorSubscription = _feedBloc.errorStream.listen(_showError);
  }

  @override
  void dispose() {
    _feedBloc.dispose();
    _errorSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      body: BlocBuilder<FeedEvent, FeedState>(
          bloc: _feedBloc, builder: (context, state) => _body(state)));

  Widget _appBar() => AppBar(title: Text("Feed"));

  Widget _body(FeedState state) {
    if (state.progress) {
      _refreshIndicatorKey.currentState.show();
    }
    return Column(
      children: <Widget>[
        OnlineStatus(_onlineStatusBlocFactory),
        Expanded(
            child: RefreshIndicator(
                key: _refreshIndicatorKey,
                child: ListView.builder(
                    itemCount: state.feedItems.length,
                    itemBuilder: (BuildContext context, int index) =>
                        _listItem(state.feedItems[index])),
                onRefresh: () async {
                  _feedBloc.dispatch(OnRefresh());
                })),
      ],
    );
  }

  Widget _listItem(FeedItem feedItem) => ListTile(
      title: Text(feedItem.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      onTap: () => _feedBloc.dispatch(OnFeedItemTapped(feedItem.id)));

  void _showError(String error) {
    _scaffoldKey.currentState.showSnackBar(_snackBar(error));
  }

  Widget _snackBar(String text) => SnackBar(content: Text(text));
}
