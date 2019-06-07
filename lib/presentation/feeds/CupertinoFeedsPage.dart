import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoIconButton.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoListTile.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoSearchBar.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoSliverListView.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoWidgetFactory.dart';
import 'package:flutter_rss_reader/presentation/feeds/FeedsBloc.dart';

//TODO: add online indicator
//TODO: fix pull to refresh
class CupertinoFeedsPage extends StatefulWidget {
  final FeedsBlocFactory _feedsBlocFactory;
  final CupertinoWidgetFactory _widgetFactory;

  CupertinoFeedsPage(this._feedsBlocFactory, this._widgetFactory);

  @override
  State createState() => _State(_feedsBlocFactory.create(), _widgetFactory);
}

class _State extends State<CupertinoFeedsPage> {
  final _textEditingController = TextEditingController();
  final FeedsBloc _feedsBloc;
  final CupertinoWidgetFactory _widgetFactory;
  StreamSubscription _errorSubscription;

  _State(this._feedsBloc, this._widgetFactory);

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
      builder: (BuildContext context, FeedsState state) =>
          CupertinoPageScaffold(
              navigationBar: _navigationBar(state),
              child: _body(context, state)));

  Widget _navigationBar(FeedsState state) =>
      state.search ? _searchNavigationBar(state) : _noSearchNavigationBar();

  Widget _searchNavigationBar(FeedsState state) => CupertinoNavigationBar(
      middle: Padding(
        padding: EdgeInsets.only(right: 8),
        child: _searchBar(state.searchText),
      ),
      trailing: GestureDetector(
          child: Text("Cancel",
              style: TextStyle(color: CupertinoColors.activeBlue)),
          onTap: () => _feedsBloc.dispatch(OnSearchCloseTapped())));

  Widget _searchBar(String text) {
    if (_textEditingController.text != text) {
      _textEditingController.text = text;
    }
    return CupertinoSearchBar(_textEditingController,
        (it) => _feedsBloc.dispatch(OnSearchTextEntered(it)));
  }

  Widget _noSearchNavigationBar() => CupertinoNavigationBar(
      middle: Text("Feeds"),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        CupertinoIconButton(Icon(CupertinoIcons.search),
            () => _feedsBloc.dispatch(OnSearchTapped())),
        CupertinoIconButton(Icon(CupertinoIcons.add),
            () => _feedsBloc.dispatch(OnCreateFeedClicked()))
      ]));

  Widget _body(BuildContext context, FeedsState state) {
    return SafeArea(
        child: CustomScrollView(slivers: <Widget>[
      CupertinoSliverRefreshControl(
          onRefresh: () async => _feedsBloc.dispatch(OnRefresh())),
      CupertinoSliverListView(state.feeds.length, (context, index) {
        final feed = state.feeds[index];
        return CupertinoListTile(feed.title, feed.imageUrl,
            () => _feedsBloc.dispatch(OnFeedTapped(feed.id)));
      })
    ]));
  }

  void _showError(String error) {
    showCupertinoDialog(
        context: context,
        builder: (_) => _widgetFactory.createErrorDialog(context, error));
  }
}
