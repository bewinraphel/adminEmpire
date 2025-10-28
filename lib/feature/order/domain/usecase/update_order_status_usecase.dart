import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/order/domain/repository/order_repository.dart';

class UpdateOrderStatusUseCase {
  final OrderRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  Future<Either<Failures, void>> call(String orderId, String newStatus) {
    return repository.updateOrderStatus(orderId, newStatus);
  }
}