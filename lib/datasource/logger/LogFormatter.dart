class LogFormatter {
  String formatD(Object caller, String message) =>
      "Debug. Tag: ${caller.toString()}. Message: $message.";

  String formatE(Object caller, String message, Exception exception) =>
      "Error. Tag: ${caller.toString()}. Message: $message. Exception: $exception";
}
