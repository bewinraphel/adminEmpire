import 'package:equatable/equatable.dart';

abstract class VariantImageEvent extends Equatable {
  const VariantImageEvent();

  @override
  List<Object?> get props => [];
}

class PickImageFromCameraForVariantEvent extends VariantImageEvent {
  final int variantIndex;

  const PickImageFromCameraForVariantEvent(this.variantIndex);

  @override
  List<Object> get props => [variantIndex];
}

class PickImageFromGalleryForVariantEvent extends VariantImageEvent {
  final int variantIndex;

  const PickImageFromGalleryForVariantEvent(this.variantIndex);

  @override
  List<Object> get props => [variantIndex];
}

class SetVariantImageEvent extends VariantImageEvent {
  final int variantIndex;
  final dynamic imageData;

  const SetVariantImageEvent({
    required this.variantIndex,
    required this.imageData,
  });

  @override
  List<Object> get props => [variantIndex, imageData];
}

class ClearVariantImageEvent extends VariantImageEvent {
  final int variantIndex;

  const ClearVariantImageEvent(this.variantIndex);

  @override
  List<Object> get props => [variantIndex];
}

class ClearAllVariantImagesEvent extends VariantImageEvent {
  const ClearAllVariantImagesEvent();
}

class InitializeVariantImagesEvent extends VariantImageEvent {
  final dynamic initialImages;

  const InitializeVariantImagesEvent(this.initialImages);

  @override
  List<Object> get props => [initialImages];
}
