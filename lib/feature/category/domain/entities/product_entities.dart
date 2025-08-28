 import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final String sku;
  final List<String> tags;
  final bool inStock;
  final double weight;
  final double length;
  final double width;
  final double height;
  final double taxRate;
  final double rating;
  final String category;
  final List<String?> variants;
  final Map<String, int> quantities;
  final List<String> images;
  final double priceRangeMin;
  final double priceRangeMax;
  final List<String> filterTags;
  final DateTime? timestamp;

  const ProductEntity({
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.sku,
    required this.tags,
    required this.inStock,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    required this.taxRate,
    required this.rating,
    required this.category,
    required this.variants,
    required this.quantities,
    required this.images,
    required this.priceRangeMin,
    required this.priceRangeMax,
    required this.filterTags,
    required this.timestamp,
  });
 ProductEntity copyWith({
    String? name,
    String? description,
    double? price,
    double? discountPrice,
    String? sku,
    List<String>? tags,
    bool? inStock,
    double? weight,
    double? length,
    double? width,
    double? height,
    double? taxRate,
    double? rating,
    String? category,
    List<String>? variants,
    Map<String, int>? quantities,
    List<String>? images,
    double? priceRangeMin,
    double? priceRangeMax,
    List<String>? filterTags,
    DateTime? timestamp,
  }) {
    return ProductEntity(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      sku: sku ?? this.sku,
      tags: tags ?? this.tags,
      inStock: inStock ?? this.inStock,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      taxRate: taxRate ?? this.taxRate,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      variants: variants ?? this.variants,
      quantities: quantities ?? this.quantities,
      images: images ?? this.images,
      priceRangeMin: priceRangeMin ?? this.priceRangeMin,
      priceRangeMax: priceRangeMax ?? this.priceRangeMax,
      filterTags: filterTags ?? this.filterTags,
      timestamp: timestamp ?? this.timestamp,
    );
  }
  @override
  List<Object?> get props => [
    name,
    description,
    price,
    discountPrice,
    sku,
    tags,
    inStock,
    weight,
    length,
    width,
    height,
    taxRate,
    rating,
    category,
    variants,
    quantities,
    images,
    priceRangeMin,
    priceRangeMax,
    filterTags,
    timestamp,
  ];
}