import 'package:flutter/cupertino.dart';
import 'package:flutter_rss_reader/presentation/localization/Localization.dart';

class CupertinoWidgetFactory {
  Widget createErrorDialog(BuildContext context, String error) =>
      CupertinoAlertDialog(
          title: Text(Localization.of(context).errorDialogTitle),
          content: Text(error),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Text(Localization.of(context).buttonOk),
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context))
          ]);
}
