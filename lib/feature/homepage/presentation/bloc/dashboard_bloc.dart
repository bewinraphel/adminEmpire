 
import 'package:empire/feature/homepage/domain/entities/Dashboardentities.dart';
import 'package:empire/feature/homepage/domain/usecase/get_dashboard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DashboardEvent {}

class LoadDashboardEvent extends DashboardEvent {
  final String dateRange;
  LoadDashboardEvent(this.dateRange);
}

class RefreshDashboardEvent extends DashboardEvent {}
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardEntity dashboard;
  DashboardLoaded(this.dashboard);
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardData getDashboardData;

  DashboardBloc(this.getDashboardData) : super(DashboardInitial()) {
    on<LoadDashboardEvent>((event, emit) async {
      emit(DashboardLoading());
      try {
        // final dashboard = await getDashboardData(event.dateRange);
        // emit(DashboardLoaded(dashboard));
      } catch (e) {
        emit(DashboardError("Failed to load dashboard"));
      }
    });

    on<RefreshDashboardEvent>((event, emit) async {
      if (state is DashboardLoaded) {
        final currentRange = (state as DashboardLoaded).dashboard.dateRange;
        add(LoadDashboardEvent(currentRange));
      }
    });
  }
}