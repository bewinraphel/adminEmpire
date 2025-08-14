import 'package:dartz/dartz.dart';
import 'package:empire/data/datasource/category_data_source.dart';
import 'package:empire/domain/entities/category_entities.dart';

import 'package:empire/domain/failures/category_failures.dart';
import 'package:empire/domain/repositories/category_repository.dart';

class CategoryRepositoryImpli implements CategoryRepository {
  final CategoryDataSource categoryDataSource;
  CategoryRepositoryImpli(this.categoryDataSource);

  @override
  Future<Either<CategoryFailure, Unit>> addingSubCategory(
    String id,
    String category,
    String imageUrl,
    String description,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Either<List<CategoryEntities>,CategoryFailure>>  getCategory() {
    return categoryDataSource.getCategory();
  }

  @override
  Future<Either<CategoryFailure, Unit>> addingCategory(
    String category,
    String imageUrl,
    String description,
  ) async {
    return await categoryDataSource.addCategory(
      category,
      imageUrl,
      description,
    );
  }
}
