import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/category/domain/entities/category_entities.dart';

abstract class CategoryRepository {
  Future<Either<List<CategoryEntities>, Failures>> getCategory();
  Future<Either<Failures, Unit>> addingSubCategory(
    String id,
    String category,
    String imageUrl,
    String description,
  );
  Future<Either<Failures, Unit>> addingCategory(
    String category,
    String imageUrl,
    String description,
  );

  Future<Either<Failures, List<CategoryEntities>>> getSubCategory(String id);
}
