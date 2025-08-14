import 'package:dartz/dartz.dart';
import 'package:empire/domain/entities/category_entities.dart';
import 'package:empire/domain/failures/category_failures.dart';
import 'package:empire/domain/repositories/category_repository.dart';

class CategoryUsecase {
  final CategoryRepository categoryRepository;
  CategoryUsecase(this.categoryRepository);
  Future<Either<List<CategoryEntities>,CategoryFailure>> call() {
    return  categoryRepository.getCategory();
  }
}
