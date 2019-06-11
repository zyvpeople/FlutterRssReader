import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/presentation/router/share/ShareRouter.dart';

class NativeShareRouter implements ShareRouter {
  final _channel = MethodChannel('com.develop.zuzik.flutter_rss_reader/share');

  @override
  void shareUrl(Uri url) =>
      _channel.invokeMethod("url", {"url": url.toString()});
}
