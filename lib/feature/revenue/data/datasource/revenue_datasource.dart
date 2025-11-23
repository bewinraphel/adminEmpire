 import 'dart:async';
// import 'dart:isolate'; // Removed

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/feature/revenue/domain/entity/revenue_entity.dart';
import 'package:intl/intl.dart';
import 'package:logger/web.dart';

abstract class RevenueRemoteDataSource {
  Future<List<RevenueData>> getRevenueData(RevenuePeriod period);
  Future<RevenueSummary> getRevenueSummary(RevenuePeriod period);
  Stream<List<RevenueData>> getRevenueDataStream(RevenuePeriod period);
  Stream<RevenueSummary> getRevenueSummaryStream(RevenuePeriod period);
}

class RevenueRemoteDataSourceImpl implements RevenueRemoteDataSource {
  final FirebaseFirestore firestore;
  final Logger logger;
  final Map<RevenuePeriod, StreamController<List<RevenueData>>> _dataControllers = {};
  final Map<RevenuePeriod, StreamController<RevenueSummary>> _summaryControllers = {};
  final Map<RevenuePeriod, StreamSubscription<List<RevenueData>>> _subscriptions = {};

  RevenueRemoteDataSourceImpl({required this.firestore, required this.logger});

  @override
  Future<List<RevenueData>> getRevenueData(RevenuePeriod period) async {
    try {
      final now = DateTime.now();
      DateTime startDate = _getStartDate(period, now);

      final snapshot = await firestore
          .collection('orders')
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .get();

       return _processRevenueData(
        snapshot.docs,
        period,
        now,
      );
    } catch (e, s) {
      logger.e('Error fetching revenue data', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<RevenueSummary> getRevenueSummary(RevenuePeriod period) async {
    final revenueData = await getRevenueData(period);
    
    // Call the processing function directly
    return _calculateRevenueSummary(
      revenueData,
      period,
    );
  }

  @override
  Stream<List<RevenueData>> getRevenueDataStream(RevenuePeriod period) {
    _dataControllers[period] ??= StreamController<List<RevenueData>>.broadcast();
    _startRealtimeUpdates(period);
    return _dataControllers[period]!.stream;
  }

  @override
  Stream<RevenueSummary> getRevenueSummaryStream(RevenuePeriod period) {
    _summaryControllers[period] ??= StreamController<RevenueSummary>.broadcast();
    _startRealtimeUpdates(period);
    return _summaryControllers[period]!.stream;
  }

  void _startRealtimeUpdates(RevenuePeriod period) {
    if (_subscriptions.containsKey(period)) return;

    final now = DateTime.now();
    DateTime startDate = _getStartDate(period, now);

    final StreamSubscription<List<RevenueData>> subscription = firestore
        .collection('orders')
        .where('createdAt', isGreaterThanOrEqualTo: startDate)
        .snapshots()
        .asyncMap((snapshot) async {
      // Call the processing function directly
      final data = _processRevenueData(
        snapshot.docs,
        period,
        now,
      );

      _dataControllers[period]?.add(data);

      // Call the processing function directly
      final summary = _calculateRevenueSummary(
        data,
        period,
      );

      _summaryControllers[period]?.add(summary);

      return data;
    }).listen(
      (_) {},
      onError: (error) {
        logger.e('Error in realtime updates', error: error);
        _dataControllers[period]?.addError(error);
        _summaryControllers[period]?.addError(error);
      },
    );

    _subscriptions[period] = subscription;
  }

  // Removed _revenueDataToMap as it was only used for isolate serialization

  void dispose() {
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    for (final controller in _dataControllers.values) {
      controller.close();
    }
    for (final controller in _summaryControllers.values) {
      controller.close();
    }
    _subscriptions.clear();
    _dataControllers.clear();
    _summaryControllers.clear();
  }

  // Refactored from _processRevenueDataIsolate to take direct arguments
  static List<RevenueData> _processRevenueData(
    List<QueryDocumentSnapshot> docs,
    RevenuePeriod period,
    DateTime now,
  ) {
    if (docs.isEmpty) return [];

    final Map<String, RevenueData> groupedData = {};

    for (final doc in docs) {
      final orderData = doc.data() as Map<String, dynamic>;
      final createdAt = _parseTimestamp(orderData['createdAt']);
      final totalAmount = (orderData['totalAmount'] as num).toDouble();

      final dateKey = _getDateKey(createdAt, period);

      if (!groupedData.containsKey(dateKey)) {
        groupedData[dateKey] = RevenueData(
          date: _getPeriodDate(createdAt, period),
          revenue: 0.0,
          orders: 0,
        );
      }

      final currentData = groupedData[dateKey]!;
      groupedData[dateKey] = RevenueData(
        date: currentData.date,
        revenue: currentData.revenue + totalAmount,
        orders: currentData.orders + 1,
      );
    }

    return _fillMissingPeriods(groupedData, period, now);
  }

  // Refactored from _calculateRevenueSummaryIsolate to take direct arguments
  static RevenueSummary _calculateRevenueSummary(
    List<RevenueData> data,
    RevenuePeriod period,
  ) {
    if (data.isEmpty) {
      return const RevenueSummary(
        totalRevenue: 0.0,
        averageOrderValue: 0.0,
        conversionRate: 0.0,
        revenueChange: 0.0,
        aovChange: 0.0,
        conversionChange: 0.0,
        totalOrder: 0,
      );
    }

    final currentPeriodRevenue = data.fold(0.0, (sum, item) => sum + item.revenue);
    final currentPeriodOrders = data.fold(0, (sum, item) => sum + item.orders);
    final currentAOV = currentPeriodOrders > 0 ? currentPeriodRevenue / currentPeriodOrders : 0.0;

    final revenueChange = _calculateTrend(data.map((d) => d.revenue).toList());
    final aovChange = _calculateTrend(data.map((d) => d.orders > 0 ? d.revenue / d.orders : 0.0).toList());
    final conversionChange = _calculateTrend(data.map((d) => d.orders.toDouble()).toList());

    final conversionRate = _estimateConversionRate(currentPeriodOrders, period);

    return RevenueSummary(
      totalRevenue: currentPeriodRevenue,
      averageOrderValue: currentAOV,
      conversionRate: conversionRate,
      revenueChange: revenueChange,
      aovChange: aovChange,
      conversionChange: conversionChange,
      totalOrder: currentPeriodOrders,
    );
  }

  static double _calculateTrend(List<double> values) {
    if (values.length < 2) return 0.0;

    final recentCount = values.length > 3 ? 3 : values.length ~/ 2;
    final recent = values.sublist(values.length - recentCount);
    final previous = values.sublist(0, values.length - recentCount);

    if (previous.isEmpty) return 0.0;

    final recentAvg = recent.reduce((a, b) => a + b) / recent.length;
    final previousAvg = previous.reduce((a, b) => a + b) / previous.length;

    return previousAvg > 0 ? ((recentAvg - previousAvg) / previousAvg) * 100 : 0.0;
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.parse(timestamp);
    } else {
      return DateTime.now();
    }
  }

  static String _getDateKey(DateTime date, RevenuePeriod period) {
    switch (period) {
      case RevenuePeriod.daily:
        return DateFormat('yyyy-MM-dd').format(date);
      case RevenuePeriod.weekly:
        final year = date.year;
        final weekNumber = _getWeekNumber(date);
        return '$year-W$weekNumber';
      case RevenuePeriod.monthly:
        return DateFormat('yyyy-MM').format(date);
    }
  }

  static DateTime _getPeriodDate(DateTime date, RevenuePeriod period) {
    switch (period) {
      case RevenuePeriod.daily:
        return DateTime(date.year, date.month, date.day);
      case RevenuePeriod.weekly:
        final weekday = date.weekday;
        return date.subtract(Duration(days: weekday - 1));
      case RevenuePeriod.monthly:
        return DateTime(date.year, date.month, 1);
    }
  }

  static int _getWeekNumber(DateTime date) {
    final firstJan = DateTime(date.year, 1, 1);
    final daysDiff = date.difference(firstJan).inDays;
    return ((daysDiff + firstJan.weekday - 1) / 7).floor() + 1;
  }

  static List<RevenueData> _fillMissingPeriods(
    Map<String, RevenueData> groupedData,
    RevenuePeriod period,
    DateTime now,
  ) {
    final List<RevenueData> result = [];
    final int periodsToShow;

    switch (period) {
      case RevenuePeriod.daily:
        periodsToShow = 7;
        break;
      case RevenuePeriod.weekly:
        periodsToShow = 4;
        break;
      case RevenuePeriod.monthly:
        periodsToShow = 12;
        break;
    }

    for (int i = periodsToShow - 1; i >= 0; i--) {
      final periodDate = _getPeriodStartDate(now, period, i);
      final periodKey = _getDateKey(periodDate, period);

      if (groupedData.containsKey(periodKey)) {
        result.add(groupedData[periodKey]!);
      } else {
        result.add(RevenueData(
          date: periodDate,
          revenue: 0.0,
          orders: 0,
        ));
      }
    }

    return result;
  }

  static DateTime _getPeriodStartDate(DateTime now, RevenuePeriod period, int periodsAgo) {
    switch (period) {
      case RevenuePeriod.daily:
        return DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: periodsAgo));
      case RevenuePeriod.weekly:
        final monday = now.subtract(Duration(days: now.weekday - 1));
        return monday.subtract(Duration(days: periodsAgo * 7));
      case RevenuePeriod.monthly:
        return DateTime(now.year, now.month - periodsAgo, 1);
    }
  }

  static double _estimateConversionRate(int orders, RevenuePeriod period) {
    const Map<RevenuePeriod, double> baseRates = {
      RevenuePeriod.daily: 3.0,
      RevenuePeriod.weekly: 3.2,
      RevenuePeriod.monthly: 3.5,
    };

    final baseRate = baseRates[period] ?? 3.0;

    if (orders > 50) return baseRate + 1.0;
    if (orders > 20) return baseRate + 0.5;
    if (orders > 0) return baseRate;
    return 0.0;
  }

  DateTime _getStartDate(RevenuePeriod period, DateTime now) {
    switch (period) {
      case RevenuePeriod.daily:
        return now.subtract(const Duration(days: 7));
      case RevenuePeriod.weekly:
        return now.subtract(const Duration(days: 30));
      case RevenuePeriod.monthly:
        return now.subtract(const Duration(days: 365));
    }
  }

  // Removed _computeInIsolate
  // Removed _isolateEntry
}

// Removed _IsolateMessage