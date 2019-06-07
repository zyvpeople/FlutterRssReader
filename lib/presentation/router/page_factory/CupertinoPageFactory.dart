import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rss_reader/presentation/add_feed/CupertinoAddFeedPage.dart';
import 'package:flutter_rss_reader/presentation/browser/CupertinoBrowserPage.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoWidgetFactory.dart';
import 'package:flutter_rss_reader/presentation/feed/CupertinoFeedPage.dart';
import 'package:flutter_rss_reader/presentation/feed_item/CupertinoFeedItemPage.dart';
import 'package:flutter_rss_reader/presentation/feeds/CupertinoFeedsPage.dart';
import 'package:flutter_rss_reader/presentation/router/bloc_factory/BlocFactory.dart';
import 'package:flutter_rss_reader/presentation/router/page_factory/PageFactory.dart';

class CupertinoPageFactory implements PageFactory {
  final BlocFactory _blocFactory;
  final CupertinoWidgetFactory _widgetFactory;

  CupertinoPageFactory(this._blocFactory, this._widgetFactory);

  @override
  Widget feedsPage() =>
      CupertinoFeedsPage(_blocFactory.feedsBlocFactory(), _widgetFactory);

  @override
  Widget addFeedPage() =>
      CupertinoAddFeedPage(_blocFactory.addFeedBlocFactory(), _widgetFactory);

  @override
  Widget feedPage(int feedId) => CupertinoFeedPage(
      _blocFactory.feedBlocFactory(feedId),
      _blocFactory.onlineStatusBlocFactory(),
      _widgetFactory);

  @override
  Widget feedItemPage(int feedItemId) => CupertinoFeedItemPage(
      _blocFactory.feedItemBlocFactory(feedItemId), _widgetFactory);

  @override
  Widget browserPage(Uri url) => CupertinoBrowserPage(url);
}
