 

import 'package:empire/feature/revenue/domain/entity/revenue_entity.dart';
import 'package:empire/feature/revenue/domain/repository/revenue_repo.dart';

class GetRevenueData {
  final RevenueRepository repository;

  GetRevenueData(this.repository);

  Future<List<RevenueData>> call(RevenuePeriod period) async {
    return await repository.getRevenueData(period);
  }
}