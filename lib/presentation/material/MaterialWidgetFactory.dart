import 'package:flutter/material.dart';
//TODO: rename. move to material package
class MaterialWidgetFactory {
  SnackBar createSnackBar(String text) =>
      SnackBar(content: Text(text), duration: Duration(seconds: 2));
}
