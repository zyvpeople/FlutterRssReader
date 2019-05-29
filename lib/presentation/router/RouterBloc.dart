import 'package:bloc/bloc.dart';

class RouterState {
  final RouterEvent eventOrNull;

  RouterState(this.eventOrNull);
}

abstract class RouterEvent {}

class OnAddFeed extends RouterEvent {}

class OnBack extends RouterEvent {}

class OnFeed extends RouterEvent {
  final int feedId;

  OnFeed(this.feedId);
}

class OnFeedItem extends RouterEvent {
  final int feedItemId;

  OnFeedItem(this.feedItemId);
}

class OnBrowser extends RouterEvent {
  final Uri url;

  OnBrowser(this.url);
}

class RouterBloc extends Bloc<RouterEvent, RouterState> {
  @override
  RouterState get initialState => RouterState(null);

  @override
  Stream<RouterState> mapEventToState(RouterEvent event) async* {
    yield RouterState(event);
    yield RouterState(null);
  }
}
