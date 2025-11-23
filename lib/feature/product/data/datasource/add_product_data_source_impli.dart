import 'dart:io';
 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/core/utilis/widgets.dart';

import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

abstract class ProductDataSource {
  Future<Either<Exception, void>> addProduct(
    ProductEntity product,
    String uid,
    String mainCtiegoryid,
  );
  Future<Either<Exception, void>> deleteProduct(
    String mainCategoryId,
    String subcategoryId,
    String productId,
  );
  Future<Either<Failures, void>> updateProduct({
    required String productId,
    required ProductEntity product,
    required String subcategoryId,
    required String mainCategoryId,
  });
  Future<Either<Failures, void>> addBrand(
    String mainCategory,
    String subCargeoy,
    Brand brand,
  
  );

  Future<Either<Failures, List<Brand>>> getBrands(
    String mainCategory,
    String subCategory,
  );
  Future<Either<Failures, List<ProductEntity>>> fetchingProduct(
    String mainCategoryId,
    String subcategoryId,
    String? brand,
    String? subCategoryName,
  );
}

class ProductDataSourceImpli extends ProductDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var logger = Logger();
  @override
  Future<Either<Exception, void>> addProduct(
    ProductEntity product,
    String uid,
    String mainCategoryId,
  ) async {
    List<String> uploadedImageUrls = [];
    List<Map<String, dynamic>> uploadedVariantDetails = [];

    // ----------------------------------------
    // UPLOAD MAIN IMAGES
    // ----------------------------------------
    for (var i = 0; i < product.images.length; i++) {
      try {
        String? imgUrl;

        if (kIsWeb) {
          final Uint8List imgBytes = product.imagesweb![i];
          imgUrl = await uploadImageToCloudinary(bytes: imgBytes);
        } else {
          // product.images[i] must be file path
          final file = File(product.images[i]);
          imgUrl = await uploadImageToCloudinary(file: file);
        }

        if (imgUrl == null || imgUrl.isEmpty) {
          return Left(Exception("Failed to upload image"));
        }

        uploadedImageUrls.add(imgUrl);
      } catch (e) {
        return Left(Exception("Image upload failed: $e"));
      }
    }

    for (var variant in product.variantDetails) {
      String? uploadedVariantImageUrl;

      if (variant.image != null) {
        try {
          if (kIsWeb) {
            uploadedVariantImageUrl = await uploadImageToCloudinary(
              bytes: variant.imageweb,
            );
          } else {
            final file = File(variant.image!);
            uploadedVariantImageUrl = await uploadImageToCloudinary(file: file);
          }
        } catch (e) {
          return Left(Exception("Variant image upload failed: $e"));
        }
      }

      uploadedVariantDetails.add({
        'name': variant.name,
        'image': uploadedVariantImageUrl,
        'regularPrice': variant.regularPrice,
        'salePrice': variant.salePrice,
        'quantity': variant.quantity,
      });
    }

   
    try {
      await _firestore.collection('products').doc().set({
        'mainCategoryId': product.mainCategoryId,
        'subcategoryId': product.subcategoryId,
        'mainCategoryName': product.mainCategoryName,
        'subcategoryName': product.subcategoryName,
        'category': product.category,
        'name': product.name,
        'description': product.description,
        'sku': product.sku,
        'tags': product.tags,
        'inStock': product.inStock,
        'weight': product.weight,
        'length': product.length,
        'width': product.width,
        'height': product.height,
      
        'images': uploadedImageUrls,
        'brand': product.brand,
        'filterTags': product.filterTags,
        'timestamp': FieldValue.serverTimestamp(),
        'variantDetails': uploadedVariantDetails,
      });

      return const Right(null);
    } catch (e) {
      return Left(Exception("Failed to add product: $e"));
    }
  }

  @override
  Future<Either<Exception, void>> deleteProduct(
    String mainCategoryId,
    String subcategoryId,
    String productId,
  ) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
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
          .collection('products')
          .doc(productId)
          .update(product.toJson());
      return const Right(null);
    } catch (e) {
      logger.e('Failed to delete product: $e');
      return Left(Failures.server('Failed to update product: $e'));
    }
  }

  @override
  Future<Either<Failures, void>> addBrand(
    String mainCategory,
    String subCargeoy,
    Brand brand,
   
  ) async {
    final String? image;
    try {
      
  
      //  WEB ------------------------
      if (kIsWeb) {
        if (brand.imageweburl == null) {
          return left(const Failures.validation('No  web image selected'));
        }

        try {
          image = await uploadImageToCloudinary(bytes: brand.imageweburl);
        } catch (e) {
          return left(Failures.network('Failed to upload image: $e'));
        }
        //  MOBILE / DESKTOP ----------
      } else {
        if (brand.imageUrl == null) {
          return left(const Failures.validation('No image selected'));
        }

        final file = File(brand.imageUrl!);

        if (!await file.exists()) {
          return left(const Failures.validation('Image file does not exist'));
        }

        try {
          image = await uploadImageToCloudinary(file: file);
        } catch (e) {
          return left(Failures.network('Failed to upload image: $e'));
        }
      }
      await _firestore
          .collection('category')
          .doc(mainCategory)
          .collection('subcategory')
          .doc(subCargeoy)
          .collection('Brand')
          .doc()
          .set(({'image': image, 'Brand': brand.label}));
      return right(null);
    } catch (e) {
      return Left(Failures.server('Failed to update product: $e'));
    }
  }

  @override
  Future<Either<Failures, List<ProductEntity>>> fetchingProduct(
    String mainCategoryId,
    String subcategoryId,
    String? brand,
    String? subCategoryName,
  ) async {
    try {
      final snapShot = await FirebaseFirestore.instance
          .collection('products')
          .get();
      List<ProductEntity> allproducts = snapShot.docs.map((data) {
        return ProductEntity(
          mainCategoryId: data['mainCategoryId'] ?? "",
          subcategoryId: data['subcategoryId'] ?? "",
          mainCategoryName: data['mainCategoryName'] ?? "",
          subcategoryName: data['subcategoryName'] ?? "",
          productDocId: data.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',

          sku: data['sku'] ?? '',
          tags: List<String>.from(data['tags'] ?? []),
          inStock: data['inStock'] ?? false,
          weight: (data['weight'] as num?)?.toDouble() ?? 0.0,
          length: (data['length'] as num?)?.toDouble() ?? 0.0,
          width: (data['width'] as num?)?.toDouble() ?? 0.0,
          height: (data['height'] as num?)?.toDouble() ?? 0.0,

          brand: data['brand'] ?? "No Brand",
          category: data['category'] ?? '',
         
          images: List<String>.from(data['images'] ?? []),

          filterTags: List<String>.from(data['filterTags'] ?? []),
          variantDetails: data['variantDetails']
              .map<Variant>(
                (v) => Variant(
                  name: v['name'] ?? "",
                  image: v['image'] ?? "",
                  regularPrice: (v['regularPrice'] as num?)?.toDouble() ?? 0.0,
                  salePrice: (v['salePrice'] as num?)?.toDouble() ?? 0.0,
                  quantity: v['quantity'] ?? 0,
                ),
              )
              .toList(),
        );
      }).toList();

      if (brand == null && subCategoryName != null) {
        /////////////filteredBysubcategory
        List<ProductEntity> filteredBysubcategory = allproducts;
        filteredBysubcategory = filteredBysubcategory
            .where((product) => product.subcategoryName == subCategoryName)
            .toList();
        return right(filteredBysubcategory);
      } else {
        List<ProductEntity> filteredByProduct = allproducts;
        filteredByProduct = filteredByProduct
            .where((product) => product.brand == brand)
            .toList();
        return right(filteredByProduct);
      }
    } catch (e) {
      return left(Failures.server(e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<Brand>>> getBrands(
    String mainCategory,
    String subCategory,
  ) async {
    try {
      final snapShot = await FirebaseFirestore.instance
          .collection('category')
          .doc(mainCategory)
          .collection('subcategory')
          .doc(subCategory)
          .collection('Brand')
          .get();
      List<Brand> result = snapShot.docs.map((data) {
        return Brand(imageUrl: data['image'], label: data['Brand']);
      }).toList();
      return right(result);
    } catch (e) {
      return left(Failures.server(e.toString()));
    }
  }
}
