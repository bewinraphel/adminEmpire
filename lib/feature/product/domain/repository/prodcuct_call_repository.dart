import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';

abstract class ProdcuctsRepository {
  Future<Either<Failures, List<ProductEntity>>> fetchingProduct(
    String mainCategoryId,
    String subcategoryId,
    String? brand,
        String? subCategoryName,
  );

  Future<Either<Failures, List<Brand>>> getProductBrand(
    String mainCategory,
    String subCategory,
  );
}
