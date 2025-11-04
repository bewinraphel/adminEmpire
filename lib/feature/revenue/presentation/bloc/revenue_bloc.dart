 

import 'dart:async';

import 'package:empire/feature/revenue/domain/entity/revenue_entity.dart';
import 'package:empire/feature/revenue/domain/repository/revenue_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class RevenueEvent extends Equatable {
  const RevenueEvent();

  @override
  List<Object?> get props => [];
}

class RevenuePeriodChanged extends RevenueEvent {
  final RevenuePeriod period;

  const RevenuePeriodChanged(this.period);

  @override
  List<Object?> get props => [period];
}

class RevenueDataRequested extends RevenueEvent {
  const RevenueDataRequested();
}

class RevenueRealTimeToggled extends RevenueEvent {
  final bool enabled;

  const RevenueRealTimeToggled(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class RevenueDataUpdated extends RevenueEvent {
  final List<RevenueData> data;

  const RevenueDataUpdated(this.data);

  @override
  List<Object?> get props => [data];
}

class RevenueSummaryUpdated extends RevenueEvent {
  final RevenueSummary summary;

  const RevenueSummaryUpdated(this.summary);

  @override
  List<Object?> get props => [summary];
}
 

class RevenueState extends Equatable {
  final RevenuePeriod period;
  final List<RevenueData> revenueData;
  final RevenueSummary? summary;
  final bool isLoading;
  final bool isRealTime;
  final String? error;

  const RevenueState({
    this.period = RevenuePeriod.weekly,
    this.revenueData = const [],
    this.summary,
    this.isLoading = false,
    this.isRealTime = true,
    this.error,
  });

  RevenueState copyWith({
    RevenuePeriod? period,
    List<RevenueData>? revenueData,
    RevenueSummary? summary,
    bool? isLoading,
    bool? isRealTime,
    String? error,
  }) {
    return RevenueState(
      period: period ?? this.period,
      revenueData: revenueData ?? this.revenueData,
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      isRealTime: isRealTime ?? this.isRealTime,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        period,
        revenueData,
        summary,
        isLoading,
        isRealTime,
        error,
      ];
}
 

class RevenueBloc extends Bloc<RevenueEvent, RevenueState> {
  final RevenueRepository repository;
  final Map<RevenuePeriod, StreamSubscription<List<RevenueData>>> _dataSubscriptions = {};
  final Map<RevenuePeriod, StreamSubscription<RevenueSummary>> _summarySubscriptions = {};

  RevenueBloc({required this.repository}) : super(const RevenueState()) {
    on<RevenuePeriodChanged>(_onPeriodChanged);
    on<RevenueDataRequested>(_onDataRequested);
    on<RevenueRealTimeToggled>(_onRealTimeToggled);
    on<RevenueDataUpdated>(_onDataUpdated);
    on<RevenueSummaryUpdated>(_onSummaryUpdated);
  }

  Future<void> _onPeriodChanged(
    RevenuePeriodChanged event,
    Emitter<RevenueState> emit,
  ) async {
    _stopRealtimeUpdates(state.period);
    
    emit(state.copyWith(period: event.period, isLoading: true));
    
    if (state.isRealTime) {
      _startRealtimeUpdates(event.period);
    } else {
      await _loadRevenueData(emit);
    }
  }

  Future<void> _onDataRequested(
    RevenueDataRequested event,
    Emitter<RevenueState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await _loadRevenueData(emit);
  }

  void _onRealTimeToggled(
    RevenueRealTimeToggled event,
    Emitter<RevenueState> emit,
  ) {
    if (event.enabled) {
      _startRealtimeUpdates(state.period);
    } else {
      _stopRealtimeUpdates(state.period);
    }
    
    emit(state.copyWith(isRealTime: event.enabled));
  }

  void _onDataUpdated(
    RevenueDataUpdated event,
    Emitter<RevenueState> emit,
  ) {
    emit(state.copyWith(
      revenueData: event.data,
      isLoading: false,
      error: null,
    ));
  }

  void _onSummaryUpdated(
    RevenueSummaryUpdated event,
    Emitter<RevenueState> emit,
  ) {
    emit(state.copyWith(
      summary: event.summary,
      isLoading: false,
      error: null,
    ));
  }

  void _startRealtimeUpdates(RevenuePeriod period) {
    if (_dataSubscriptions.containsKey(period)) return;

    // Listen to data stream
    _dataSubscriptions[period] = repository.getRevenueDataStream(period).listen(
      (data) {
        add(RevenueDataUpdated(data));
      },
      onError: (error) {
        add(RevenueDataUpdated([]));
      },
    );
 
    _summarySubscriptions[period] = repository.getRevenueSummaryStream(period).listen(
      (summary) {
        add(RevenueSummaryUpdated(summary));
      },
      onError: (error) {
 
      },
    );

    repository.startRealtimeUpdates(period);
  }

  void _stopRealtimeUpdates(RevenuePeriod period) {
    _dataSubscriptions[period]?.cancel();
    _summarySubscriptions[period]?.cancel();
    _dataSubscriptions.remove(period);
    _summarySubscriptions.remove(period);
    repository.stopRealtimeUpdates(period);
  }

  Future<void> _loadRevenueData(Emitter<RevenueState> emit) async {
    try {
      final revenueData = await repository.getRevenueData(state.period);
      final summary = await repository.getRevenueSummary(state.period);

      emit(state.copyWith(
        revenueData: revenueData,
        summary: summary,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load revenue data: $e',
      ));
    }
  }

  @override
  Future<void> close() {
    for (final subscription in _dataSubscriptions.values) {
      subscription.cancel();
    }
    for (final subscription in _summarySubscriptions.values) {
      subscription.cancel();
    }
    _dataSubscriptions.clear();
    _summarySubscriptions.clear();
    repository.dispose();
    return super.close();
  }
}