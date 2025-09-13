 

// import 'package:empire/feature/homepage/domain/entities/Dashboardentities.dart';
// import 'package:empire/feature/homepage/domain/entities/notification_entities.dart';
// import 'package:empire/feature/homepage/domain/usecase/get_dashboard.dart';
// import 'package:empire/feature/homepage/domain/usecase/get_notificatio.dart';

// class DashboardRepositoryImpl implements GetDashboardData, GetNotifications {
//   @override
//   Future<DashboardEntity> callDashBoard(String dateRange) async {
//     await Future.delayed(const Duration(milliseconds: 1500)); 
//     return DashboardEntity(dateRange: dateRange, notifications: await this.getNotifications());
//   }

//   @override
//   Future<List<NotificationEntity>> callNotification() async {
//     return [
//       NotificationEntity(
//         title: "Low Stock Alert",
//         message: "iPhone 15 Pro Case is running low (5 units left)",
//         time: "2 minutes ago",
//         type: "warning",
//         isRead: false,
//       ),
//       NotificationEntity(
//         title: "New Order",
//         message: "Order #ORD-2025-006 received from Sarah Johnson",
//         time: "15 minutes ago",
//         type: "info",
//         isRead: false,
//       ),
//       NotificationEntity(
//         title: "Payment Received",
//         message: "Payment of \$245.99 confirmed for Order #ORD-2025-001",
//         time: "1 hour ago",
//         type: "success",
//         isRead: true,
//       ),
//     ];
//   }

//   Future<List<NotificationEntity>> getNotifications() => call();
// }
