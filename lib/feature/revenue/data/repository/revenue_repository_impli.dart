 
import 'dart:async';

import 'package:empire/feature/revenue/data/datasource/revenue_datasource.dart';
import 'package:empire/feature/revenue/domain/entity/revenue_entity.dart';
import 'package:empire/feature/revenue/domain/repository/revenue_repo.dart';

class RevenueRepositoryImpl implements RevenueRepository {
  final RevenueRemoteDataSource remoteDataSource;
  final _cache = <RevenuePeriod, _CachedData>{};
  final _streamSubscriptions = <RevenuePeriod, StreamSubscription<List<RevenueData>>>{};
  final _summarySubscriptions = <RevenuePeriod, StreamSubscription<RevenueSummary>>{};

  RevenueRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<RevenueData>> getRevenueData(RevenuePeriod period) async {
    if (_cache.containsKey(period) && !_cache[period]!.isExpired) {
      return _cache[period]!.data;
    }

    final data = await remoteDataSource.getRevenueData(period);
    _cache[period] = _CachedData(data: data, timestamp: DateTime.now());
    return data;
  }

  @override
  Future<RevenueSummary> getRevenueSummary(RevenuePeriod period) async {
    return await remoteDataSource.getRevenueSummary(period);
  }

  @override
  Stream<List<RevenueData>> getRevenueDataStream(RevenuePeriod period) {
    return remoteDataSource.getRevenueDataStream(period)
      .asBroadcastStream()
      .doOnData((data) {
        _cache[period] = _CachedData(data: data, timestamp: DateTime.now());
      });
  }

  @override
  Stream<RevenueSummary> getRevenueSummaryStream(RevenuePeriod period) {
    return remoteDataSource.getRevenueSummaryStream(period)
      .asBroadcastStream();
  }

  @override
  void startRealtimeUpdates(RevenuePeriod period) {
    if (_streamSubscriptions.containsKey(period)) return;

    _streamSubscriptions[period] = getRevenueDataStream(period).listen((_) {});
    _summarySubscriptions[period] = getRevenueSummaryStream(period).listen((_) {});
  }

  @override
  void stopRealtimeUpdates(RevenuePeriod period) {
    _streamSubscriptions[period]?.cancel();
    _summarySubscriptions[period]?.cancel();
    _streamSubscriptions.remove(period);
    _summarySubscriptions.remove(period);
  }

  void clearCache() {
    _cache.clear();
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions.values) {
      subscription.cancel();
    }
    for (final subscription in _summarySubscriptions.values) {
      subscription.cancel();
    }
    _streamSubscriptions.clear();
    _summarySubscriptions.clear();
    _cache.clear();
    // remoteDataSource.dispose();
  }
}

class _CachedData {
  final List<RevenueData> data;
  final DateTime timestamp;

  _CachedData({required this.data, required this.timestamp});

  bool get isExpired => DateTime.now().difference(timestamp).inMinutes > 5;
}

 extension StreamExtensions<T> on Stream<T> {
  Stream<T> doOnData(void Function(T data) onData) {
    return transform(StreamTransformer<T, T>.fromHandlers(
      handleData: (data, sink) {
        onData(data);
        sink.add(data);
      },
    ));
  }
}