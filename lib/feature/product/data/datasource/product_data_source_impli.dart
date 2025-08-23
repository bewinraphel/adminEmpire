import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:empire/feature/product/data/datasource/product_data_source.dart';
import 'package:empire/feature/product/domain/entities/product_entities.dart';

class ProductDataSourceImpli extends ProductDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Exception, void>> addProduct(
    ProductEntity product,
    String uid,
    String mainCtiegoryid,
  ) async {
    try {
      await _firestore
          .collection('category') 
          .doc(mainCtiegoryid)
          .collection('subcategory')
          .doc(uid)
          .collection('product')
          .doc()
          .set({
            'name': product.name,
            'description': product.description,
            'price': product.price,
            'discountPrice': product.discountPrice,
            'sku': product.sku,
            'tags': product.tags,
            'inStock': product.inStock,
            'weight': product.weight,
            'length': product.length,
            'width': product.width,
            'height': product.height,
            'taxRate': product.taxRate,
            'rating': product.rating,
            'category': product.category,
            'variants': product.variants,
            'quantities': product.quantities,
            'images': product.images,
            'priceRangeMin': product.priceRangeMin,
            'priceRangeMax': product.priceRangeMax,
            'filterTags': product.filterTags,
            'timestamp': FieldValue.serverTimestamp(),
          });
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to add product: $e'));
    }
  }
}
