class NotificationEvent {
  final String type;
  final String message;
  final String? soundKey;
  final Map<String, dynamic>? metadata;

  NotificationEvent({
    required this.type,
    required this.message,
    this.soundKey,
    this.metadata,
  });
}
