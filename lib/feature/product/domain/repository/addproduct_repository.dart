import 'package:dartz/dartz.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
 

abstract class ProductRepository {
  Future<Either<Exception, void>> addProduct(ProductEntity product,String uid,String mainCtiegoryid);
    Future<Either<Exception, void>> deleteProduct(
    String mainCategoryId,
    String subcategoryId,
    String productId,
  );
}