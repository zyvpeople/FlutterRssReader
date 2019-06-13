import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/presentation/localization/Localization.dart';

class MaterialSearch extends StatelessWidget {
  final TextEditingController _textEditingController;
  final ValueChanged<String> _onTextChanged;

  MaterialSearch(this._textEditingController, this._onTextChanged);

  @override
  Widget build(BuildContext context) => TextField(
      controller: _textEditingController,
      keyboardType: TextInputType.text,
      autofocus: true,
      onChanged: _onTextChanged,
      decoration: InputDecoration.collapsed(
          hintText: Localization.of(context).searchHint));
}
