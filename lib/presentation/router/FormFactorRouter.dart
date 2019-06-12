import 'package:flutter/widgets.dart';
import 'package:flutter_rss_reader/presentation/router/PhoneRouter.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';
import 'package:flutter_rss_reader/presentation/router/TabletRouter.dart';
import 'package:flutter_rss_reader/presentation/router/page_factory/PageFactory.dart';
import 'package:flutter_rss_reader/presentation/router/route_factory/RouteFactory.dart'
    as routeFactory;
import 'package:flutter_rss_reader/presentation/router/share/ShareRouter.dart';

class FormFactorRouter extends StatelessWidget {
  static const _tabletMinimumSize = 600;

  final RouterBloc _routerBloc;
  final routeFactory.RouteFactory _routeFactory;
  final PageFactory _pageFactory;
  final ShareRouter _shareRouter;

  FormFactorRouter(this._routerBloc, this._routeFactory, this._pageFactory,
      this._shareRouter);

  @override
  Widget build(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide < _tabletMinimumSize
          ? PhoneRouter(Key("phoneRouter"), _routerBloc, _routeFactory,
              _pageFactory, _shareRouter)
          : TabletRouter(
              Key("tabletRouter"), _routerBloc, _pageFactory, _shareRouter);
}
