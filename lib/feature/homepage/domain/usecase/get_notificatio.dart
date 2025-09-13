 

import 'package:empire/feature/homepage/domain/entities/notification_entities.dart';

abstract class GetNotifications {
  Future<List<NotificationEntity>> callNotification();
}
