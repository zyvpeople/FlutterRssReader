import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rss_reader/domain/common/CompositeStreamSubscription.dart';
import 'package:flutter_rss_reader/presentation/add_feed/AddFeedBloc.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoIconButton.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoWidgetFactory.dart';
import 'package:flutter_rss_reader/presentation/localization/Localization.dart';

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
      builder: (context, state) => CupertinoPageScaffold(
          navigationBar: _navigationBar(state), child: _body(state)));

  Widget _navigationBar(AddFeedState state) => CupertinoNavigationBar(
      middle: Text(Localization.of(context).addFeedTitle),
      trailing: CupertinoIconButton(Icon(CupertinoIcons.add),
          state.progress ? null : () => _addFeedBloc.dispatch(OnAddFeed())));

  Widget _body(AddFeedState state) {
    final textField = CupertinoTextField(
        controller: _textEditingController,
        placeholder: Localization.of(context).feedUrlHint,
        keyboardType: TextInputType.url,
        enabled: state.editable,
        onChanged: (it) => _addFeedBloc.dispatch(OnUrlChanged(it)),
        onSubmitted: (it) => _addFeedBloc.dispatch(OnAddFeed()));
    final content = Container(padding: EdgeInsets.all(16), child: ListView(children: <Widget>[textField]));
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
