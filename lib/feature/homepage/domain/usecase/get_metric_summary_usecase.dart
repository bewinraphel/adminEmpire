 

import 'package:empire/feature/homepage/domain/entities/metric_entity.dart';
import 'package:empire/feature/homepage/domain/repository/metric_repository.dart';

class GetMetricsSummary {
  final MetricsRepository repository;

  GetMetricsSummary(this.repository);

  Future<MetricsSummary> call() async {
    return await repository.getMetricsSummary();
  }
}