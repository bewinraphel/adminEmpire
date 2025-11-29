import 'package:empire/feature/auth/domain/usecase/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_gallery_usecase.dart';

import 'package:empire/feature/product/presentation/bloc/varient_image_bloc.dart/vareint_Image_state.dart';
import 'package:empire/feature/product/presentation/bloc/varient_image_bloc.dart/vareint_image_event.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class VariantImageBloc extends Bloc<VariantImageEvent, VariantImageState> {
  final PickImageFromCameraUsecase pickImageFromCameraUseCase;
  final PickImageFromGalleryusecase pickImageFromGalleryUseCase;

  VariantImageBloc({
    required this.pickImageFromCameraUseCase,
    required this.pickImageFromGalleryUseCase,
  }) : super(const VariantImageInitial()) {
    on<PickImageFromCameraForVariantEvent>(_onPickFromCamera);
    on<PickImageFromGalleryForVariantEvent>(_onPickFromGallery);
  }

  Future<void> _onPickFromCamera(
    PickImageFromCameraForVariantEvent event,
    Emitter<VariantImageState> emit,
  ) async {
    emit(VariantImageLoading(variantIndex: event.variantIndex));

    try {
      final result = await pickImageFromCameraUseCase();

      if (result != null) {
        emit(VariantImagesUpdated(event.variantIndex, result));
      } else {
        emit(VariantImagesUpdated(event.variantIndex, result));
      }
    } catch (e) {
      emit(
        VariantImageError(
          message: 'Failed to pick image from camera: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onPickFromGallery(
    PickImageFromGalleryForVariantEvent event,
    Emitter<VariantImageState> emit,
  ) async {
    emit(VariantImageLoading(variantIndex: event.variantIndex));

    try {
      final result = await pickImageFromGalleryUseCase();

      if (result != null) {
        emit(VariantImagesUpdated(event.variantIndex, result));
      } else {
        emit(VariantImagesUpdated(event.variantIndex, result));
      }
    } catch (e) {
      emit(
        VariantImageError(
          message: 'Failed to pick image from gallery: ${e.toString()}',
          variantIndex: event.variantIndex,
        ),
      );
    }
  }

  void _onSetVariantImage(
    SetVariantImageEvent event,
    Emitter<VariantImageState> emit,
  ) {
    emit(VariantImagesUpdated(event.variantIndex, event.imageData));
  }
}
