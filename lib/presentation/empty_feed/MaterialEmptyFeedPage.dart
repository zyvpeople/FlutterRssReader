import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/presentation/localization/Localization.dart';

class MaterialEmptyFeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(Localization.of(context).feedTitle)),
      body: Center(child: Text(Localization.of(context).noFeedSelected)));
}
