import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_rss_reader/domain/entity/FeedItem.dart';
import 'package:flutter_rss_reader/domain/service/FeedService.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';

abstract class FeedItemEvent {}

class OnFeedItemLoaded extends FeedItemEvent {
  final FeedItem feedItem;

  OnFeedItemLoaded(this.feedItem);
}

class OnFeedItemNotFound extends FeedItemEvent {}

class OnErrorLoadFeedItem extends FeedItemEvent {
  final Object error;

  OnErrorLoadFeedItem(this.error);
}

class OnOpenInBrowserTapped extends FeedItemEvent {}

class OnShareTapped extends FeedItemEvent {}

class FeedItemState {
  final FeedItem feedItemOrNull;
  final String title;
  final String summary;
  final String date;
  final String imageUrl;

  FeedItemState(
      this.feedItemOrNull, this.title, this.summary, this.date, this.imageUrl);
}

class FeedItemBlocFactory {
  final int _feedItemId;
  final FeedService _feedService;
  final RouterBloc _routerBloc;

  FeedItemBlocFactory(this._feedItemId, this._feedService, this._routerBloc);

  FeedItemBloc create() => FeedItemBloc(_feedItemId, _feedService, _routerBloc);
}

class FeedItemBloc extends Bloc<FeedItemEvent, FeedItemState> {
  final RouterBloc _routerBloc;
  final _errorStreamController = StreamController<String>.broadcast();

  Stream<String> get errorStream => _errorStreamController.stream;

  FeedItemBloc._(this._routerBloc);

  factory FeedItemBloc(
      int feedItemId, FeedService feedService, RouterBloc routerBloc) {
    final bloc = FeedItemBloc._(routerBloc);
    feedService
        .findFeedItem(feedItemId)
        .then((it) => bloc
            .dispatch(it != null ? OnFeedItemLoaded(it) : OnFeedItemNotFound()))
        .catchError((it) => bloc.dispatch(OnErrorLoadFeedItem(it)));
    return bloc;
  }

  @override
  void dispose() {
    _errorStreamController.close();
    super.dispose();
  }

  @override
  FeedItemState get initialState => FeedItemState(null, "", "", "", "");

  @override
  Stream<FeedItemState> mapEventToState(FeedItemEvent event) async* {
    if (event is OnFeedItemLoaded) {
      yield FeedItemState(
          event.feedItem,
          event.feedItem.title,
          event.feedItem.summary,
          event.feedItem.dateTime.toIso8601String(),
          event.feedItem.imageUrl.toString());
    } else if (event is OnFeedItemNotFound) {
      _errorStreamController.sink.add("Feed item does not exist");
    } else if (event is OnErrorLoadFeedItem) {
      _errorStreamController.sink.add("Error load feed item");
    } else if (event is OnOpenInBrowserTapped) {
      final feedItem = currentState.feedItemOrNull;
      if (feedItem != null) {
        _routerBloc.dispatch(OnBrowser(feedItem.url));
      }
    } else if (event is OnShareTapped) {
      final feedItem = currentState.feedItemOrNull;
      if (feedItem != null) {
        _routerBloc.dispatch(OnShare(feedItem.url));
      }
    }
  }
}
