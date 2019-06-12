import 'package:flutter/cupertino.dart';
import 'package:flutter_rss_reader/presentation/localization/Localization.dart';

class CupertinoEmptyFeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: Text(Localization.of(context).feedTitle)),
      child: Center(child: Text(Localization.of(context).noFeedSelected)));
}
