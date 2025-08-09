

import 'package:dartz/dartz.dart';
import 'package:empire/domain/failures/category_failures.dart';


abstract class CategoryDataSource {
  Future<Either<CategoryFailure, Unit>> addCategory( 
    String category,
    String imageUrl,
    String description);
}