import 'package:dartz/dartz.dart';
import 'package:empire/domain/entities/category_entities.dart';
import 'package:empire/domain/failures/category_failures.dart';

abstract class CategoryRepository {
  Future<Either<List<CategoryEntities>,CategoryFailure>>  getCategory();
  Future<Either<CategoryFailure,Unit>> addingSubCategory(
      String id, String category, String imageUrl, String description);
  Future<Either<CategoryFailure,Unit>> addingCategory(
     String category, String imageUrl, String description);

}
