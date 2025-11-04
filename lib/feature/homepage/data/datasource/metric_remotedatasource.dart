// lib/feature/metrics/data/datasources/metrics_remote_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/feature/homepage/domain/entities/metric_entity.dart';
import 'dart:async';
import 'dart:isolate';

 
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
  final StreamController<List<MetricsData>> _dataController = StreamController<List<MetricsData>>.broadcast();
  final StreamController<MetricsSummary> _summaryController = StreamController<MetricsSummary>.broadcast();
  StreamSubscription <List<MetricsData>>? _ordersSubscription;
  StreamSubscription<QuerySnapshot>? _customersSubscription;
  StreamSubscription<QuerySnapshot>? _productsSubscription;

  MetricsRemoteDataSourceImpl({required this.firestore, required this.logger});

  @override
  Future<List<MetricsData>> getMetricsData() async {
    return await _computeInIsolate<List<MetricsData>>(_calculateMetricsDataIsolate, null);
  }

  @override
  Future<MetricsSummary> getMetricsSummary() async {
    return await _computeInIsolate<MetricsSummary>(_calculateMetricsSummaryIsolate, null);
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

  void _startRealtimeUpdates() {
    if (_ordersSubscription != null) return;

 
    _ordersSubscription = firestore
        .collection('orders')
        .where('createdAt', isGreaterThanOrEqualTo: DateTime.now().subtract(const Duration(days: 30)))
        .snapshots()
        .asyncMap((snapshot) async {
      final metricsData = await _computeInIsolate<List<MetricsData>>(_calculateMetricsDataIsolate, null);
      _dataController.add(metricsData);
      
      final summary = await _computeInIsolate<MetricsSummary>(_calculateMetricsSummaryIsolate, null);
      _summaryController.add(summary);
      
      return metricsData;
    }).listen(
      (_) {},
      onError: (error) {
        logger.e('Error in metrics realtime updates', error: error);
        _dataController.addError(error);
        _summaryController.addError(error);
      },
    );

   
    _customersSubscription = firestore.collection('user').snapshots().listen((_) {
     
      _recalculateMetrics();
    });

 
    _productsSubscription = firestore
        .collection('products')
        .where('stock', isLessThanOrEqualTo: 10)
        .snapshots()
        .listen((_) {
      _recalculateMetrics();
    });
  }

  void _recalculateMetrics() async {
    try {
      final metricsData = await _computeInIsolate<List<MetricsData>>(_calculateMetricsDataIsolate, null);
      _dataController.add(metricsData);
      
      final summary = await _computeInIsolate<MetricsSummary>(_calculateMetricsSummaryIsolate, null);
      _summaryController.add(summary);
    } catch (e) {
      logger.e('Error recalculating metrics', error: e);
    }
  }

  // Isolate-compatible static methods
  static Future<List<MetricsData>> _calculateMetricsDataIsolate(dynamic message) async {
    // This would fetch actual data from Firebase in a real implementation
    // For now, return mock data that would be calculated from real data
    return [
      const MetricsData(
        title: "Total Sales",
        value: "\$45,280",
        change: "+12.5%",
        isPositive: true,
        iconName: "attach_money",
        color: 0xFF059669,
      ),
      const MetricsData(
        title: "Orders",
        value: "1,247",
        change: "+8.2%",
        isPositive: true,
        iconName: "shopping_bag",
        color: 0xFF2563EB,
      ),
      const MetricsData(
        title: "Customers",
        value: "892",
        change: "+15.3%",
        isPositive: true,
        iconName: "people",
        color: 0xFFD97706,
      ),
      const MetricsData(
        title: "Low Stock",
        value: "23",
        change: "-5.1%",
        isPositive: false,
        iconName: "warning",
        color: 0xFFDC2626,
      ),
    ];
  }

  static Future<MetricsSummary> _calculateMetricsSummaryIsolate(dynamic message) async {
    // Calculate summary from actual Firebase data
    return const MetricsSummary(
      totalSales: 45280.0,
      totalOrders: 1247,
      totalCustomers: 892,
      lowStockItems: 23,
      salesChange: 12.5,
      ordersChange: 8.2,
      customersChange: 15.3,
      stockChange: -5.1,
    );
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    _customersSubscription?.cancel();
    _productsSubscription?.cancel();
    _dataController.close();
    _summaryController.close();
  }

  // Generic isolate helper
  static Future<T> _computeInIsolate<T>(Function function, dynamic message) async {
    final receivePort = ReceivePort();
    
    await Isolate.spawn<_IsolateMessage>(
      _isolateEntry, 
      _IsolateMessage(
        function: function,
        message: message,
        sendPort: receivePort.sendPort,
      ),
    );
    
    final result = await receivePort.first;
    
    if (result is T) {
      return result;
    } else if (result is Exception) {
      throw result;
    } else {
      throw Exception('Isolate computation failed');
    }
  }

  static void _isolateEntry(_IsolateMessage entry) {
    try {
      final result = entry.function(entry.message);
      entry.sendPort.send(result);
    } catch (e) {
      entry.sendPort.send(e);
    }
  }
}

class _IsolateMessage {
  final Function function;
  final dynamic message;
  final SendPort sendPort;

  _IsolateMessage({
    required this.function,
    required this.message,
    required this.sendPort,
  });
}