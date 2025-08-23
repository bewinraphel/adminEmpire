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
  final DateTime timestamp;

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