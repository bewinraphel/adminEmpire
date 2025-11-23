import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
 
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/domain/repository/product_repository.dart';
 

class ProductcallingUsecase {
  final ProductRepository prodcuctRepository;
  
  ProductcallingUsecase(this.prodcuctRepository);
  Future<Either<Failures, List<ProductEntity>>> call(
    String mainCategoryId,
    String subcategoryId,
    String? brand,
    String? subCategoryName,
  ) {
    return prodcuctRepository.fetchingProduct(
      mainCategoryId,
      subcategoryId,
      brand,
      subCategoryName,
    );
  }

  
}
