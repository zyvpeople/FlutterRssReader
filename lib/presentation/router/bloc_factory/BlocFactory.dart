import 'package:flutter_rss_reader/domain/service/FeedService.dart';
import 'package:flutter_rss_reader/domain/service/NetworkService.dart';
import 'package:flutter_rss_reader/presentation/add_feed/AddFeedBloc.dart';
import 'package:flutter_rss_reader/presentation/feed/FeedBloc.dart';
import 'package:flutter_rss_reader/presentation/feed_item/FeedItemBloc.dart';
import 'package:flutter_rss_reader/presentation/feeds/FeedsBloc.dart';
import 'package:flutter_rss_reader/presentation/online_status/OnlineStatusBloc.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';

class BlocFactory {
  final FeedService _feedService;
  final NetworkService _networkService;
  final RouterBloc _routerBloc;

  BlocFactory(this._feedService, this._networkService, this._routerBloc);

  FeedsBlocFactory feedsBlocFactory() =>
      FeedsBlocFactory(_feedService, _routerBloc);

  AddFeedBlocFactory addFeedBlocFactory() =>
      AddFeedBlocFactory(_feedService, _routerBloc);

  FeedBlocFactory feedBlocFactory(int feedId) =>
      FeedBlocFactory(feedId, _feedService, _routerBloc);

  FeedItemBlocFactory feedItemBlocFactory(int feedItemId) =>
      FeedItemBlocFactory(feedItemId, _feedService, _routerBloc);

  OnlineStatusBlocFactory onlineStatusBlocFactory() =>
      OnlineStatusBlocFactory(_networkService);
}
