import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/entities/category_entities.dart';


abstract class CategoryRepository {
  Future<Either<List<CategoryEntities>, CategoryFailure>> getCategory();
  Future<Either<CategoryFailure, Unit>> addingSubCategory(
    String id,
    String category,
    String imageUrl,
    String description,
  );
  Future<Either<CategoryFailure, Unit>> addingCategory(
    String category,
    String imageUrl,
    String description,
  );

  Future<Either<CategoryFailure, List<CategoryEntities>>> getSubCategory(String id);
}
