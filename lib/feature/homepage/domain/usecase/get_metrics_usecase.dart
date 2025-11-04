 

import 'package:empire/feature/homepage/domain/entities/metric_entity.dart';
import 'package:empire/feature/homepage/domain/repository/metric_repository.dart';

class GetMetricsData {
  final MetricsRepository repository;

  GetMetricsData(this.repository);

  Future<List<MetricsData>> call() async {
    return await repository.getMetricsData();
  }
}