 

import 'dart:async';

import 'package:empire/feature/homepage/data/datasource/metric_remotedatasource.dart';
import 'package:empire/feature/homepage/domain/entities/metric_entity.dart';
import 'package:empire/feature/homepage/domain/repository/metric_repository.dart';
import 'package:empire/feature/revenue/data/repository/revenue_repository_impli.dart';

class MetricsRepositoryImpl implements MetricsRepository {
  final MetricsRemoteDataSource remoteDataSource;
  final _cache = <String, dynamic>{};
  StreamSubscription<List<MetricsData>>? _dataSubscription;
  StreamSubscription<MetricsSummary>? _summarySubscription;

  MetricsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MetricsData>> getMetricsData() async {
    if (_cache.containsKey('metricsData') && !_isCacheExpired('metricsData')) {
      return _cache['metricsData'] as List<MetricsData>;
    }

    final data = await remoteDataSource.getMetricsData();
    _cache['metricsData'] = data;
    _cache['metricsData_timestamp'] = DateTime.now();
    return data;
  }

  @override
  Future<MetricsSummary> getMetricsSummary() async {
    if (_cache.containsKey('metricsSummary') && !_isCacheExpired('metricsSummary')) {
      return _cache['metricsSummary'] as MetricsSummary;
    }

    final summary = await remoteDataSource.getMetricsSummary();
    _cache['metricsSummary'] = summary;
    _cache['metricsSummary_timestamp'] = DateTime.now();
    return summary;
  }

  @override
  Stream<List<MetricsData>> getMetricsDataStream() {
    return remoteDataSource.getMetricsDataStream().asBroadcastStream().doOnData((data) {
      _cache['metricsData'] = data;
      _cache['metricsData_timestamp'] = DateTime.now();
    });
  }

  @override
  Stream<MetricsSummary> getMetricsSummaryStream() {
    return remoteDataSource.getMetricsSummaryStream().asBroadcastStream().doOnData((summary) {
      _cache['metricsSummary'] = summary;
      _cache['metricsSummary_timestamp'] = DateTime.now();
    });
  }

  @override
  void startRealtimeUpdates() {
    if (_dataSubscription != null) return;

    _dataSubscription = getMetricsDataStream().listen((_) {});
    _summarySubscription = getMetricsSummaryStream().listen((_) {});
  }

  @override
  void stopRealtimeUpdates() {
    _dataSubscription?.cancel();
    _summarySubscription?.cancel();
    _dataSubscription = null;
    _summarySubscription = null;
  }

  bool _isCacheExpired(String key) {
    final timestamp = _cache['${key}_timestamp'] as DateTime?;
    if (timestamp == null) return true;
    return DateTime.now().difference(timestamp).inMinutes > 2;  
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    _summarySubscription?.cancel();
    _cache.clear();
    remoteDataSource.dispose();
  }
}