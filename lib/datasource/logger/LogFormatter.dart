class LogFormatter {
  String formatD(Object caller, String message) =>
      "Debug. Tag: ${caller.toString()}. Message: $message.";

  String formatE(Object caller, String message, Object error) =>
      "Error. Tag: ${caller.toString()}. Message: $message. Error: $error";
}
