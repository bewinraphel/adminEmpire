import 'package:equatable/equatable.dart';

abstract class AddProductFormEvent extends Equatable {
  const AddProductFormEvent();

  @override
  List<Object?> get props => [];
}

class InitializeFormEvent extends AddProductFormEvent {
  const InitializeFormEvent();
}

class UpdateProductNameEvent extends AddProductFormEvent {
  final String productName;

  const UpdateProductNameEvent(this.productName);

  @override
  List<Object> get props => [productName];
}

class UpdateDescriptionEvent extends AddProductFormEvent {
  final String description;

  const UpdateDescriptionEvent(this.description);

  @override
  List<Object> get props => [description];
}

class UpdateTagsEvent extends AddProductFormEvent {
  final List<String> tags;

  const UpdateTagsEvent(this.tags);

  @override
  List<Object> get props => [tags];
}

class UpdateInStockEvent extends AddProductFormEvent {
  final bool inStock;

  const UpdateInStockEvent(this.inStock);

  @override
  List<Object> get props => [inStock];
}

class UpdateCategoryEvent extends AddProductFormEvent {
  final String category;

  const UpdateCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class UpdateDimensionsEvent extends AddProductFormEvent {
  final double? weight;
  final double? length;
  final double? width;
  final double? height;

  const UpdateDimensionsEvent({
    this.weight,
    this.length,
    this.width,
    this.height,
  });

  @override
  List<Object?> get props => [weight, length, width, height];
}

class AddVariantEvent extends AddProductFormEvent {
  final String variantName;

  const AddVariantEvent(this.variantName);

  @override
  List<Object> get props => [variantName];
}

class UpdateVariantImageEvent extends AddProductFormEvent {
  final int variantIndex;
  final dynamic imagePath;

  const UpdateVariantImageEvent(this.variantIndex, this.imagePath);

  @override
  List<Object> get props => [variantIndex, imagePath];
}

class UpdateVariantPriceEvent extends AddProductFormEvent {
  final int variantIndex;
  final double regularPrice;
  final double salePrice;

  const UpdateVariantPriceEvent({
    required this.variantIndex,
    required this.regularPrice,
    required this.salePrice,
  });

  @override
  List<Object> get props => [variantIndex, regularPrice, salePrice];
}

class UpdateVariantQuantityEvent extends AddProductFormEvent {
  final int variantIndex;
  final int quantity;

  const UpdateVariantQuantityEvent(this.variantIndex, this.quantity);

  @override
  List<Object> get props => [variantIndex, quantity];
}

class AddProductImagesEvent extends AddProductFormEvent {
  final List<dynamic> imagePaths;

  const AddProductImagesEvent(this.imagePaths);

  @override
  List<Object> get props => [imagePaths];
}
class AddVarientImagesEvent extends AddProductFormEvent {
  final List<dynamic> imagePaths;

  const AddVarientImagesEvent(this.imagePaths);

  @override
  List<Object> get props => [imagePaths];
}

class RemoveProductImageEvent extends AddProductFormEvent {
  final int imageIndex;

  const RemoveProductImageEvent(this.imageIndex);

  @override
  List<Object> get props => [imageIndex];
}
class RemovevarientProductImageEvent extends AddProductFormEvent {
  final int imageIndex;

  const RemovevarientProductImageEvent(this.imageIndex);

  @override
  List<Object> get props => [imageIndex];
}

class ValidateFormEvent extends AddProductFormEvent {
  const ValidateFormEvent();
}

class SubmitFormEvent extends AddProductFormEvent {
  final String mainCategoryId;
  final String subcategoryId;
  final String mainCategoryName;
  final String subcategoryName;
  final String? selectedBrandLabel;

  const SubmitFormEvent({
    required this.mainCategoryId,
    required this.subcategoryId,
    required this.mainCategoryName,
    required this.subcategoryName,
    required this.selectedBrandLabel,
  });

  @override
  List<Object?> get props => [
    mainCategoryId,
    subcategoryId,
    mainCategoryName,
    subcategoryName,
    selectedBrandLabel,
  ];
}
