import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';

import 'package:empire/feature/product/domain/repositories/category_repository.dart';

class AddingcategoryUseCase {
  final CategoryRepository categoryRepository;
  AddingcategoryUseCase(this.categoryRepository);
  Future<Either<CategoryFailure, Unit>> call(
    String category,
    String imageUrl,
    String description,
  ) async {
    try {
      return await categoryRepository.addingCategory(
        category,
        imageUrl,
        description,
      );
    } catch (e) {
      return Left(CategoryFailure.server(e.toString()));
    }
  }
}
