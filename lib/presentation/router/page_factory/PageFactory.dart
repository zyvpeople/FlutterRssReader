import 'package:flutter/widgets.dart';
import 'package:flutter_rss_reader/presentation/add_feed/AddFeedPage.dart';
import 'package:flutter_rss_reader/presentation/browser/BrowserPage.dart';
import 'package:flutter_rss_reader/presentation/common/WidgetFactory.dart';
import 'package:flutter_rss_reader/presentation/feed/FeedPage.dart';
import 'package:flutter_rss_reader/presentation/feed_item/FeedItemPage.dart';
import 'package:flutter_rss_reader/presentation/feeds/FeedsPage.dart';
import 'package:flutter_rss_reader/presentation/router/bloc_factory/BlocFactory.dart';

class PageFactory {
  final BlocFactory _blocFactory;
  final WidgetFactory _widgetFactory;

  PageFactory(this._blocFactory, this._widgetFactory);

  Widget feedsPage() => FeedsPage(_blocFactory.feedsBlocFactory(),
      _blocFactory.onlineStatusBlocFactory(), _widgetFactory);

  Widget addFeedPage() =>
      AddFeedPage(_blocFactory.addFeedBlocFactory(), _widgetFactory);

  Widget feedPage(int feedId) => FeedPage(_blocFactory.feedBlocFactory(feedId),
      _blocFactory.onlineStatusBlocFactory(), _widgetFactory);

  Widget feedItemPage(int feedItemId) => FeedItemPage(
      _blocFactory.feedItemBlocFactory(feedItemId), _widgetFactory);

  Widget browserPage(Uri url) => BrowserPage(url);
}
