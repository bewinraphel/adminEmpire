import 'package:empire/feature/auth/domain/usecase/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_gallery_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ImagePickerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChooseImageFromCameraEvent extends ImagePickerEvent {}

class VariantImageFromCameraEvent extends ImagePickerEvent {}

class ChooseImageFromGalleryEvent extends ImagePickerEvent {}

class VarinatImageFromGalleryEvent extends ImagePickerEvent {}

class ClearPickedImageEvent extends ImagePickerEvent {}

class SelectedProductImage extends ImagePickerEvent {
  final String selectedId;
  SelectedProductImage(this.selectedId);
  @override
  List<Object> get props => [selectedId];
}

abstract class ImagePickerState {}

class ImageInitial extends ImagePickerState {}

class PickingImage extends ImagePickerState {}

class ImagePickedSuccess extends ImagePickerState {
  final dynamic image;
  ImagePickedSuccess(this.image);
}

class Categorystate extends ImagePickerState {
  final dynamic image;
  Categorystate(this.image);
}

class ImagePickedError extends ImagePickerState {
  final dynamic errot;
  ImagePickedError(this.errot);
}

class ImageAuth extends Bloc<ImagePickerEvent, ImagePickerState> {
  final PickImageFromCameraUsecase pickImageFromCameraUsecaseUseCase;
  final PickImageFromGalleryusecase pickImageFromGalleryusecaseUseCase;

  ImageAuth({
    required this.pickImageFromCameraUsecaseUseCase,
    required this.pickImageFromGalleryusecaseUseCase,
  }) : super(ImageInitial()) {
    on<ChooseImageFromCameraEvent>((event, emit) async {
      emit(PickingImage());
      final result = await pickImageFromCameraUsecaseUseCase();
      if (result != null) {
        emit(ImagePickedSuccess(result));
      } else {
        emit(ImagePickedError('Node Image Selcted'));
      }
    });

    on<ChooseImageFromGalleryEvent>((event, emit) async {
      emit(PickingImage());
      final result = await pickImageFromGalleryusecaseUseCase();
      if (result != null) {
        emit(ImagePickedSuccess(result));
      } else {
        emit(ImagePickedError('Node Image Selcted'));
      }
    });
    // variant
    on<VariantImageFromCameraEvent>((event, emit) async {
      emit(PickingImage());
      final result = await pickImageFromCameraUsecaseUseCase();
      if (result != null) {
        emit(ImagePickedSuccess(result));
      } else {
        emit(ImagePickedError('Node Image Selcted'));
      }
    });
    on<VarinatImageFromGalleryEvent>((event, emit) async {
      emit(PickingImage());
      final result = await pickImageFromGalleryusecaseUseCase();
      if (result != null) {
        emit(ImagePickedSuccess(result));
      } else {
        emit(ImagePickedError('Node Image Selcted'));
      }
    });
    on<ClearPickedImageEvent>((event, emit) {
      emit(ImageInitial());
    });
    on<SelectedProductImage>((event, emit) {
      if (state is ImagePickedSuccess) {
        emit(ImagePickedSuccess(event.selectedId));
      }
    });
  }
}
