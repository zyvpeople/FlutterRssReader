import 'package:flutter/cupertino.dart';

class CupertinoWidgetFactory {
  Widget createErrorDialog(BuildContext context, String error) =>
      CupertinoAlertDialog(
          title: Text("Error"),
          content: Text(error),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Text("OK"),
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context))
          ]);
}