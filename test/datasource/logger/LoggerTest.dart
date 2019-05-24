import 'package:flutter_rss_reader/datasource/logger/LogFormatter.dart';
import 'package:flutter_rss_reader/datasource/logger/LogWriter.dart';
import 'package:flutter_rss_reader/datasource/logger/Logger.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  final formatter = _MockLogFormatter();
  final writer = _MockLogWriter();
  final logger = Logger(formatter, writer);

  test("d writes formatted message", () {
    when(formatter.formatD("test caller", "test debug message"))
        .thenReturn("formatted debug message");

    logger.d("test caller", "test debug message");

    verify(writer.write("formatted debug message"));
  });

  test("e writes formatted message", () {
    final exception = Exception();
    when(formatter.formatE("test caller", "test error message", exception))
        .thenReturn("formatted error message");

    logger.e("test caller", "test error message", exception);

    verify(writer.write("formatted error message"));
  });
}

class _MockLogFormatter extends Mock implements LogFormatter {}

class _MockLogWriter extends Mock implements LogWriter {}
