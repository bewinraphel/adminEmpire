import 'package:empire/core/utilis/layout_constants.dart';
import 'package:empire/feature/product/domain/enities/form_validatioon.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:equatable/equatable.dart';

enum FormStatus { initial, validating, valid, invalid, submitting, success, error }

class AddProductFormState extends Equatable {
  final String productName;
  final String description;
  final List<String> tags;
  final bool inStock;
  final String category;
  final double weight;
  final double length;
  final double width;
  final double height;
  final List<Variant> variants;
  final List<dynamic> productImages;
  final FormValidationResult validationResult;
  final FormStatus status;
  final String? errorMessage;

  const AddProductFormState({
    this.productName = '',
    this.description = '',
    this.tags = const [],
    this.inStock = true,
    this.category = '',
    this.weight = 0.0,
    this.length = 0.0,
    this.width = 0.0,
    this.height = 0.0,
    this.variants = const [],
    this.productImages = const [],
    this.validationResult = const FormValidationResult(errors: {}, isValid: false),
    this.status = FormStatus.initial,
    this.errorMessage,
  });

  AddProductFormState copyWith({
    String? productName,
    String? description,
    List<String>? tags,
    bool? inStock,
    String? category,
    double? weight,
    double? length,
    double? width,
    double? height,
    List<Variant>? variants,
    List<dynamic>? productImages,
    FormValidationResult? validationResult,
    FormStatus? status,
    String? errorMessage,
  }) {
    return AddProductFormState(
      productName: productName ?? this.productName,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      inStock: inStock ?? this.inStock,
      category: category ?? this.category,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      variants: variants ?? this.variants,
      productImages: productImages ?? this.productImages,
      validationResult: validationResult ?? this.validationResult,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  bool get isValid => validationResult.isValid;
  bool get isSubmitting => status == FormStatus.submitting;
  bool get hasMinimumImages => productImages.length >= LayoutConstants.minimumProductImages;

  @override
  List<Object?> get props => [
        productName,
        description,
        tags,
        inStock,
        category,
        weight,
        length,
        width,
        height,
        variants,
        productImages,
        validationResult,
        status,
        errorMessage,
      ];
}