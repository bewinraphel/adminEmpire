import 'package:equatable/equatable.dart';

abstract class VariantImageState extends Equatable {
  const VariantImageState();

  @override
  List<Object?> get props => [];
}

class VariantImageInitial extends VariantImageState {
  const VariantImageInitial();
}

class VariantImageLoading extends VariantImageState {
  final int variantIndex;

  const VariantImageLoading({required this.variantIndex});

  @override
  List<Object?> get props => [variantIndex];
}

class VariantImagesUpdated extends VariantImageState {
  final int variantIndex;
  final dynamic image;
  const VariantImagesUpdated(this.variantIndex, this.image);

  @override
  List<Object> get props => [variantIndex];
}

class VariantImageError extends VariantImageState {
  final String message;
  final int? variantIndex;
  final dynamic currentImages;

  const VariantImageError({
    required this.message,
    this.variantIndex,
    this.currentImages,
  });

  @override
  List<Object?> get props => [message, variantIndex, currentImages];
}
