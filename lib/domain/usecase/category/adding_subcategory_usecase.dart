import 'package:dartz/dartz.dart';

import 'package:empire/domain/failures/category_failures.dart';
import 'package:empire/domain/repositories/category_repository.dart';

class AddingSubcategoryUsecase {
  final CategoryRepository categoryDataSource;
  AddingSubcategoryUsecase(this.categoryDataSource);
  Future<Either<CategoryFailure, Unit>> call(
    String id,
    String category,
    String imageUrl,
    String description,
  )async {
    try {
      return await categoryDataSource.addingSubCategory(
        id,
        category,
        imageUrl,
        description,
      );
    } catch (e) {
     return left(CategoryFailure.server(e.toString()));
    }
  }
}
