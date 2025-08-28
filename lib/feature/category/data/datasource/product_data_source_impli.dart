import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import 'package:empire/core/utilis/widgets.dart';
import 'package:empire/feature/category/data/datasource/product_data_source.dart';
import 'package:empire/feature/category/domain/entities/product_entities.dart';
import 'package:logger/logger.dart';

class ProductDataSourceImpli extends ProductDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var logger = Logger();
  @override
  Future<Either<Exception, void>> addProduct(
    ProductEntity product,
    String uid,
    String mainCtiegoryid,
  ) async {
    List<String> uploadedImageUrls = [];
    for (var i = 0; i < product.images.length; i++) {
      try {
        final file = File(product.images[i]);
        final image = await uploadImageToCloudinary(file);
        if (image == null || image.isEmpty) {
          return Left(Exception('failed  image'));
        }
        logger.i('Category image uploaded: $image');
        uploadedImageUrls.add(image);
      } catch (e) {
        logger.e('Category image upload failed: $e');
        return left(Exception('Category image fialed'));
      }
    }
 
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
            'images': uploadedImageUrls,
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
