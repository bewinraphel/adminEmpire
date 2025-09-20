import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/data/datasource/add_product_data_source.dart';
import 'package:empire/feature/product/domain/enities/listproducts.dart';

import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/domain/repository/product_repository.dart';

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

  @override
  Future<Either<Failures, void>> updateProduct({
    required ProductEntity product,
    required String subcategoryId,
    required String mainCategoryId,
    required String productId,
  }) async {
    return await dataSource.updateProduct(
      productId: productId,
      product: product,
      subcategoryId: subcategoryId,
      mainCategoryId: mainCategoryId,
    );
  }

  @override
  Future<Either<Failures, void>> addingBrand(
    String mainCategory,
    String subCargeoy,
    Brand brand,
  ) {
    return dataSource.addingBrand(mainCategory, subCargeoy, brand);
  }
}
