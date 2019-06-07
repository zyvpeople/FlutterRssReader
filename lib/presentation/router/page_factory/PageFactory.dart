import 'package:flutter/widgets.dart';

abstract class PageFactory {
  Widget feedsPage();

  Widget addFeedPage();

  Widget feedPage(int feedId);

  Widget feedItemPage(int feedItemId);

  Widget browserPage(Uri url);
}
