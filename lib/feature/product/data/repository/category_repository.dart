import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/data/datasource/category_data_source.dart';
import 'package:empire/feature/product/domain/entities/category_entities.dart';

 
import 'package:empire/feature/product/domain/repositories/category_repository.dart';

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
    return categoryDataSource.addingSubCategory(
      id,
      category,
      imageUrl,
      description,
    );
  }

  @override
  Future<Either<List<CategoryEntities>, CategoryFailure>> getCategory() {
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

  @override
  Future<Either<CategoryFailure, List<CategoryEntities>>> getSubCategory(
    String id,
  ) async {
    return await categoryDataSource.getSubCategory(id);
  }
}
