import 'package:empire/feature/auth/domain/usecase/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_gallery_usecase.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProductImageEvent extends Equatable {
  const ProductImageEvent();

  @override
  List<Object?> get props => [];
}

class PickFromCameraEvent extends ProductImageEvent {
  const PickFromCameraEvent();
}

class PickFromGalleryEvent extends ProductImageEvent {
  const PickFromGalleryEvent();
}

class AddImageEvent extends ProductImageEvent {
  final dynamic path;

  const AddImageEvent(this.path);

  @override
  List<Object?> get props => [path];
}

class SetTargetVariantIndexEvent extends ProductImageEvent {
  final int index;

  const SetTargetVariantIndexEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class ClearTargetVariantIndexEvent extends ProductImageEvent {
  const ClearTargetVariantIndexEvent();
}

class RemoveImageEvent extends ProductImageEvent {
  final int index;

  const RemoveImageEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class ClearAllImagesEvent extends ProductImageEvent {
  const ClearAllImagesEvent();
}

abstract class ProductImageState extends Equatable {
  const ProductImageState();

  List<dynamic> get selectedImages => const [];
  int? get targetVariantIndex => null;

  @override
  List<Object?> get props => [];
}

class ProductImageInitial extends ProductImageState {
  const ProductImageInitial();

  @override
  List<dynamic> get selectedImages => const [];

  @override
  int? get targetVariantIndex => null;
}

class ProductImageLoading extends ProductImageState {
  final List<dynamic> previousImages;
  final int? previousTargetIndex;

  const ProductImageLoading({
    this.previousImages = const [],
    this.previousTargetIndex,
  });

  @override
  List<dynamic> get selectedImages => previousImages;

  @override
  int? get targetVariantIndex => previousTargetIndex;

  @override
  List<Object?> get props => [previousImages, previousTargetIndex];
}

class ProductImagePicked extends ProductImageState {
  final List<dynamic> images;
  final int? _targetVariantIndex;

  const ProductImagePicked({required this.images, int? targetVariantIndex})
    : _targetVariantIndex = targetVariantIndex;

  @override
  List<dynamic> get selectedImages => images;

  @override
  int? get targetVariantIndex => _targetVariantIndex;

  @override
  List<Object?> get props => [images, _targetVariantIndex];

  ProductImagePicked copyWith({
    List<dynamic>? images,
    int? targetVariantIndex,
    bool clearTargetIndex = false,
  }) {
    return ProductImagePicked(
      images: images ?? this.images,
      targetVariantIndex: clearTargetIndex
          ? null
          : (targetVariantIndex ?? _targetVariantIndex),
    );
  }
}

class ProductImageError extends ProductImageState {
  final String message;
  final List<dynamic> previousImages;
  final int? previousTargetIndex;

  const ProductImageError(
    this.message, {
    this.previousImages = const [],
    this.previousTargetIndex,
  });

  @override
  List<dynamic> get selectedImages => previousImages;

  @override
  int? get targetVariantIndex => previousTargetIndex;

  @override
  List<Object?> get props => [message, previousImages, previousTargetIndex];
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
    on<SetTargetVariantIndexEvent>(_onSetTargetVariantIndex);
    on<ClearTargetVariantIndexEvent>(_onClearTargetVariantIndex);
  }

  // Handle picking from camera
  Future<void> _onPickFromCamera(
    PickFromCameraEvent event,
    Emitter<ProductImageState> emit,
  ) async {
    final imagesBeforeLoading = state.selectedImages;
    final targetIndex = state.targetVariantIndex;

    emit(
      ProductImageLoading(
        previousImages: imagesBeforeLoading,
        previousTargetIndex: targetIndex,
      ),
    );

    try {
      final result = await pickFromCamera();

      if (result != null) {
        emit(
          ProductImagePicked(
            images: [...imagesBeforeLoading, result],
            targetVariantIndex: targetIndex,
          ),
        );
      } else {
        emit(
          ProductImagePicked(
            images: imagesBeforeLoading,
            targetVariantIndex: targetIndex,
          ),
        );
      }
    } catch (e) {
      emit(
        ProductImageError(
          'Failed to pick image from camera: ${e.toString()}',
          previousImages: imagesBeforeLoading,
          previousTargetIndex: targetIndex,
        ),
      );
    }
  }

  Future<void> _onPickFromGallery(
    PickFromGalleryEvent event,
    Emitter<ProductImageState> emit,
  ) async {
    final imagesBeforeLoading = state.selectedImages;
    final targetIndex = state.targetVariantIndex;

    emit(
      ProductImageLoading(
        previousImages: imagesBeforeLoading,
        previousTargetIndex: targetIndex,
      ),
    );

    try {
      final result = await pickFromGallery();

      if (result != null) {
        emit(
          ProductImagePicked(images: [result], targetVariantIndex: targetIndex),
        );
      } else {
        emit(
          ProductImagePicked(
            images: imagesBeforeLoading,
            targetVariantIndex: targetIndex,
          ),
        );
      }
    } catch (e) {
      emit(
        ProductImageError(
          'Failed to pick image from gallery: ${e.toString()}',
          previousImages: imagesBeforeLoading,
          previousTargetIndex: targetIndex,
        ),
      );
    }
  }

  void _onAddImage(AddImageEvent event, Emitter<ProductImageState> emit) {
    final currentImages = state.selectedImages;
    final targetIndex = state.targetVariantIndex;
    final updatedImages = List<dynamic>.from(currentImages)..add(event.path);

    emit(
      ProductImagePicked(
        images: updatedImages,
        targetVariantIndex: targetIndex,
      ),
    );
  }

  void _onRemoveImage(RemoveImageEvent event, Emitter<ProductImageState> emit) {
    final current = state;

    if (current.selectedImages.isEmpty) return;
    if (event.index < 0 || event.index >= current.selectedImages.length) return;

    final updated = List<dynamic>.from(current.selectedImages)
      ..removeAt(event.index);

    emit(
      ProductImagePicked(
        images: updated,
        targetVariantIndex: current.targetVariantIndex,
      ),
    );
  }

  void _onClearAll(ClearAllImagesEvent event, Emitter<ProductImageState> emit) {
    emit(const ProductImageInitial());
  }

  void _onSetTargetVariantIndex(
    SetTargetVariantIndexEvent event,
    Emitter<ProductImageState> emit,
  ) {
    final currentState = state;

    if (currentState is ProductImagePicked) {
      emit(currentState.copyWith(targetVariantIndex: event.index));
    } else {
      emit(
        ProductImagePicked(
          images: currentState.selectedImages,
          targetVariantIndex: event.index,
        ),
      );
    }
  }

  void _onClearTargetVariantIndex(
    ClearTargetVariantIndexEvent event,
    Emitter<ProductImageState> emit,
  ) {
    final currentState = state;

    if (currentState is ProductImagePicked) {
      emit(currentState.copyWith(clearTargetIndex: true));
    } else {
      emit(
        ProductImagePicked(
          images: currentState.selectedImages,
          targetVariantIndex: null,
        ),
      );
    }
  }
}
