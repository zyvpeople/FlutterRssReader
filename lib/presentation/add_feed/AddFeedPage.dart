import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rss_reader/presentation/add_feed/AddFeedBloc.dart';

class AddFeedPage extends StatefulWidget {
  final AddFeedBlocFactory _addFeedBlocFactory;

  AddFeedPage(this._addFeedBlocFactory);

  @override
  State createState() => _State(_addFeedBlocFactory.create());
}

class _State extends State<AddFeedPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final textEditingController = TextEditingController();
  final AddFeedBloc _addFeedBloc;
  StreamSubscription _errorSubscription;

  _State(this._addFeedBloc);

  @override
  void initState() {
    super.initState();
    _errorSubscription = _addFeedBloc.errorStream.listen(_showError);
  }

  @override
  void dispose() {
    _addFeedBloc.dispose();
    _errorSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      body: BlocBuilder<AddFeedEvent, AddFeedState>(
          bloc: _addFeedBloc, builder: (context, state) => _body(state)),
    );
  }

  Widget _appBar() => AppBar(
        title: Text("Add feed"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () =>
                  _addFeedBloc.dispatch(OnAddFeed(textEditingController.text)))
        ],
      );

  Widget _body(AddFeedState state) {
    final content = Column(
      children: <Widget>[
        Text("Add feed"),
        TextField(controller: textEditingController)
      ],
    );
    return state.progress
        ? Stack(children: <Widget>[content, CircularProgressIndicator()])
        : content;
  }

  void _showError(String error) {
    _scaffoldKey.currentState.showSnackBar(_snackBar(error));
  }

  //TODO: move snackbar to widget factory
  Widget _snackBar(String text) => SnackBar(content: Text(text));
}
