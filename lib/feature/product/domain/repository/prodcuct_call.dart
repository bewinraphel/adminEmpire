import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/category/domain/entities/product_entities.dart';

abstract class ProdcuctsRepository {
     Future<Either< Failures,List<ProductEntity>>>   getProducts(String mainCategoryId, String subcategoryId);
}
