import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_rss_reader/application/CupertinoPresentationFactory.dart';
import 'package:flutter_rss_reader/application/DatasourceFactory.dart';
import 'package:flutter_rss_reader/application/DomainFactory.dart';
import 'package:flutter_rss_reader/application/MaterialPresentationFactory.dart';
import 'package:flutter_rss_reader/application/PresentationFactory.dart';
import 'package:flutter_rss_reader/presentation/router/FormFactorRouter.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';

//TODO: add flavors
//TODO: add themes

void main() {
  var datasourceFactory = DatasourceFactory();
  final domainFactory = DomainFactory(datasourceFactory);
  final routerBloc = RouterBloc();
  final presentationFactory =
      createPresentationFactory(routerBloc, domainFactory);
  runApp(presentationFactory.createApplicationFactory().create(
      "Rss reader",
      FormFactorRouter(
          routerBloc,
          presentationFactory.createRouteFactory(),
          presentationFactory.createPageFactory(),
          presentationFactory.createShareRouter())));
}

PresentationFactory createPresentationFactory(
    RouterBloc routerBloc, DomainFactory domainFactory) {
  if (Platform.isAndroid) {
    return MaterialPresentationFactory(routerBloc, domainFactory);
  } else if (Platform.isIOS) {
    return CupertinoPresentationFactory(routerBloc, domainFactory);
  } else {
    throw Exception("Unsupported platform");
  }
}
