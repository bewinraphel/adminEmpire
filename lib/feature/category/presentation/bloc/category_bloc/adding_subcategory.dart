import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:empire/feature/category/domain/usecase/categories/adding_subcategory_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SubcategoryEvent {}

class AddingSubcategory extends SubcategoryEvent {
  String id;
  String category;
  String imageUrl;
  String description;
  AddingSubcategory(this.category, this.description, this.id, this.imageUrl);
}

abstract class SubcategoryState {}

class SubcategoryInitial extends SubcategoryState {}

class AdddedSucess extends SubcategoryState {}

class ErroAdding extends SubcategoryState {
  String error;
  ErroAdding(this.error);
}

class SubcategoryBloc extends Bloc<SubcategoryEvent, SubcategoryState> {
  final AddingSubcategoryUsecase addingSubcategoryUseCase;

  SubcategoryBloc(this.addingSubcategoryUseCase) : super(SubcategoryInitial()) {
    on<AddingSubcategory>((event, emit) async {
      try {
        final result = await addingSubcategoryUseCase(
          event.id,
          event.category,
          event.imageUrl,
          event.description,
        );
        result.fold(
          (failure) => emit(ErroAdding(failure.message)),
          (_) => emit(AdddedSucess()),
        );
      } catch (e) {
        emit(ErroAdding(e.toString()));
      }
    }, transformer: droppable());
  }
}
