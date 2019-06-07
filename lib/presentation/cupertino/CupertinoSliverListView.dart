import 'package:flutter/cupertino.dart';

class CupertinoSliverListView extends StatelessWidget {
  final int _itemsCount;
  final IndexedWidgetBuilder _itemBuilder;

  CupertinoSliverListView(this._itemsCount, this._itemBuilder);

  @override
  Widget build(BuildContext context) => SliverList(
      delegate: SliverChildBuilderDelegate((context, index) =>
      index < _itemsCount ? _itemBuilder(context, index) : null));
}
