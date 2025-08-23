import 'package:dartz/dartz.dart';
import 'package:empire/feature/product/domain/entities/product_entities.dart';

abstract class ProductDataSource {
  Future<Either<Exception, void>> addProduct(ProductEntity product,String uid,String mainCtiegoryid);
}