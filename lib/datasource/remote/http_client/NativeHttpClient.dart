import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/datasource/remote/http_client/HttpClient.dart';

class NativeHttpClient implements HttpClient {
  final _channel =
      MethodChannel('com.develop.zuzik.flutter_rss_reader/httpClient');

  @override
  Future<String> get(Uri url, Map<String, Object> headers) => _channel
      .invokeMethod<String>("get", {"url": url.toString(), "headers": headers});
}
