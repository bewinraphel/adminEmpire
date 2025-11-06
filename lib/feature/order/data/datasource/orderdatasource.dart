import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/order/data/model/order_model.dart';
import 'package:logger/logger.dart';

abstract class OrderRemoteDataSource {
  Future<String> createOrder(OrderModel order);
  Future<List<OrderModel>> getOrders();
  Stream<List<OrderModel>> watchOrders();
  Future<Either<Failures, void>> updateOrderStatus(
    String orderId,
    String newStatus,
  );
  // Future<OrderModel> getOrderById();
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore firestore;
  final Logger logger;

  OrderRemoteDataSourceImpl({required this.firestore, required this.logger});

  @override
  Future<String> createOrder(OrderModel order) async {
    logger.d('Creating order: ${order.orderId}');
    try {
      await firestore
          .collection('orders')
          .doc(order.orderId)
          .set(order.toJson());
      return order.orderId;
    } catch (e, s) {
      logger.e('Error creating order', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final snapshot = await firestore
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'orderId': doc.id}))
          .toList();
    } catch (e, s) {
      logger.e('Error fetching orders', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Stream<List<OrderModel>> watchOrders() {
    return firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    OrderModel.fromJson({...doc.data(), 'orderId': doc.id}),
              )
              .toList(),
        );
  }

  @override
  Future<Either<Failures, void>> updateOrderStatus(
    String orderId,
    String newStatus,
  ) async {
    try {
      await firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
        'over': newStatus == 'completed' ? true : false,
      });
      return const Right(null);
    } catch (e) {
      return Left(Failures.server('Failed to update order status: $e'));
    }
  }
}
