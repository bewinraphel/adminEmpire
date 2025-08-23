import 'package:dartz/dartz.dart';
import 'package:empire/feature/product/domain/entities/product_entities.dart';
import 'package:empire/feature/product/domain/repositories/product_repository.dart';
 
class AddProduct {
  final ProductRepository repository;

  AddProduct(this.repository);

  Future<Either<Exception, void>> call(ProductEntity product,String uid,String mainCtiegoryid) async {
    return await repository.addProduct(product,uid,mainCtiegoryid);
  }
}