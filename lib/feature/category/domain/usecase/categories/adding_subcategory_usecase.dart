import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';

import 'package:empire/feature/category/domain/repositories/category_repository.dart';

class AddingSubcategoryUsecase {
  final CategoryRepository categoryRepository;
  AddingSubcategoryUsecase(this.categoryRepository);
  Future<Either<Failures, Unit>> call(
    String id,
    String category,
    String imageUrl,
    String description,
  ) async {
    try {
      return await categoryRepository.addingSubCategory(
        id,
        category,
        imageUrl,
        description,
      );
    } catch (e) {
      return left(Failures.server(e.toString()));
    }
  }
}
