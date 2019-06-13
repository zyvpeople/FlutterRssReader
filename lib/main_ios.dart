import 'package:flutter/widgets.dart';
import 'package:flutter_rss_reader/application/CupertinoPresentationFactory.dart';
import 'package:flutter_rss_reader/application/DatasourceFactory.dart';
import 'package:flutter_rss_reader/application/DomainFactory.dart';
import 'package:flutter_rss_reader/presentation/router/FormFactorRouter.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';

void main() {
  var datasourceFactory = DatasourceFactory();
  final domainFactory = DomainFactory(datasourceFactory);
  final routerBloc = RouterBloc();
  final presentationFactory =
      CupertinoPresentationFactory(routerBloc, domainFactory);
  runApp(presentationFactory.createApplicationFactory().create(
      "Rss reader",
      FormFactorRouter(
          routerBloc,
          presentationFactory.createRouteFactory(),
          presentationFactory.createPageFactory(),
          presentationFactory.createShareRouter())));
}
