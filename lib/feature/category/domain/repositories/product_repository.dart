import 'package:dartz/dartz.dart';
import 'package:empire/feature/category/domain/entities/product_entities.dart';
 

abstract class ProductRepository {
  Future<Either<Exception, void>> addProduct(ProductEntity product,String uid,String mainCtiegoryid);
}