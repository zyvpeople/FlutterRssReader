import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter_rss_reader/datasource/remote/http_client/HttpClient.dart';

class IoHttpClient implements HttpClient {
  @override
  Future<String> get(Uri url, Map<String, Object> headers) => io.HttpClient()
      .getUrl(url)
      .then((request) => request.close())
      .then((response) => response
          .transform(Utf8Decoder())
          .reduce((first, second) => first + second));
}
