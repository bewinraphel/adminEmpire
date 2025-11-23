import 'package:empire/feature/auth/domain/usecase/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_gallery_usecase.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProductImageEvent extends Equatable {
  const ProductImageEvent();
  @override
  List<Object?> get props => [];
}

class PickFromCameraEvent extends ProductImageEvent {}

class PickFromGalleryEvent extends ProductImageEvent {}

class AddImageEvent extends ProductImageEvent {
  final dynamic path;
  const AddImageEvent(this.path);
  @override
  List<Object?> get props => [path];
}

class SetTargetVariantIndexEvent extends ProductImageEvent {
  final int index;
  const SetTargetVariantIndexEvent(this.index);
}

class ClearTargetVariantIndexEvent extends ProductImageEvent {}

class RemoveImageEvent extends ProductImageEvent {
  final int index;
  const RemoveImageEvent(this.index);
  @override
  List<Object?> get props => [index];
}

class ClearAllImagesEvent extends ProductImageEvent {}

abstract class ProductImageState extends Equatable {
  const ProductImageState();

  List<dynamic> get selectedImages => const [];

  @override
  List<Object?> get props => [];
}

class ProductImageInitial extends ProductImageState {
  const ProductImageInitial();

  @override
  List<dynamic> get selectedImages => const [];
}

class ProductImageLoading extends ProductImageState {
  const ProductImageLoading();
}

class ProductImagePicked extends ProductImageState {
  final List<dynamic> images;
  final int ?targetVariantIndex;

  const ProductImagePicked({required this.images,this.targetVariantIndex});

  @override
  List<dynamic> get selectedImages => images;

  @override
  List<Object?> get props => [images,targetVariantIndex];
}

class ProductImageError extends ProductImageState {
  final String message;
  const ProductImageError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductImageBloc extends Bloc<ProductImageEvent, ProductImageState> {
  final PickImageFromCameraUsecase pickFromCamera;
  final PickImageFromGalleryusecase pickFromGallery;

  ProductImageBloc({
    required this.pickFromCamera,
    required this.pickFromGallery,
  }) : super(const ProductImageInitial()) {
    on<PickFromCameraEvent>(_onPickFromCamera);
    on<PickFromGalleryEvent>(_onPickFromGallery);
    on<AddImageEvent>(_onAddImage);
    on<RemoveImageEvent>(_onRemoveImage);
    on<ClearAllImagesEvent>(_onClearAll);
  }

  Future<void> _onPickFromCamera(
    PickFromCameraEvent event,
    Emitter<ProductImageState> emit,
  ) async {
    final imagesBeforeLoading = state.selectedImages;

    emit(const ProductImageLoading());

    final result = await pickFromCamera();

    if (result != null) {
      emit(ProductImagePicked(images: [...imagesBeforeLoading, result]));
    } else {
      emit(ProductImagePicked(images: imagesBeforeLoading));
    }
  }

  Future<void> _onPickFromGallery(
    PickFromGalleryEvent event,
    Emitter<ProductImageState> emit,
  ) async {
    final imagesBeforeLoading = state.selectedImages;

    emit(const ProductImageLoading());

    final result = await pickFromGallery();

    if (result != null) {
      emit(ProductImagePicked(images: [...imagesBeforeLoading, result]));
    } else {
      emit(ProductImagePicked(images: imagesBeforeLoading));
    }
  }

  void _onAddImage(AddImageEvent event, Emitter<ProductImageState> emit) {
    final currentImages = state.selectedImages;
    final updatedImages = List<dynamic>.from(currentImages)..add(event.path);
    emit(ProductImagePicked(images: updatedImages));
  }

  void _onRemoveImage(RemoveImageEvent event, Emitter<ProductImageState> emit) {
    final current = state;
    if (current is! ProductImagePicked || current.images.isEmpty) return;

    final updated = List<String>.from(current.images)..removeAt(event.index);
    emit(ProductImagePicked(images: updated));
  }

  void _onClearAll(ClearAllImagesEvent event, Emitter<ProductImageState> emit) {
    emit(const ProductImageInitial());
  }
}
