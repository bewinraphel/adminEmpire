 

import 'package:empire/feature/revenue/domain/entity/revenue_entity.dart';

abstract class RevenueRepository {
  Future<List<RevenueData>> getRevenueData(RevenuePeriod period);
  Future<RevenueSummary> getRevenueSummary(RevenuePeriod period);
  Stream<List<RevenueData>> getRevenueDataStream(RevenuePeriod period);
  Stream<RevenueSummary> getRevenueSummaryStream(RevenuePeriod period);
  
 
  void startRealtimeUpdates(RevenuePeriod period);
  void stopRealtimeUpdates(RevenuePeriod period);
  void dispose();
}