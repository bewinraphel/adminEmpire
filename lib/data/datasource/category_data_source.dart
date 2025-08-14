import 'package:dartz/dartz.dart';
import 'package:empire/domain/entities/category_entities.dart';
import 'package:empire/domain/failures/category_failures.dart';

abstract class CategoryDataSource {
  Future<Either<CategoryFailure, Unit>> addCategory(
    String category,
    String imageUrl,
    String description,
  );
  Future<Either<List<CategoryEntities>,CategoryFailure>>  getCategory();
  Future<Either<CategoryFailure, Unit>> addingSubCategory(
     String id, String category, String imageUrl, String description
  );
}
