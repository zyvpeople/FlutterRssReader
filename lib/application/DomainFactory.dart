import 'package:flutter_rss_reader/domain/service/FeedService.dart';
import 'package:flutter_rss_reader/domain/service/NetworkService.dart';
import 'package:flutter_rss_reader/application/DatasourceFactory.dart';

class DomainFactory {
  final DatasourceFactory _datasourceFactory;
  final NetworkService _networkService;

  NetworkService get networkService => _networkService;

  DomainFactory(this._datasourceFactory) : _networkService = NetworkService();

  FeedService createFeedService() => FeedService(
      _datasourceFactory.createFeedRemoteRepository(),
      _datasourceFactory.createFeedLocalRepository(),
      _networkService,
      _datasourceFactory.createLogger());
}
