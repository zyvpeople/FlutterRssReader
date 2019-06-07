import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rss_reader/presentation/add_feed/AddFeedBloc.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoIconButton.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoWidgetFactory.dart';

class CupertinoAddFeedPage extends StatefulWidget {
  final AddFeedBlocFactory _addFeedBlocFactory;
  final CupertinoWidgetFactory _widgetFactory;

  CupertinoAddFeedPage(this._addFeedBlocFactory, this._widgetFactory);

  @override
  State createState() => _State(_addFeedBlocFactory.create(), _widgetFactory);
}

class _State extends State<CupertinoAddFeedPage> {
  final _textEditingController = TextEditingController();
  final AddFeedBloc _addFeedBloc;
  final CupertinoWidgetFactory _widgetFactory;
  StreamSubscription _errorSubscription;

  _State(this._addFeedBloc, this._widgetFactory);

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
  Widget build(BuildContext context) => BlocBuilder<AddFeedEvent, AddFeedState>(
      bloc: _addFeedBloc,
      builder: (context, state) => CupertinoPageScaffold(
          navigationBar: _navigationBar(state), child: _body(state)));

  Widget _navigationBar(AddFeedState state) => CupertinoNavigationBar(
      middle: Text("Add feed"),
      trailing: CupertinoIconButton(Icon(CupertinoIcons.add),
          state.progress ? null : () => _addFeedBloc.dispatch(OnAddFeed())));

  Widget _body(AddFeedState state) {
    final textField = CupertinoTextField(
        controller: _textEditingController,
        placeholder: "Feed URL",
        keyboardType: TextInputType.url,
        decoration: BoxDecoration(),
        enabled: state.editable,
        onChanged: (it) => _addFeedBloc.dispatch(OnUrlChanged(it)),
        onSubmitted: (it) => _addFeedBloc.dispatch(OnAddFeed()));
    final content = Container(padding: EdgeInsets.all(16), child: textField);
    return SafeArea(
        child: state.progress
            ? Stack(children: <Widget>[
                content,
                Center(child: CupertinoActivityIndicator(animating: true))
              ])
            : content);
  }

  void _showError(String error) {
    showCupertinoDialog(
        context: context,
        builder: (_) => _widgetFactory.createErrorDialog(context, error));
  }
}
