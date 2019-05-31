import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_rss_reader/domain/entity/FeedItem.dart';
import 'package:flutter_rss_reader/domain/service/FeedService.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';

abstract class FeedEvent {}

class OnRefresh extends FeedEvent {}

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

class FeedState {
  final List<FeedItem> feedItems;
  final bool progress;

  FeedState(this.feedItems, this.progress);

  FeedState withFeedItems(List<FeedItem> feedItems) =>
      FeedState(feedItems, progress);

  FeedState withProgress(bool progress) => FeedState(feedItems, progress);
}

class FeedBlocFactory {
  final int _feedId;
  final FeedService _feedService;
  final RouterBloc _routerBloc;

  FeedBlocFactory(this._feedId, this._feedService, this._routerBloc);

  FeedBloc create() => FeedBloc(_feedId, _feedService, _routerBloc);
}

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final _errorStreamController = StreamController<String>.broadcast();
  final List<StreamSubscription> _subscriptions = [];
  final int _feedId;
  final FeedService _feedService;
  final RouterBloc _routerBloc;

  Stream<String> get errorStream => _errorStreamController.stream;

  FeedBloc._(this._feedId, this._feedService, this._routerBloc);

  factory FeedBloc(int feedId, FeedService feedService, RouterBloc routerBloc) {
    final bloc = FeedBloc._(feedId, feedService, routerBloc);
    bloc._subscriptions.add(feedService.feedItemsChanged
        .listen((_) => bloc.dispatch(OnFeedItemsChanged())));
    bloc._subscriptions.add(feedService.syncStatusChanged
        .listen((_) => {bloc.dispatch(OnSyncStatusChanged())}));
    bloc._subscriptions.add(feedService.syncException
        .listen((it) => {bloc.dispatch(OnSyncError(it))}));
    bloc.dispatch(OnFeedItemsChanged());
    bloc.dispatch(OnSyncStatusChanged());
    bloc.dispatch(OnRefresh());
    return bloc;
  }

  @override
  void dispose() {
    _subscriptions.forEach((it) => it.cancel());
    _subscriptions.clear();
    _errorStreamController.close();
    super.dispose();
  }

  @override
  FeedState get initialState => FeedState([], false);

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if (event is OnRefresh) {
      _feedService.syncFeed(_feedId);
    } else if (event is OnFeedItemsChanged) {
      yield currentState.withFeedItems(await _feedService.feedItems(_feedId));
    } else if (event is OnSyncStatusChanged) {
      yield currentState.withProgress(_feedService.isSync);
    } else if (event is OnSyncError) {
      _errorStreamController.sink.add("Error sync feed");
    } else if (event is OnFeedItemTapped) {
      _routerBloc.dispatch(OnFeedItem(event.feedItemId));
    }
  }
}
