import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rss_reader/domain/common/CompositeStreamSubscription.dart';
import 'package:flutter_rss_reader/presentation/add_feed/AddFeedBloc.dart';
import 'package:flutter_rss_reader/presentation/localization/Localization.dart';
import 'package:flutter_rss_reader/presentation/material/MaterialWidgetFactory.dart';

class MaterialAddFeedPage extends StatefulWidget {
  final AddFeedBlocFactory _addFeedBlocFactory;
  final MaterialWidgetFactory _widgetFactory;

  MaterialAddFeedPage(this._addFeedBlocFactory, this._widgetFactory);

  @override
  State createState() => _State(_addFeedBlocFactory.create(), _widgetFactory);
}

class _State extends State<MaterialAddFeedPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _textEditingController = TextEditingController();
  final AddFeedBloc _addFeedBloc;
  final MaterialWidgetFactory _widgetFactory;
  final _subscription = CompositeStreamSubscription();

  _State(this._addFeedBloc, this._widgetFactory);

  @override
  void initState() {
    super.initState();
    _subscription.add(_addFeedBloc.createFeedErrorStream
        .map((_) => Localization.of(context).errorCreateFeed)
        .listen(_showError));
  }

  @override
  void dispose() {
    _addFeedBloc.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<AddFeedEvent, AddFeedState>(
      bloc: _addFeedBloc,
      builder: (context, state) => Scaffold(
          key: _scaffoldKey,
          appBar: _appBar(),
          body: _body(state),
          floatingActionButton: _fab(state)));

  Widget _appBar() =>
      AppBar(title: Text(Localization.of(context).addFeedTitle));

  Widget _body(AddFeedState state) {
    final textField = TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
            labelText: Localization.of(context).feedUrlHint,
            errorText: state.urlIsCorrect
                ? null
                : Localization.of(context).urlIsNotCorrect),
        keyboardType: TextInputType.url,
        enabled: state.editable,
        onChanged: (it) => _addFeedBloc.dispatch(OnUrlChanged(it)),
        onSubmitted: (it) => _addFeedBloc.dispatch(OnAddFeed()));
    final content = Container(padding: EdgeInsets.all(16), child: textField);
    return state.progress
        ? Stack(children: <Widget>[
            content,
            Center(child: CircularProgressIndicator())
          ])
        : content;
  }

  Widget _fab(AddFeedState state) => FloatingActionButton(
      child: Icon(Icons.add),
      onPressed:
          state.progress ? null : () => _addFeedBloc.dispatch(OnAddFeed()));

  void _showError(String error) {
    _scaffoldKey.currentState
        .showSnackBar(_widgetFactory.createSnackBar(error));
  }
}
