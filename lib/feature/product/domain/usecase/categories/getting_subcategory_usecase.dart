import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/entities/category_entities.dart';

import 'package:empire/feature/product/domain/repositories/category_repository.dart';

class GettingSubcategoryUsecase {
  final CategoryRepository categoryRepository;
  GettingSubcategoryUsecase(this.categoryRepository);
  Future<Either<CategoryFailure, List<CategoryEntities>>>call(String id) {
    return categoryRepository.getSubCategory(id);
  }
}
