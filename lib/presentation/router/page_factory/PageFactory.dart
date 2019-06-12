import 'package:flutter/widgets.dart';

abstract class PageFactory {
  Widget feedsPage();

  Widget addFeedPage();

  Widget feedPage(int feedId);

  Widget emptyFeedPage();

  Widget feedItemPage(int feedItemId, bool withBackButton);

  Widget browserPage(Uri url, bool withBackButton);
}
