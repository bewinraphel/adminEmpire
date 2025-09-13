import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/domain/repository/prodcuct_call_repository.dart';

class ProductcaliingUsecase {
  final ProdcuctsRepository prodcuctRepository;
  ProductcaliingUsecase(this.prodcuctRepository);
    Future<Either< Failures,List<ProductEntity>>>  call(String mainCategoryId, String subcategoryId) {
    return prodcuctRepository.getProducts(mainCategoryId, subcategoryId);
  }
}
