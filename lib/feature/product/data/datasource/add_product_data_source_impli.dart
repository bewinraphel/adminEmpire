import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/core/utilis/widgets.dart';

import 'package:empire/feature/product/data/datasource/add_product_data_source.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
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
    List<Map<String, dynamic>> uploadedVariantDetails = [];
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
    for (var variant in product.variantDetails) {
      String? uploadedVariantImageUrl;
      if (variant.image != null) {
        try {
          final file = File(variant.image!);
          uploadedVariantImageUrl = await uploadImageToCloudinary(file);
          if (uploadedVariantImageUrl == null ||
              uploadedVariantImageUrl.isEmpty) {
            logger.e('Failed to upload variant image for ${variant.name}');
            return Left(
              Exception('Failed to upload variant image for ${variant.name}'),
            );
          }
          logger.i(
            'Variant image uploaded for ${variant.name}: $uploadedVariantImageUrl',
          );
        } catch (e) {
          logger.e('Variant image upload failed for ${variant.name}: $e');
          return Left(Exception('Failed to upload variant image: $e'));
        }
      }

      uploadedVariantDetails.add({
        'name': variant.name,
        'image': uploadedVariantImageUrl,
        'weight': variant.regularPrice,
        'price': variant.salePrice,
        'quantity': variant.quantity,
      });
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
            'category': product.category,
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
            'quantities': product.quantities,
            'images': uploadedImageUrls,
            'priceRangeMin': product.priceRangeMin,
            'priceRangeMax': product.priceRangeMax,
            'filterTags': product.filterTags,
            'timestamp': FieldValue.serverTimestamp(),
            'variantDetails': uploadedVariantDetails,
          });
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to add product: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> deleteProduct(
    String mainCategoryId,
    String subcategoryId,
    String productId,
  ) async {
    try {
      await _firestore
          .collection('category')
          .doc(mainCategoryId)
          .collection('subcategory')
          .doc(subcategoryId)
          .collection('product')
          .doc(productId)
          .delete();
      logger.i('Product deleted successfully: $productId');
      return const Right(null);
    } catch (e) {
      logger.e('Failed to delete product: $e');
      return Left(Exception('Failed to delete product: $e'));
    }
  }

  @override
  Future<Either<Failures, void>> updateProduct({
    required ProductEntity product,
    required String subcategoryId,
    required String productId,
    required String mainCategoryId,
  }) async {
    try {
  

      await FirebaseFirestore.instance
          .collection('category')
          .doc(mainCategoryId)
          .collection('subcategory')
          .doc(subcategoryId)
          .collection('product')
          .doc(productId)
          .update(product.toJson());
      return const Right(null);
    } catch (e) {
      logger.e('Failed to delete product: $e');
      return Left(Failures.server('Failed to update product: $e'));
    }
  }
}
