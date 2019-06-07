import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rss_reader/domain/entity/Feed.dart';
import 'package:flutter_rss_reader/presentation/material/MaterialWidgetFactory.dart';
import 'package:flutter_rss_reader/presentation/feeds/FeedsBloc.dart';
import 'package:flutter_rss_reader/presentation/online_status/OnlineStatus.dart';
import 'package:flutter_rss_reader/presentation/online_status/OnlineStatusBloc.dart';
import 'package:transparent_image/transparent_image.dart';

class FeedsPage extends StatefulWidget {
  final FeedsBlocFactory _feedsBlocFactory;
  final OnlineStatusBlocFactory _onlineStatusBlocFactory;
  final MaterialWidgetFactory _widgetFactory;

  FeedsPage(this._feedsBlocFactory, this._onlineStatusBlocFactory,
      this._widgetFactory);

  @override
  State createState() => _State(
      _feedsBlocFactory.create(), _onlineStatusBlocFactory, _widgetFactory);
}

class _State extends State<FeedsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final  _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final _textEditingController = TextEditingController();
  final FeedsBloc _feedsBloc;
  final OnlineStatusBlocFactory _onlineStatusBlocFactory;
  final MaterialWidgetFactory _widgetFactory;
  StreamSubscription _errorSubscription;

  _State(
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
  Widget build(BuildContext context) => BlocBuilder<FeedsEvent, FeedsState>(
      bloc: _feedsBloc,
      builder: (BuildContext context, FeedsState state) => Scaffold(
          key: _scaffoldKey,
          appBar: _appBar(state),
          body: _body(state),
          floatingActionButton: _fab()));

  AppBar _appBar(FeedsState state) =>
      state.search ? _searchAppBar(state) : _noSearchAppBar();

  AppBar _searchAppBar(FeedsState state) =>
      AppBar(title: _search(state.searchText), actions: <Widget>[
        IconButton(
            icon: Icon(Icons.close),
            onPressed: () => _feedsBloc.dispatch(OnSearchCloseTapped()))
      ]);

  Widget _search(String text) {
    if (_textEditingController.text != text) {
      _textEditingController.text = text;
    }
    return TextField(
        controller: _textEditingController,
        keyboardType: TextInputType.text,
        autofocus: true,
        onChanged: (it) => _feedsBloc.dispatch(OnSearchTextEntered(it)),
        decoration: InputDecoration.collapsed(hintText: "Search"));
  }

  AppBar _noSearchAppBar() =>
      AppBar(title: Text("Feeds"), actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _feedsBloc.dispatch(OnSearchTapped()))
      ]);

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
              onRefresh: () async => _feedsBloc.dispatch(OnRefresh())),
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

  Widget _fab() => FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => _feedsBloc.dispatch(OnCreateFeedClicked()));

  void _showError(String error) {
    _scaffoldKey.currentState
        .showSnackBar(_widgetFactory.createSnackBar(error));
  }
}
