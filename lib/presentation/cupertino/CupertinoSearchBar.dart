import 'package:flutter/cupertino.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoIconButton.dart';

class CupertinoSearchBar extends StatefulWidget {
  final TextEditingController _textEditingController;
  final ValueChanged<String> _onTextChanged;

  CupertinoSearchBar(this._textEditingController, this._onTextChanged);

  @override
  State createState() => _State(_textEditingController, _onTextChanged);
}

class _State extends State<CupertinoSearchBar> {
  final TextEditingController _textEditingController;
  final _focusNode = FocusNode();
  final ValueChanged<String> _onTextChanged;

  _State(this._textEditingController, this._onTextChanged);

  @override
  Widget build(BuildContext context) {
    const iconColor = Color.fromRGBO(128, 128, 128, 1);
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xffe0e0e0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(children: [
                        Icon(
                          CupertinoIcons.search,
                          color: iconColor,
                        ),
                        Expanded(
                          child: CupertinoTextField(
                            onChanged: _onTextChanged,
                            controller: _textEditingController,
                            focusNode: _focusNode,
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                            ),
                            cursorColor: Color.fromRGBO(0, 122, 255, 1),
                          ),
                        ),
                        CupertinoIconButton(
                            Icon(CupertinoIcons.clear_thick_circled,
                                color: iconColor),
                            () => _onTextChanged(""))
                      ]))
                ])));
  }
}
