 
import 'dart:async';

import 'package:empire/feature/homepage/domain/entities/metric_entity.dart';
import 'package:empire/feature/homepage/domain/repository/metric_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MetricsEvent extends Equatable {
  const MetricsEvent();

  @override
  List<Object?> get props => [];
}

class MetricsDataRequested extends MetricsEvent {
  const MetricsDataRequested();
}

class MetricsRealTimeToggled extends MetricsEvent {
  final bool enabled;

  const MetricsRealTimeToggled(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class MetricsDataUpdated extends MetricsEvent {
  final List<MetricsData> data;

  const MetricsDataUpdated(this.data);

  @override
  List<Object?> get props => [data];
}

class MetricsSummaryUpdated extends MetricsEvent {
  final MetricsSummary summary;

  const MetricsSummaryUpdated(this.summary);

  @override
  List<Object?> get props => [summary];
}
 

class MetricsState extends Equatable {
  final List<MetricsData> metricsData;
  final MetricsSummary? summary;
  final bool isLoading;
  final bool isRealTime;
  final String? error;

  const MetricsState({
    this.metricsData = const [],
    this.summary,
    this.isLoading = false,
    this.isRealTime = true,
    this.error,
  });

  MetricsState copyWith({
    List<MetricsData>? metricsData,
    MetricsSummary? summary,
    bool? isLoading,
    bool? isRealTime,
    String? error,
  }) {
    return MetricsState(
      metricsData: metricsData ?? this.metricsData,
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      isRealTime: isRealTime ?? this.isRealTime,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        metricsData,
        summary,
        isLoading,
        isRealTime,
        error,
      ];
}
 
class MetricsBloc extends Bloc<MetricsEvent, MetricsState> {
  final MetricsRepository repository;
  StreamSubscription<List<MetricsData>>? _dataSubscription;
  StreamSubscription<MetricsSummary>? _summarySubscription;

  MetricsBloc({required this.repository}) : super(const MetricsState()) {
    on<MetricsDataRequested>(_onDataRequested);
    on<MetricsRealTimeToggled>(_onRealTimeToggled);
    on<MetricsDataUpdated>(_onDataUpdated);
    on<MetricsSummaryUpdated>(_onSummaryUpdated);
  }

  Future<void> _onDataRequested(
    MetricsDataRequested event,
    Emitter<MetricsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await _loadMetricsData(emit);
  }

  void _onRealTimeToggled(
    MetricsRealTimeToggled event,
    Emitter<MetricsState> emit,
  ) {
    if (event.enabled) {
      _startRealtimeUpdates();
    } else {
      _stopRealtimeUpdates();
    }
    
    emit(state.copyWith(isRealTime: event.enabled));
  }

  void _onDataUpdated(
    MetricsDataUpdated event,
    Emitter<MetricsState> emit,
  ) {
    emit(state.copyWith(
      metricsData: event.data,
      isLoading: false,
      error: null,
    ));
  }

  void _onSummaryUpdated(
    MetricsSummaryUpdated event,
    Emitter<MetricsState> emit,
  ) {
    emit(state.copyWith(
      summary: event.summary,
      isLoading: false,
      error: null,
    ));
  }

  void _startRealtimeUpdates() {
    if (_dataSubscription != null) return;

    _dataSubscription = repository.getMetricsDataStream().listen(
      (data) {
        add(MetricsDataUpdated(data));
      },
      onError: (error) {
        add(MetricsDataUpdated([]));
      },
    );

    _summarySubscription = repository.getMetricsSummaryStream().listen(
      (summary) {
        add(MetricsSummaryUpdated(summary));
      },
      onError: (error) {
        // Summary error is less critical
      },
    );

    repository.startRealtimeUpdates();
  }

  void _stopRealtimeUpdates() {
    _dataSubscription?.cancel();
    _summarySubscription?.cancel();
    _dataSubscription = null;
    _summarySubscription = null;
    repository.stopRealtimeUpdates();
  }

  Future<void> _loadMetricsData(Emitter<MetricsState> emit) async {
    try {
      final metricsData = await repository.getMetricsData();
      final summary = await repository.getMetricsSummary();

      emit(state.copyWith(
        metricsData: metricsData,
        summary: summary,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load metrics data: $e',
      ));
    }
  }

  @override
  Future<void> close() {
    _dataSubscription?.cancel();
    _summarySubscription?.cancel();
    repository.dispose();
    return super.close();
  }
}