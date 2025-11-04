 
import 'package:empire/feature/revenue/domain/entity/revenue_entity.dart';
import 'package:empire/feature/revenue/domain/repository/revenue_repo.dart';

class GetRevenueSummary {
  final RevenueRepository repository;

  GetRevenueSummary(this.repository);

  Future<RevenueSummary> call(RevenuePeriod period) async {
    return await repository.getRevenueSummary(period);
  }
}