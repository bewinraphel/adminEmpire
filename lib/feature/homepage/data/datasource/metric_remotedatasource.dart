import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/feature/homepage/domain/entities/metric_entity.dart';
import 'dart:async';

import 'package:logger/web.dart';

abstract class MetricsRemoteDataSource {
  Future<List<MetricsData>> getMetricsData();
  Future<MetricsSummary> getMetricsSummary();
  Stream<List<MetricsData>> getMetricsDataStream();
  Stream<MetricsSummary> getMetricsSummaryStream();
  void dispose();
}

class MetricsRemoteDataSourceImpl implements MetricsRemoteDataSource {
  final FirebaseFirestore firestore;
  final Logger logger;
  final StreamController<List<MetricsData>> _dataController =
      StreamController<List<MetricsData>>.broadcast();
  final StreamController<MetricsSummary> _summaryController =
      StreamController<MetricsSummary>.broadcast();

  // Changed type from StreamSubscription<List<MetricsData>>
  StreamSubscription<QuerySnapshot>? _ordersSubscription;
  StreamSubscription<QuerySnapshot>? _customersSubscription;
  StreamSubscription<QuerySnapshot>? _productsSubscription;

  MetricsRemoteDataSourceImpl({required this.firestore, required this.logger});

  // Updated to call the new helper
  @override
  Future<List<MetricsData>> getMetricsData() async {
    final results = await _fetchAndComputeAllMetrics();
    return results['data'] as List<MetricsData>;
  }

  // Updated to call the new helper
  @override
  Future<MetricsSummary> getMetricsSummary() async {
    final results = await _fetchAndComputeAllMetrics();
    return results['summary'] as MetricsSummary;
  }

  @override
  Stream<List<MetricsData>> getMetricsDataStream() {
    _startRealtimeUpdates();
    return _dataController.stream;
  }

  @override
  Stream<MetricsSummary> getMetricsSummaryStream() {
    _startRealtimeUpdates();
    return _summaryController.stream;
  }

  // Simplified to just call _recalculateMetrics on any update
  void _startRealtimeUpdates() {
    if (_ordersSubscription != null) return; // Already running

    // 1. Get initial data for the streams immediately
    _recalculateMetrics();

    // 2. Centralized error handler for all streams
    void handleError(dynamic error) {
      logger.e('Error in metrics realtime updates', error: error);
      if (!_dataController.isClosed) _dataController.addError(error);
      if (!_summaryController.isClosed) _summaryController.addError(error);
    }

    // 3. Listen to all relevant collections
    _ordersSubscription = firestore
        .collection('orders')
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: DateTime.now().subtract(
            const Duration(days: 30),
          ),
        )
        .snapshots()
        .listen((_) => _recalculateMetrics(), onError: handleError);

    _customersSubscription = firestore
        .collection('user')
        .snapshots()
        .listen((_) => _recalculateMetrics(), onError: handleError);

    _productsSubscription = firestore
        .collection('products')
        .where('quantities', isLessThanOrEqualTo: 10) // From your original code
        .snapshots()
        .listen((_) => _recalculateMetrics(), onError: handleError);
  }

  // Simplified to use the new helper and push to streams
  void _recalculateMetrics() async {
    try {
      // Fetch and compute everything in one go
      final results = await _fetchAndComputeAllMetrics();

      // Add to streams if they are still open
      if (!_dataController.isClosed) {
        _dataController.add(results['data'] as List<MetricsData>);
      }
      if (!_summaryController.isClosed) {
        _summaryController.add(results['summary'] as MetricsSummary);
      }
    } catch (e) {
      logger.e('Error recalculating metrics', error: e);
      // Push errors to the streams
      if (!_dataController.isClosed) _dataController.addError(e);
      if (!_summaryController.isClosed) _summaryController.addError(e);
    }
  }

  Future<Map<String, dynamic>> _fetchAndComputeAllMetrics() async {
    //  Fetch all data in parallel
    final responses = await Future.wait([
      firestore
          .collection('orders')
          .where(
            'createdAt',
            isGreaterThanOrEqualTo: DateTime.now().subtract(
              const Duration(days: 30),
            ),
          )
          .get(),
      firestore.collection('user').get(),
      firestore
          .collection('products')
          .where('quantities', isLessThanOrEqualTo: 100)
          .get(),
    ]);

    final ordersSnapshot = responses[0] as QuerySnapshot;
    final customersSnapshot = responses[1] as QuerySnapshot;
    final lowStockSnapshot = responses[2] as QuerySnapshot;

    double totalSales = 0.0;
    for (final doc in ordersSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>?;

      totalSales += (data?['totalAmount'] ?? 0.0) as num;
    }

    final int orderCount = ordersSnapshot.size;
    final int customerCount = customersSnapshot.size;
    final int lowStockCount = lowStockSnapshot.size;

    const double salesChange = 12.5;
    const double ordersChange = 8.2;
    const double customersChange = 15.3;
    const double stockChange = -5.1;

    final metricsDataList = [
      MetricsData(
        title: "Total Sales",
        value: "\$${totalSales.toStringAsFixed(2)}",
        change: "+$salesChange%",
        isPositive: true,
        iconName: "attach_money",
        color: 0xFF059669,
      ),
      MetricsData(
        title: "Orders",
        value: "$orderCount",
        change: "+$ordersChange%",
        isPositive: true,
        iconName: "shopping_bag",
        color: 0xFF2563EB,
      ),
      MetricsData(
        title: "Customers",
        value: "$customerCount",
        change: "+$customersChange%",
        isPositive: true,
        iconName: "people",
        color: 0xFFD97706,
      ),
      MetricsData(
        title: "Low Stock",
        value: "$lowStockCount",
        change: "$stockChange%",
        isPositive: false,
        iconName: "warning",
        color: 0xFFDC2626,
      ),
    ];

    final metricsSummary = MetricsSummary(
      totalSales: totalSales,
      totalOrders: orderCount,
      totalCustomers: customerCount,
      lowStockItems: lowStockCount,
      salesChange: salesChange,
      ordersChange: ordersChange,
      customersChange: customersChange,
      stockChange: stockChange,
    );

    return {'data': metricsDataList, 'summary': metricsSummary};
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    _customersSubscription?.cancel();
    _productsSubscription?.cancel();
    _dataController.close();
    _summaryController.close();
  }
}
