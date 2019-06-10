import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_rss_reader/domain/entity/Feed.dart';
import 'package:flutter_rss_reader/domain/entity/FeedItem.dart';
import 'package:flutter_rss_reader/domain/service/FeedService.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';

abstract class FeedEvent {}

class OnRefresh extends FeedEvent {}

class OnFeedChanged extends FeedEvent {}

class OnFeedItemsChanged extends FeedEvent {}

class OnSyncStatusChanged extends FeedEvent {}

class OnSyncError extends FeedEvent {
  final Object error;

  OnSyncError(this.error);
}

class OnFeedItemTapped extends FeedEvent {
  final int feedItemId;

  OnFeedItemTapped(this.feedItemId);
}

class OnOpenInBrowserTapped extends FeedEvent {}

class OnSearchTapped extends FeedEvent {}

class OnSearchTextEntered extends FeedEvent {
  final String text;

  OnSearchTextEntered(this.text);
}

class OnSearchCloseTapped extends FeedEvent {}

class FeedState {
  final Feed feedOrNull;
  final List<FeedItem> feedItems;
  final bool progress;
  final bool search;
  final String searchText;

  String get title => feedOrNull != null ? feedOrNull.title : "";

  FeedState(this.feedOrNull, this.feedItems, this.progress, this.search,
      this.searchText);

  FeedState withFeed(Feed feedOrNull) =>
      FeedState(feedOrNull, feedItems, progress, search, searchText);

  FeedState withFeedItems(List<FeedItem> feedItems) =>
      FeedState(feedOrNull, feedItems, progress, search, searchText);

  FeedState withProgress(bool progress) =>
      FeedState(feedOrNull, feedItems, progress, search, searchText);

  FeedState withSearch(bool search, String searchTextOrNull) =>
      FeedState(feedOrNull, feedItems, progress, search, searchTextOrNull);
}

class FeedBlocFactory {
  final int _feedId;
  final FeedService _feedService;
  final RouterBloc _routerBloc;

  FeedBlocFactory(this._feedId, this._feedService, this._routerBloc);

  FeedBloc create() => FeedBloc(_feedId, _feedService, _routerBloc);
}

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final _syncErrorStreamController = StreamController.broadcast();
  final List<StreamSubscription> _subscriptions = [];
  final int _feedId;
  final FeedService _feedService;
  final RouterBloc _routerBloc;

  Stream get syncErrorStream => _syncErrorStreamController.stream;

  FeedBloc._(this._feedId, this._feedService, this._routerBloc);

  factory FeedBloc(int feedId, FeedService feedService, RouterBloc routerBloc) {
    final bloc = FeedBloc._(feedId, feedService, routerBloc);
    bloc._subscriptions.add(
        feedService.feedsChanged.listen((_) => bloc.dispatch(OnFeedChanged())));
    bloc._subscriptions.add(feedService.feedItemsChanged
        .listen((_) => bloc.dispatch(OnFeedItemsChanged())));
    bloc._subscriptions.add(feedService.syncStatusChanged
        .listen((_) => {bloc.dispatch(OnSyncStatusChanged())}));
    bloc._subscriptions.add(feedService.syncException
        .listen((it) => {bloc.dispatch(OnSyncError(it))}));
    bloc.dispatch(OnFeedChanged());
    bloc.dispatch(OnFeedItemsChanged());
    bloc.dispatch(OnSyncStatusChanged());
    bloc.dispatch(OnRefresh());
    return bloc;
  }

  @override
  void dispose() {
    _subscriptions.forEach((it) => it.cancel());
    _subscriptions.clear();
    _syncErrorStreamController.close();
    super.dispose();
  }

  @override
  FeedState get initialState => FeedState(null, [], false, false, "");

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if (event is OnRefresh) {
      _feedService.syncFeed(_feedId);
    } else if (event is OnFeedChanged) {
      yield currentState.withFeed(await _feedService.findFeed(_feedId));
    } else if (event is OnFeedItemsChanged) {
      yield await _getFeedItems(currentState);
    } else if (event is OnSyncStatusChanged) {
      yield currentState.withProgress(_feedService.isSync);
    } else if (event is OnSyncError) {
      _syncErrorStreamController.sink.add(null);
    } else if (event is OnFeedItemTapped) {
      _routerBloc.dispatch(OnFeedItem(event.feedItemId));
    } else if (event is OnOpenInBrowserTapped) {
      var feed = currentState.feedOrNull;
      if (feed != null) {
        _routerBloc.dispatch(OnBrowser(feed.siteUrl));
      }
    } else if (event is OnSearchTapped) {
      yield currentState.withSearch(true, "");
    } else if (event is OnSearchTextEntered) {
      yield currentState.withSearch(true, event.text);
      yield await _getFeedItems(currentState);
    } else if (event is OnSearchCloseTapped) {
      yield currentState.withSearch(false, "");
      yield await _getFeedItems(currentState);
    }
  }

  Future<FeedState> _getFeedItems(FeedState currentState) async {
    final searchText = currentState.search && currentState.searchText.isNotEmpty
        ? currentState.searchText
        : null;
    final feedItems = await _feedService.feedItems(_feedId, searchText);
    return currentState.withFeedItems(feedItems);
  }
}
