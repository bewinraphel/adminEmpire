import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/category/domain/entities/category_entities.dart';

abstract class CategoryDataSource {
  Future<Either<Failures, Unit>> addCategory(
    String category,
    String ?imageUrl,
    String description,
    Uint8List? imageBytes 
  );
  Future<Either<List<CategoryEntities>, Failures>> getCategory();
  Future<Either<Failures, Unit>> addingSubCategory(
    String id,
    String category,
    String ?imageUrl,
    String description,
      Uint8List? imageBytes 

  );
  Future<Either<Failures, List<CategoryEntities>>> getSubCategory(String id);
}
