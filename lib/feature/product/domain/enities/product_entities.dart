import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? productDocId;
  final String name;
  final String description;

  String sku;
  final List<String> tags;
  final bool inStock;
  final double weight;
  final double length;
  final double width;
  final double height;

  final String category;

  final List<dynamic> images;
  final List<Uint8List>? imagesweb;
  final String? brand;
  final List<String> filterTags;
  final List<Variant> variantDetails;
  final String mainCategoryId;
  final String subcategoryId;
  final String mainCategoryName;
  final String subcategoryName;
  ProductEntity({
    this.imagesweb,
    required this.mainCategoryId,
    required this.subcategoryId,
    required this.mainCategoryName,
    required this.subcategoryName,
    this.productDocId,
    required this.name,
    required this.description,

    this.sku = 'ski323',
    required this.tags,
    required this.inStock,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,

    required this.category,

    required this.images,

    required this.filterTags,

    required this.variantDetails,
    this.brand,
  });

  Map<String, dynamic> toJson() => {
    'mainCategoryId': mainCategoryId,
    'subcategoryId': subcategoryId,
    'mainCategoryName': mainCategoryName,
    'subcategoryName': subcategoryName,
    'name': name,
    'description': description,

    'sku': sku,
    'tags': tags,
    'inStock': inStock,
    'weight': weight,
    'length': length,
    'width': width,
    'height': height,

    'category': category,

    'images': images,

    'brand': brand,
    'filterTags': filterTags,
    'variantDetails': variantDetails.map((v) => v.toJson()).toList(),
    'productDocId': productDocId,
  };

  ProductEntity copyWith({
    String? mainCategoryId,
    String? subcategoryId,
    String? mainCategoryName,
    String? subcategoryName,
    String? productDocId,
    String? name,
    String? description,
    String? sku,
    List<String>? tags,
    bool? inStock,
    double? weight,
    double? length,
    double? width,
    double? height,
    String? category,
    List<String>? variants,
    int? quantities,
    List<dynamic>? images,

    double? priceRangeMin,
    double? priceRangeMax,
    List<String>? filterTags,
    String? timestamp,
    String? brand,
  }) {
    return ProductEntity(
      mainCategoryId: mainCategoryId ?? this.mainCategoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      mainCategoryName: mainCategoryName ?? this.subcategoryName,
      subcategoryName: subcategoryName ?? this.subcategoryName,
      productDocId: productDocId ?? this.productDocId,
      name: name ?? this.name,
      description: description ?? this.description,
      sku: sku ?? this.sku,
      tags: tags ?? this.tags,
      inStock: inStock ?? this.inStock,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      category: category ?? this.category,
      images: images ?? this.images,

      brand: brand ?? this.brand,
      filterTags: filterTags ?? this.filterTags,
      variantDetails: variantDetails,
    );
  }

  @override
  List<Object?> get props => [
    mainCategoryId,
    subcategoryId,
    mainCategoryName,
    subcategoryName,
    name,
    description,
    imagesweb,
    sku,
    tags,
    inStock,
    weight,
    length,
    width,
    height,
    category,
    images,
    brand,
    filterTags,
    variantDetails,
  ];
}

class Variant extends Equatable {
  final String name;
  final dynamic image;
  final Uint8List? imageweb;
  final double salePrice;
  final double regularPrice;
  final int quantity;

  const Variant({
    required this.name,
    this.image,
    this.imageweb,
    this.regularPrice = 0.0,
    this.salePrice = 0.0,
    this.quantity = 0,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image ?? imageweb,

    'regularPrice': regularPrice,
    'salePrice': salePrice,
    'quantity': quantity,
  };

  @override
  List<Object?> get props => [
    name,
    image,
    imageweb,
    regularPrice,
    salePrice,
    quantity,
  ];
}
