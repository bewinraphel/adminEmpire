import 'package:empire/domain/repositories/category_repository.dart';
import 'package:empire/domain/usecase/addingcategory.dart';
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
  final AddingcategoryUseCase addingcategoryUseCase;
  final CategoryRepository categoryRepository;
  SubcategoryBloc(this.addingcategoryUseCase, this.categoryRepository)
      : super(SubcategoryInitial()) {
    on<AddingSubcategory>((event, emit) async {
      try {
     
        emit(AdddedSucess());
      } catch (e) {
        emit(ErroAdding(e.toString()));
      }
    });
  }
}
