import 'package:dartz/dartz.dart';
import 'package:empire/feature/product/data/datasource/add_product_data_source.dart';

import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/domain/repository/addproduct_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource dataSource;

  ProductRepositoryImpl(this.dataSource);

  @override
  Future<Either<Exception, void>> addProduct(
    ProductEntity product,
    String uid,
    String mainCtiegoryid,
  ) async {
    return await dataSource.addProduct(product, uid, mainCtiegoryid);
  }

  @override
  Future<Either<Exception, void>> deleteProduct(
    String mainCategoryId,
    String subcategoryId,
    String productId,
  ) async {
    return await dataSource.deleteProduct(
      mainCategoryId,
      subcategoryId,
      productId,
    );
  }
}
