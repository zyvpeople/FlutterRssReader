import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rss_reader/presentation/online_status/OnlineStatusBloc.dart';

class OnlineStatus extends StatefulWidget {
  final OnlineStatusBlocFactory _onlineStatusBlocFactory;

  OnlineStatus(this._onlineStatusBlocFactory);

  @override
  State createState() => _State(_onlineStatusBlocFactory.create());
}

class _State extends State<OnlineStatus> {
  final OnlineStatusBloc _onlineStatusBloc;

  _State(this._onlineStatusBloc);

  @override
  void dispose() {
    _onlineStatusBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<OnlineStatusEvent, OnlineStatusState>(
          bloc: _onlineStatusBloc,
          builder: (context, state) {
            if (state.visible) {
              return Text("No Internet connection");
            } else {
              return Container();
            }
          });
}
