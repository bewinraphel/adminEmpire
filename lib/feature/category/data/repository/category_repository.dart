import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/category/data/datasource/category_data_source.dart';
import 'package:empire/feature/category/domain/entities/category_entities.dart';

import 'package:empire/feature/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpli implements CategoryRepository {
  final CategoryDataSource categoryDataSource;
  CategoryRepositoryImpli(this.categoryDataSource);

  @override
  Future<Either<Failures, Unit>> addingSubCategory(
    String id,
    String category,
    String ?imageUrl,
    String description,
      Uint8List? imageBytes 
  ) {
    return categoryDataSource.addingSubCategory(
      id,
      category,
      imageUrl,
      description,
      imageBytes
    );
  }

  @override
  Future<Either<List<CategoryEntities>, Failures>> getCategory() {
    return categoryDataSource.getCategory();
  }

  @override
  Future<Either<Failures, Unit>> addingCategory(
    String category,
    String? imageUrl,
    String description,
      Uint8List? imageBytes 
  ) async {
    return await categoryDataSource.addCategory(
      category,
      imageUrl,
      description,
      imageBytes
      
    );
  }

  @override
  Future<Either<Failures, List<CategoryEntities>>> getSubCategory(
    String id,
  ) async {
    return await categoryDataSource.getSubCategory(id);
  }
}
