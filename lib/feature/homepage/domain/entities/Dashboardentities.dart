 
import 'package:empire/feature/homepage/domain/entities/notification_entities.dart';

class DashboardEntity {
  final String dateRange;
  final List<NotificationEntity> notifications;

  DashboardEntity({
    required this.dateRange,
    required this.notifications,
  });
}
