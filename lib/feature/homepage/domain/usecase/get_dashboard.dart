 

import 'package:empire/feature/homepage/domain/entities/Dashboardentities.dart';

abstract class GetDashboardData {
  Future<DashboardEntity> callDashBoard(String dateRange);
}
