import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';

import 'package:empire/feature/category/domain/repositories/category_repository.dart';

class AddingcategoryUseCase {
  final CategoryRepository categoryRepository;
  AddingcategoryUseCase(this.categoryRepository);
  Future<Either<Failures, Unit>> call(
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
      return Left(Failures.server(e.toString()));
    }
  }
}
