
import 'package:dartz/dartz.dart';
import 'package:empire/feature/product/data/datasource/product_data_source.dart';

import 'package:empire/feature/product/domain/entities/product_entities.dart';
import 'package:empire/feature/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource dataSource;

  ProductRepositoryImpl(this.dataSource);

  @override
  Future<Either<Exception, void>> addProduct(ProductEntity product,String uid,String mainCtiegoryid) async {
    return await dataSource.addProduct(product,uid,mainCtiegoryid );
  }
}