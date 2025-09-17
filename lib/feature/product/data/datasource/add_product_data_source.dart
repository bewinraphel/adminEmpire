import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';

abstract class ProductDataSource {
  Future<Either<Exception, void>> addProduct(ProductEntity product,String uid,String mainCtiegoryid);
    Future<Either<Exception, void>> deleteProduct(
    String mainCategoryId,
    String subcategoryId,
    String productId,
  );
    Future<Either<Failures, void>> updateProduct({
        required String productId,
    required ProductEntity product,
    required String subcategoryId,
    required String mainCategoryId,
  });
}