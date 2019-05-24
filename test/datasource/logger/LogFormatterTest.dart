import 'package:flutter_rss_reader/datasource/logger/LogFormatter.dart';
import 'package:test/test.dart';

void main() {
  final formatter = LogFormatter();
  final caller = "test caller";

  test("formatD", () {
    final expected = "Debug. Tag: $caller. Message: test debug message.";

    final actual = formatter.formatD(caller, "test debug message");

    expect(actual, expected);
  });

  test("formatE", () {
    final exception = Exception();
    final expected =
        "Error. Tag: $caller. Message: test error message. Exception: $exception";

    final actual = formatter.formatE(caller, "test error message", exception);

    expect(actual, expected);
  });
}
