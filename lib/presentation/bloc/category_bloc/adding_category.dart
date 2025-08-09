import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:empire/domain/usecase/addingcategory.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class AddingCategory extends CategoryEvent {
  final String category;
  final String image;
  final String description;

  const AddingCategory({
    required this.category,
    required this.image,
    required this.description,
  });

  @override
  List<Object?> get props => [category, image, description];
}

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryAddinginintal extends CategoryState {}

class CategoryAddingloading extends CategoryState {}

class CategoryAddedSuceess extends CategoryState {}

class ErrorCategory extends CategoryState {
  String messange;
  ErrorCategory(this.messange);
  @override
  List<Object?> get props => [messange];
}

class AddingcategoryEventBloc extends Bloc<CategoryEvent, CategoryState> {
  final AddingcategoryUseCase addingcategoryUseCase;
  AddingcategoryEventBloc(this.addingcategoryUseCase)
    : super(CategoryAddinginintal()) {
    on<AddingCategory>((event, emit) async {
      emit(CategoryAddingloading());
      final result = await addingcategoryUseCase(
        event.category,
        event.image,
        event.description,
      );

      result.fold(
        (failure) => emit(ErrorCategory(failure.message)),
        (_) => emit(CategoryAddedSuceess()),
      );
    }, transformer: droppable());
  }
}
