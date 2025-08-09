import 'dart:async';
import 'package:empire/domain/entities/category_entities.dart';
import 'package:empire/domain/usecase/get_category_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CategoryEvent {}

class LoadCategoryEvent extends CategoryEvent {}

class SelectedCategoryEvent extends CategoryEvent {
  final String selectedId;
  SelectedCategoryEvent(this.selectedId);
}

class _UpdateCategoriesEvent extends CategoryEvent {
  final List<CategoryEntities> categories;
  _UpdateCategoriesEvent(this.categories);
}

abstract class CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategoryLoadedState extends CategoryState {
  final List<CategoryEntities> categories;
  final String? selectedCategoryId;

  CategoryLoadedState({required this.categories, this.selectedCategoryId});

  CategoryLoadedState copyWith({
    List<CategoryEntities>? categories,
    String? selectedCategoryId,
  }) {
    return CategoryLoadedState(
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}

class CategoryErrorState extends CategoryState {
  final String error;
  CategoryErrorState(this.error);
}

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryUsecase categoryUsecase;
  StreamSubscription<List<CategoryEntities>?>? _streamSubscription;

  CategoryBloc(this.categoryUsecase) : super(CategoryLoadingState()) {
    on<LoadCategoryEvent>((event, emit) async {
      emit(CategoryLoadingState());
      try {
        await _streamSubscription?.cancel();

        _streamSubscription = await categoryUsecase().listen(
          (categories) {
            if (categories != null) {
              add(_UpdateCategoriesEvent(categories));
            } else {
              emit(CategoryErrorState('No categories found'));
            }
          },
          onError: (error) {
            emit(CategoryErrorState(error.toString()));
          },
        );
      } catch (e) {
        emit(CategoryErrorState(e.toString()));
      }
    });

    on<_UpdateCategoriesEvent>((event, emit) {
      final currentState = state;
      emit(CategoryLoadedState(
        categories: event.categories,
        selectedCategoryId: currentState is CategoryLoadedState
            ? currentState.selectedCategoryId
            : null,
      ));
    });

    on<SelectedCategoryEvent>((event, emit) {
      if (state is CategoryLoadedState) {
        final currentState = state as CategoryLoadedState;
        emit(currentState.copyWith(selectedCategoryId: event.selectedId));
      }
    });

    add(LoadCategoryEvent());
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
