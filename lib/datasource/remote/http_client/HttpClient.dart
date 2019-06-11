abstract class HttpClient {
  Future<String> get(Uri url, Map<String, Object> headers);
}
