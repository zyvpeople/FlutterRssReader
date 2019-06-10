import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rss_reader/domain/common/CompositeStreamSubscription.dart';
import 'package:flutter_rss_reader/presentation/feed_item/FeedItemBloc.dart';
import 'package:flutter_rss_reader/presentation/localization/Localization.dart';
import 'package:flutter_rss_reader/presentation/material/MaterialWidgetFactory.dart';
import 'package:transparent_image/transparent_image.dart';

class MaterialFeedItemPage extends StatefulWidget {
  final FeedItemBlocFactory _feedItemBlocFactory;
  final MaterialWidgetFactory _widgetFactory;

  MaterialFeedItemPage(this._feedItemBlocFactory, this._widgetFactory);

  @override
  State createState() => _State(_feedItemBlocFactory.create(), _widgetFactory);
}

class _State extends State<MaterialFeedItemPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FeedItemBloc _feedItemBloc;
  final MaterialWidgetFactory _widgetFactory;
  final _subscription = CompositeStreamSubscription();

  _State(this._feedItemBloc, this._widgetFactory);

  @override
  void initState() {
    super.initState();
    _subscription.add(_feedItemBloc.feedItemDoesNotExistErrorStream
        .map((_) => Localization.of(context).errorFeedItemDoesNotExist)
        .listen(_showError));
    _subscription.add(_feedItemBloc.loadFeedItemErrorStream
        .map((_) => Localization.of(context).errorLoadFeedItem)
        .listen(_showError));
  }

  @override
  void dispose() {
    _feedItemBloc.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      body: BlocBuilder<FeedItemEvent, FeedItemState>(
          bloc: _feedItemBloc, builder: (context, state) => _body(state)));

  Widget _appBar() => AppBar(
          title: Text(Localization.of(context).feedItemTitle),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.open_in_browser),
                onPressed: () =>
                    _feedItemBloc.dispatch(OnOpenInBrowserTapped())),
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () => _feedItemBloc.dispatch(OnShareTapped()))
          ]);

  Widget _body(FeedItemState state) => ListView(children: <Widget>[
        FadeInImage.memoryNetwork(
            height: 200,
            fit: BoxFit.fill,
            image: state.imageUrl,
            placeholder: kTransparentImage),
        Container(
            child: Text(state.title,
                style: TextStyle(fontWeight: FontWeight.bold)),
            margin: EdgeInsets.all(16)),
        Container(
            child: Text(state.date),
            margin: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16)),
        Container(
            child: Text(state.summary),
            margin: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16))
      ]);

  void _showError(String error) {
    _scaffoldKey.currentState
        .showSnackBar(_widgetFactory.createSnackBar(error));
  }
}
