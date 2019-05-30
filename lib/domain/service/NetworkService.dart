import 'dart:async';

import 'package:connectivity/connectivity.dart';

class NetworkService {
  final _subscriptions = <StreamSubscription>[];
  var _isOnline = true;
  final StreamController _onlineStatusChanged = StreamController.broadcast();

  bool get isOnline => _isOnline;

  Stream get onlineStatusChanged => _onlineStatusChanged.stream;

  NetworkService._();

  factory NetworkService() {
    final service = NetworkService._();
    final connectivity = Connectivity();
    final checkIsOnlineAndNotify = (ConnectivityResult result) {
      service._isOnline = result != ConnectivityResult.none;
      service._onlineStatusChanged.add(null);
    };
    service._subscriptions
        .add(connectivity.onConnectivityChanged.listen(checkIsOnlineAndNotify));
    connectivity.checkConnectivity().then(checkIsOnlineAndNotify);
    return service;
  }

  void release() {
    _subscriptions.forEach((it) => it.cancel());
    _onlineStatusChanged.close();
  }
}
