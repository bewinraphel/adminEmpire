import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/domain/repository/product_repository.dart';

class GetBrandsUseCase {
  final ProductRepository repository;

  GetBrandsUseCase(this.repository);

  Future<Either<Failures, List<Brand>>> call(String mainCategoryId, String subCategoryId) async {
    return await repository.getBrands(mainCategoryId, subCategoryId);
  }
}