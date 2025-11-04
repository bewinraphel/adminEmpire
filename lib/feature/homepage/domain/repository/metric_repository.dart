 

import 'package:empire/feature/homepage/domain/entities/metric_entity.dart';

abstract class MetricsRepository {
  Future<List<MetricsData>> getMetricsData();
  Future<MetricsSummary> getMetricsSummary();
  Stream<List<MetricsData>> getMetricsDataStream();
  Stream<MetricsSummary> getMetricsSummaryStream();
  void startRealtimeUpdates();
  void stopRealtimeUpdates();
  void dispose();
}