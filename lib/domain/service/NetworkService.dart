import 'dart:async';

class NetworkService {

  var _isConnected = false;
  final StreamController<bool> _isConnectedController = StreamController.broadcast();

  bool get isConnected => _isConnected;
  Stream<bool> get isConnectedStream => _isConnectedController.stream;

  NetworkService() {
    //TODO: subscribe to network library
    _isConnectedController.sink.add(_isConnected);
  }

  void release() {
    _isConnectedController.close();
  }
}