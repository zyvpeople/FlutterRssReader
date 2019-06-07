import 'package:flutter/cupertino.dart';
import 'package:transparent_image/transparent_image.dart';

class CupertinoListTile extends StatelessWidget {
  final String _title;
  final int _titleMaxLines;
  final Uri _imageUrl;
  final GestureTapCallback _onTap;

  CupertinoListTile(
      this._title, this._titleMaxLines, this._imageUrl, this._onTap);

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        bottom: false,
        minimum: const EdgeInsets.only(
          left: 16,
          top: 8,
          bottom: 8,
          right: 8,
        ),
        child: GestureDetector(
          child: Row(
            children: <Widget>[
              FadeInImage.memoryNetwork(
                  width: 36,
                  height: 36,
                  image: _imageUrl.toString(),
                  placeholder: kTransparentImage),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _title,
                        maxLines: _titleMaxLines,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.8),
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Icon(CupertinoIcons.forward, color: CupertinoColors.inactiveGray),
            ],
          ),
          onTap: _onTap,
        ),
      );
}
