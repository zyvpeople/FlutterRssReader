import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_rss_reader/domain/service/FeedService.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart'
    as router;

abstract class AddFeedEvent {}

class OnUrlChanged extends AddFeedEvent {
  final String url;

  OnUrlChanged(this.url);
}

class OnAddFeed extends AddFeedEvent {}

class AddFeedState {
  final bool progress;
  final String url;
  final bool urlIsCorrect;

  bool get editable => !progress;

  AddFeedState(this.progress, this.url, this.urlIsCorrect);

  AddFeedState withProgress(bool progress) =>
      AddFeedState(progress, url, urlIsCorrect);
}

class AddFeedBlocFactory {
  final FeedService _feedService;
  final router.RouterBloc _routerBloc;

  AddFeedBlocFactory(this._feedService, this._routerBloc);

  AddFeedBloc create() => AddFeedBloc(_feedService, _routerBloc);
}

class AddFeedBloc extends Bloc<AddFeedEvent, AddFeedState> {
  final _createFeedErrorStreamController = StreamController<String>.broadcast();
  final FeedService _feedService;
  final router.RouterBloc _routerBloc;

  Stream get createFeedErrorStream => _createFeedErrorStreamController.stream;

  AddFeedBloc(this._feedService, this._routerBloc);

  @override
  void dispose() {
    _createFeedErrorStreamController.close();
    super.dispose();
  }

  @override
  AddFeedState get initialState => AddFeedState(false, "", true);

  @override
  Stream<AddFeedState> mapEventToState(AddFeedEvent event) async* {
    if (event is OnUrlChanged) {
      try {
        final url = Uri.parse(event.url);
        yield AddFeedState(currentState.progress, url.toString(), true);
      } catch (e) {
        yield AddFeedState(currentState.progress, event.url, false);
      }
    } else if (event is OnAddFeed) {
      try {
        final url = Uri.parse(currentState.url);
        yield currentState.withProgress(true);
        await _feedService.createFeed(url);
        yield currentState.withProgress(false);
        _routerBloc.dispatch(router.OnBack());
      } catch (e) {
        yield currentState.withProgress(false);
        _createFeedErrorStreamController.sink.add(null);
      }
    }
  }
}
