import 'package:flutter/material.dart';

class WidgetFactory {
  SnackBar createSnackBar(String text) =>
      SnackBar(content: Text(text), duration: Duration(seconds: 2));
}
