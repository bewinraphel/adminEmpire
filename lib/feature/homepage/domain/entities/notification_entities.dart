 
class NotificationEntity {
  final String title;
  final String message;
  final String time;
  final String type;
  final bool isRead;

  NotificationEntity({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
  });
}
