import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rss_reader/presentation/feed_item/FeedItemBloc.dart';

//TODO: add url sharing
//TODO: use paralax
class FeedItemPage extends StatefulWidget {
  final FeedItemBlocFactory _feedItemBlocFactory;

  FeedItemPage(this._feedItemBlocFactory);

  @override
  State createState() => _State(_feedItemBlocFactory.create());
}

class _State extends State<FeedItemPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FeedItemBloc _feedItemBloc;
  StreamSubscription _errorSubscription;

  _State(this._feedItemBloc);

  @override
  void initState() {
    super.initState();
    _errorSubscription = _feedItemBloc.errorStream.listen(_showError);
  }

  @override
  void dispose() {
    _feedItemBloc.dispose();
    _errorSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      body: BlocBuilder<FeedItemEvent, FeedItemState>(
          bloc: _feedItemBloc, builder: (context, state) => _body(state)));

  Widget _appBar() => AppBar(title: Text("Feed item"), actions: <Widget>[
        IconButton(
            icon: Icon(Icons.open_in_browser),
            onPressed: () => _feedItemBloc.dispatch(OnOpenInBrowserTapped()))
      ]);

  Widget _body(FeedItemState state) => ListView(children: <Widget>[
        Image.network(
          state.imageUrl,
          height: 200,
          fit: BoxFit.fill,
        ),
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
    _scaffoldKey.currentState.showSnackBar(_snackBar(error));
  }

  Widget _snackBar(String text) => SnackBar(content: Text(text));
}
