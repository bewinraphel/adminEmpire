import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/feature/product/presentation/views/add_product.dart/add_product.dart';

abstract class ProductsDataSource {
  Future<Either<Failures, List<ProductEntity>>> gettingProduct(
    String mainCategoryId,
    String subcategoryId,
  );
}

class ProducsDataSourceimpli extends ProductsDataSource {
  @override
  Future<Either<Failures, List<ProductEntity>>> gettingProduct(
    String mainCategoryId,
    String subcategoryId,
  ) async {
    try {
      final snapShot = await FirebaseFirestore.instance
          .collection('category')
          .doc(mainCategoryId)
          .collection('subcategory')
          .doc(subcategoryId)
          .collection('product')
          .get();
      List<ProductEntity> category = snapShot.docs.map((data) {
        return ProductEntity(
          productDocId: data.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          price: (data['price'] as num?)?.toDouble() ?? 0.0,
          discountPrice: (data['discountPrice'] as num?)?.toDouble() ?? 0.0,
          sku: data['sku'] ?? '',
          tags: List<String>.from(data['tags'] ?? []),
          inStock: data['inStock'] ?? false,
          weight: (data['weight'] as num?)?.toDouble() ?? 0.0,
          length: (data['length'] as num?)?.toDouble() ?? 0.0,
          width: (data['width'] as num?)?.toDouble() ?? 0.0,
          height: (data['height'] as num?)?.toDouble() ?? 0.0,
          taxRate: (data['taxRate'] as num?)?.toDouble() ?? 0.0,

          category: data['category'] ?? '',
          quantities: data['quantities'] ?? 0,
          images: List<String>.from(data['images'] ?? []),
          priceRangeMin: (data['priceRangeMin'] as num?)?.toDouble() ?? 0.0,
          priceRangeMax: (data['priceRangeMax'] as num?)?.toDouble() ?? 0.0,
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

      return right(category);
    } catch (e) {
      return left(Failures.server(e.toString()));
    }
  }
}
