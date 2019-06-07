import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rss_reader/domain/entity/FeedItem.dart';
import 'package:flutter_rss_reader/presentation/material/MaterialWidgetFactory.dart';
import 'package:flutter_rss_reader/presentation/feed/FeedBloc.dart';
import 'package:flutter_rss_reader/presentation/online_status/OnlineStatus.dart';
import 'package:flutter_rss_reader/presentation/online_status/OnlineStatusBloc.dart';
import 'package:transparent_image/transparent_image.dart';

class FeedPage extends StatefulWidget {
  final FeedBlocFactory _feedBlocFactory;
  final OnlineStatusBlocFactory _onlineStatusBlocFactory;
  final MaterialWidgetFactory _widgetFactory;

  FeedPage(this._feedBlocFactory, this._onlineStatusBlocFactory,
      this._widgetFactory);

  @override
  State createState() => _State(
      _feedBlocFactory.create(), _onlineStatusBlocFactory, _widgetFactory);
}

class _State extends State<FeedPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final _textEditingController = TextEditingController();
  final FeedBloc _feedBloc;
  final OnlineStatusBlocFactory _onlineStatusBlocFactory;
  final MaterialWidgetFactory _widgetFactory;
  StreamSubscription _errorSubscription;

  _State(this._feedBloc, this._onlineStatusBlocFactory, this._widgetFactory);

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
  Widget build(BuildContext context) => BlocBuilder<FeedEvent, FeedState>(
      bloc: _feedBloc,
      builder: (context, state) => Scaffold(
          key: _scaffoldKey, appBar: _appBar(state), body: _body(state)));

  AppBar _appBar(FeedState state) =>
      state.search ? _searchAppBar(state) : _noSearchAppBar();

  AppBar _searchAppBar(FeedState state) =>
      AppBar(title: _search(state.searchText), actions: <Widget>[
        IconButton(
            icon: Icon(Icons.close),
            onPressed: () => _feedBloc.dispatch(OnSearchCloseTapped()))
      ]);

  Widget _search(String text) {
    if (_textEditingController.text != text) {
      _textEditingController.text = text;
    }
    return TextField(
        controller: _textEditingController,
        keyboardType: TextInputType.text,
        autofocus: true,
        onChanged: (it) => _feedBloc.dispatch(OnSearchTextEntered(it)),
        decoration: InputDecoration.collapsed(hintText: "Search"));
  }

  AppBar _noSearchAppBar() => AppBar(title: Text("Feeds"), actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _feedBloc.dispatch(OnSearchTapped())),
        IconButton(
            icon: Icon(Icons.open_in_browser),
            onPressed: () => _feedBloc.dispatch(OnOpenInBrowserTapped()))
      ]);

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
      leading: _image(feedItem),
      title: Text(feedItem.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      onTap: () => _feedBloc.dispatch(OnFeedItemTapped(feedItem.id)));

  Widget _image(FeedItem feedItem) => FadeInImage.memoryNetwork(
      width: 36,
      height: 36,
      image: feedItem.imageUrl.toString(),
      placeholder: kTransparentImage);

  void _showError(String error) {
    _scaffoldKey.currentState
        .showSnackBar(_widgetFactory.createSnackBar(error));
  }
}
