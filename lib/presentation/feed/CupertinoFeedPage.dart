import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rss_reader/domain/common/CompositeStreamSubscription.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoIconButton.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoListTile.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoSearchBar.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoSliverListView.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoWidgetFactory.dart';
import 'package:flutter_rss_reader/presentation/feed/FeedBloc.dart';
import 'package:flutter_rss_reader/presentation/localization/Localization.dart';
import 'package:flutter_rss_reader/presentation/online_status/OnlineStatusBloc.dart';

class CupertinoFeedPage extends StatefulWidget {
  final FeedBlocFactory _feedBlocFactory;
  final OnlineStatusBlocFactory _onlineStatusBlocFactory;
  final CupertinoWidgetFactory _widgetFactory;

  CupertinoFeedPage(this._feedBlocFactory, this._onlineStatusBlocFactory,
      this._widgetFactory);

  @override
  State createState() => _State(
      _feedBlocFactory.create(), _onlineStatusBlocFactory, _widgetFactory);
}

class _State extends State<CupertinoFeedPage> {
  final _textEditingController = TextEditingController();
  final FeedBloc _feedBloc;
  final OnlineStatusBlocFactory _onlineStatusBlocFactory;
  final CupertinoWidgetFactory _widgetFactory;
  final _subscription = CompositeStreamSubscription();

  _State(this._feedBloc, this._onlineStatusBlocFactory, this._widgetFactory);

  @override
  void initState() {
    super.initState();
    _subscription.add(_feedBloc.syncErrorStream
        .map((_) => Localization.of(context).errorSync)
        .listen(_showError));
  }

  @override
  void dispose() {
    _feedBloc.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<FeedEvent, FeedState>(
      bloc: _feedBloc,
      builder: (context, state) => CupertinoPageScaffold(
          navigationBar: _navigationBar(state), child: _body(state)));

  Widget _navigationBar(FeedState state) =>
      state.search ? _searchNavigationBar(state) : _noSearchNavigationBar();

  Widget _searchNavigationBar(FeedState state) => CupertinoNavigationBar(
      middle: Padding(
        padding: EdgeInsets.only(right: 8),
        child: _searchBar(state.searchText),
      ),
      trailing: GestureDetector(
          child: Text(Localization.of(context).buttonSearchCancel,
              style: TextStyle(color: CupertinoColors.activeBlue)),
          onTap: () => _feedBloc.dispatch(OnSearchCloseTapped())));

  Widget _searchBar(String text) {
    if (_textEditingController.text != text) {
      _textEditingController.text = text;
    }
    return CupertinoSearchBar(_textEditingController,
        (it) => _feedBloc.dispatch(OnSearchTextEntered(it)));
  }

  Widget _noSearchNavigationBar() => CupertinoNavigationBar(
      middle: Text(Localization.of(context).feedTitle),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        CupertinoIconButton(Icon(CupertinoIcons.search),
            () => _feedBloc.dispatch(OnSearchTapped())),
        CupertinoIconButton(Icon(CupertinoIcons.book),
            () => _feedBloc.dispatch(OnOpenInBrowserTapped()))
      ]));

  Widget _body(FeedState state) {
    return SafeArea(
        child: CustomScrollView(slivers: <Widget>[
      CupertinoSliverRefreshControl(
          onRefresh: () async => _feedBloc.dispatch(OnRefresh())),
      CupertinoSliverListView(state.feedItems.length, (context, index) {
        final feedItem = state.feedItems[index];
        return CupertinoListTile(feedItem.title, 2, feedItem.imageUrl,
            () => _feedBloc.dispatch(OnFeedItemTapped(feedItem.id)));
      })
    ]));
  }

  void _showError(String error) {
    showCupertinoDialog(
        context: context,
        builder: (_) => _widgetFactory.createErrorDialog(context, error));
  }
}
