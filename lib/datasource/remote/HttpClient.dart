import 'dart:io' as io;
import 'dart:convert';

class HttpClient {
  Future<String> get(Uri url, Map<String, Object> headers) => io.HttpClient()
      .getUrl(url)
      .then((request) => request.close())
      .then((response) => response
          .transform(Utf8Decoder())
          .reduce((first, second) => first + second));
}
