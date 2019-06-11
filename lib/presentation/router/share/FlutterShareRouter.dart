import 'package:flutter_rss_reader/presentation/router/share/ShareRouter.dart';
import 'package:share/share.dart';

class FlutterShareRouter implements ShareRouter {
  @override
  void shareUrl(Uri url) => Share.share(url.toString());
}
