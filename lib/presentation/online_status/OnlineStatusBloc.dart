import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_rss_reader/domain/service/NetworkService.dart';

abstract class OnlineStatusEvent {}

class OnlineStatusChanged extends OnlineStatusEvent {}

class OnlineStatusState {
  final bool visible;

  OnlineStatusState(this.visible);
}

class OnlineStatusBlocFactory {
  final NetworkService _networkService;

  OnlineStatusBlocFactory(this._networkService);

  OnlineStatusBloc create() => OnlineStatusBloc(_networkService);
}

class OnlineStatusBloc extends Bloc<OnlineStatusEvent, OnlineStatusState> {
  final List<StreamSubscription> _subscriptions = [];
  final NetworkService _networkService;

  OnlineStatusBloc._(this._networkService);

  factory OnlineStatusBloc(NetworkService networkService) {
    final bloc = OnlineStatusBloc._(networkService);
    bloc._subscriptions.add(networkService.onlineStatusChanged
        .listen((it) => bloc.dispatch(OnlineStatusChanged())));
    bloc.dispatch(OnlineStatusChanged());
    return bloc;
  }

  @override
  void dispose() {
    _subscriptions.forEach((it) => it.cancel());
    _subscriptions.clear();
    super.dispose();
  }

  @override
  OnlineStatusState get initialState => OnlineStatusState(false);

  @override
  Stream<OnlineStatusState> mapEventToState(OnlineStatusEvent event) async* {
    if (event is OnlineStatusChanged) {
      yield OnlineStatusState(!_networkService.isOnline);
    }
  }
}
