class AlertMessage {
  final String header;
  final String message;
  final int? shouldShowFor;

  const AlertMessage({
    required this.header,
    required this.message,
    this.shouldShowFor,
  });

  @override
  String toString() {
    return 'AlertMessage(header: $header, message: $message, shouldShowFor: $shouldShowFor)';
  }
}
