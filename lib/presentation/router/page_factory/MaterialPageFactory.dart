import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rss_reader/presentation/add_feed/MaterialAddFeedPage.dart';
import 'package:flutter_rss_reader/presentation/browser/MaterialBrowserPage.dart';
import 'package:flutter_rss_reader/presentation/empty_feed/MaterialEmptyFeedPage.dart';
import 'package:flutter_rss_reader/presentation/feed/MaterialFeedPage.dart';
import 'package:flutter_rss_reader/presentation/feed_item/MaterialFeedItemPage.dart';
import 'package:flutter_rss_reader/presentation/feeds/MaterialFeedsPage.dart';
import 'package:flutter_rss_reader/presentation/material/MaterialWidgetFactory.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';
import 'package:flutter_rss_reader/presentation/router/bloc_factory/BlocFactory.dart';
import 'package:flutter_rss_reader/presentation/router/page_factory/PageFactory.dart';

class MaterialPageFactory implements PageFactory {
  final BlocFactory _blocFactory;
  final MaterialWidgetFactory _widgetFactory;
  final RouterBloc _routerBloc;

  MaterialPageFactory(this._blocFactory, this._widgetFactory, this._routerBloc);

  @override
  Widget feedsPage() => MaterialFeedsPage(_blocFactory.feedsBlocFactory(),
      _blocFactory.onlineStatusBlocFactory(), _widgetFactory);

  @override
  Widget addFeedPage() =>
      MaterialAddFeedPage(_blocFactory.addFeedBlocFactory(), _widgetFactory);

  @override
  Widget feedPage(int feedId) => MaterialFeedPage(
      _blocFactory.feedBlocFactory(feedId),
      _blocFactory.onlineStatusBlocFactory(),
      _widgetFactory);

  @override
  Widget emptyFeedPage() => MaterialEmptyFeedPage();

  @override
  Widget feedItemPage(int feedItemId, bool withBackButton) =>
      MaterialFeedItemPage(_blocFactory.feedItemBlocFactory(feedItemId),
          _widgetFactory, withBackButton);

  @override
  Widget browserPage(Uri url, bool withBackButton) =>
      MaterialBrowserPage(url, withBackButton, _routerBloc);
}
