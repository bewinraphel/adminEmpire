import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/entities/category_entities.dart';

import 'package:empire/feature/product/domain/repositories/category_repository.dart';

class CategoryUsecase {
  final CategoryRepository categoryRepository;
  CategoryUsecase(this.categoryRepository);
  Future<Either<List<CategoryEntities>,CategoryFailure>> call() {
    return  categoryRepository.getCategory();
  }
}
