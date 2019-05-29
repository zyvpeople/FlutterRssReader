import 'package:flutter_rss_reader/datasource/logger/LogFormatter.dart';
import 'package:flutter_rss_reader/datasource/logger/LogWriter.dart';

class Logger {
  final LogFormatter _logFormatter;
  final LogWriter _logWriter;

  Logger(this._logFormatter, this._logWriter);

  void d(Object caller, String message) =>
      _logWriter.write(_logFormatter.formatD(caller, message));

  void e(Object caller, String message, Object error) =>
      _logWriter.write(_logFormatter.formatE(caller, message, error));
}
