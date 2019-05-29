import 'dart:async';

class NetworkService {

  var _isOnline = true;
  final StreamController _onlineStatusChanged = StreamController.broadcast();

  bool get isOnline => _isOnline;
  Stream get onlineStatusChanged => _onlineStatusChanged.stream;

  NetworkService() {
    //TODO: subscribe to network library
  }

  void release() {
    _onlineStatusChanged.close();
  }
}