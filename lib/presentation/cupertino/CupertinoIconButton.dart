import 'package:flutter/cupertino.dart';

class CupertinoIconButton extends StatelessWidget {
  final Icon _icon;
  final GestureTapCallback _onTap;

  CupertinoIconButton(this._icon, this._onTap);

  @override
  Widget build(BuildContext context) =>
      GestureDetector(child: _icon, onTap: _onTap);
}
