import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_rss_reader/domain/common/CompositeStreamSubscription.dart';
import 'package:flutter_rss_reader/domain/entity/Feed.dart';
import 'package:flutter_rss_reader/domain/service/FeedService.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';

class FeedsState {
  final List<Feed> feeds;
  final bool progress;
  final bool search;
  final String searchText;

  FeedsState(this.feeds, this.progress, this.search, this.searchText);

  FeedsState withFeeds(List<Feed> feeds) =>
      FeedsState(feeds, progress, search, searchText);

  FeedsState withProgress(bool progress) =>
      FeedsState(feeds, progress, search, searchText);

  FeedsState withSearch(bool search, String searchTextOrNull) =>
      FeedsState(feeds, progress, search, searchTextOrNull);
}

abstract class FeedsEvent {}

class OnRefresh extends FeedsEvent {}

class OnCreateFeedClicked extends FeedsEvent {}

class OnFeedsChanged extends FeedsEvent {}

class OnSyncStatusChanged extends FeedsEvent {}

class OnSyncError extends FeedsEvent {
  final Object exception;

  OnSyncError(this.exception);
}

class OnFeedTapped extends FeedsEvent {
  final int feedId;

  OnFeedTapped(this.feedId);
}

class OnDeleteFeedItem extends FeedsEvent {
  final int feedId;

  OnDeleteFeedItem(this.feedId);
}

class OnSearchTapped extends FeedsEvent {}

class OnSearchTextEntered extends FeedsEvent {
  final String text;

  OnSearchTextEntered(this.text);
}

class OnSearchCloseTapped extends FeedsEvent {}

class FeedsBlocFactory {
  final FeedService _feedService;
  final RouterBloc _routerBloc;

  FeedsBlocFactory(this._feedService, this._routerBloc);

  FeedsBloc create() => FeedsBloc(_feedService, _routerBloc);
}

class FeedsBloc extends Bloc<FeedsEvent, FeedsState> {
  final FeedService _feedService;
  final RouterBloc _routerBloc;
  final _subscription = CompositeStreamSubscription();
  final _syncErrorStreamController = StreamController.broadcast();
  final _deleteFeedErrorStreamController = StreamController.broadcast();

  Stream get syncFeedsErrorStream =>
      _syncErrorStreamController.stream;

  Stream get deleteFeedErrorStream =>
      _deleteFeedErrorStreamController.stream;

  FeedsBloc._(this._feedService, this._routerBloc);

  factory FeedsBloc(FeedService feedService, RouterBloc routerBloc) {
    final bloc = FeedsBloc._(feedService, routerBloc);
    bloc._subscription.add(feedService.feedsChanged
        .listen((it) => bloc.dispatch(OnFeedsChanged())));
    bloc._subscription.add(feedService.syncStatusChanged
        .listen((_) => bloc.dispatch(OnSyncStatusChanged())));
    bloc._subscription.add(feedService.syncException
        .listen((it) => bloc.dispatch(OnSyncError(it))));
    bloc.dispatch(OnFeedsChanged());
    bloc.dispatch(OnSyncStatusChanged());
    bloc.dispatch(OnRefresh());
    return bloc;
  }

  @override
  void dispose() {
    _subscription.cancel();
    _syncErrorStreamController.close();
    _deleteFeedErrorStreamController.close();
    super.dispose();
  }

  @override
  FeedsState get initialState => FeedsState([], false, false, "");

  @override
  Stream<FeedsState> mapEventToState(FeedsEvent event) async* {
    if (event is OnRefresh) {
      _feedService.syncAll();
    } else if (event is OnCreateFeedClicked) {
      _routerBloc.dispatch(OnAddFeed());
    } else if (event is OnFeedsChanged) {
      yield await _getFeeds(currentState);
    } else if (event is OnSyncStatusChanged) {
      yield currentState.withProgress(_feedService.isSync);
    } else if (event is OnSyncError) {
      _syncErrorStreamController.add(null);
    } else if (event is OnFeedTapped) {
      _routerBloc.dispatch(OnFeed(event.feedId));
    } else if (event is OnDeleteFeedItem) {
      try {
        _feedService.deleteFeed(event.feedId);
      } catch (e) {
        _deleteFeedErrorStreamController.sink.add(null);
      }
    } else if (event is OnSearchTapped) {
      yield currentState.withSearch(true, "");
    } else if (event is OnSearchTextEntered) {
      yield currentState.withSearch(true, event.text);
      yield await _getFeeds(currentState);
    } else if (event is OnSearchCloseTapped) {
      yield currentState.withSearch(false, "");
      yield await _getFeeds(currentState);
    }
  }

  Future<FeedsState> _getFeeds(FeedsState currentState) async {
    final searchText = currentState.search && currentState.searchText.isNotEmpty
        ? currentState.searchText
        : null;
    final feeds = await _feedService.feeds(searchText);
    return currentState.withFeeds(feeds);
  }
}
