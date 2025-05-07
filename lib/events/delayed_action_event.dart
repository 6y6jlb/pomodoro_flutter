class DelayedActionEvent {
  final String type;
  final String message;
  final String? soundKey;
  final Map<String, dynamic>? metadata;

  DelayedActionEvent({
    required this.type,
    required this.message,
    this.soundKey,
    this.metadata,
  });
}
