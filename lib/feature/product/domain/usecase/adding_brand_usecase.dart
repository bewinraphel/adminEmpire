import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/domain/repository/product_repository.dart';

class AddBrandUseCase {
  final ProductRepository repository;

  AddBrandUseCase(this.repository);

  Future<Either<Failures, void>> call(String mainCategoryId, String subCategoryId, Brand brand,  Uint8List? imageBytes ) async {
    return await repository.addBrand(mainCategoryId, subCategoryId, brand,);
  }
}   