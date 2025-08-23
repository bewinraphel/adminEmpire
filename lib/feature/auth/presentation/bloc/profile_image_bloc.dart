import 'package:empire/feature/auth/domain/usecase/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_gallery_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ImagePickerEvent {}

class ChooseImageFromCameraEvent extends ImagePickerEvent {}

class ChooseImageFromGalleryEvent extends ImagePickerEvent {}

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
  final String image;
  ImagePickedSuccess(this.image);
}

class Categorystate extends ImagePickerState {
  final String image;
  Categorystate(this.image);
}

class ImagePickedError extends ImagePickerState {
  final String errot;
  ImagePickedError(this.errot);
}

class ImageAuth extends Bloc<ImagePickerEvent, ImagePickerState> {
  final PickImageFromCamera pickImageFromCamera;
  final PickImageFromGallery pickImageFromGallery;

  ImageAuth(this.pickImageFromCamera, this.pickImageFromGallery)
    : super(ImageInitial()) {
    on<ChooseImageFromCameraEvent>((event, emit) async {
      emit(PickingImage());
      final result = await pickImageFromCamera();
      if (result != null) {
        emit(ImagePickedSuccess(result));
      } else {
        emit(ImagePickedError('Node Image Selcted'));
      }
    });
    on<ChooseImageFromGalleryEvent>((event, emit) async {
      emit(PickingImage());
      final result = await pickImageFromGallery();
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
