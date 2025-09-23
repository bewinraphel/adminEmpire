import 'package:empire/feature/auth/domain/usecase/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_gallery_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@override
abstract class BrandImagePickerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChooseBrandImageFromCameraEvent extends BrandImagePickerEvent {}

class VariantBrandImageFromCameraEvent extends BrandImagePickerEvent {}

class ChooseBrandImageFromGalleryEvent extends BrandImagePickerEvent {}

class VarinatBrandImageFromGalleryEvent extends BrandImagePickerEvent {}

class ClearPickedBrandImageEvent extends BrandImagePickerEvent {}

class SelectedProductBrandImage extends BrandImagePickerEvent {
  final String selectedId;
  SelectedProductBrandImage(this.selectedId);
  @override
  List<Object> get props => [selectedId];
}

abstract class BrandImagePickerState {}

class BrandImageInitial extends BrandImagePickerState {}

class PickingImageBrand extends BrandImagePickerState {}

class BrandImagePickedSuccess extends BrandImagePickerState {
  final String image;
  BrandImagePickedSuccess(this.image);
}

class Categorystate extends BrandImagePickerState {
  final String image;
  Categorystate(this.image);
}

class ImagePickedError extends BrandImagePickerState {
  final String errot;
  ImagePickedError(this.errot);
}

class BrandImageAuth
    extends Bloc<BrandImagePickerEvent, BrandImagePickerState> {
  final PickImageFromCamera pickImageFromCamera;
  final PickImageFromGallery pickImageFromGallery;

  BrandImageAuth(this.pickImageFromCamera, this.pickImageFromGallery)
    : super(BrandImageInitial()) {
    on<ChooseBrandImageFromCameraEvent>((event, emit) async {
      emit(PickingImageBrand());
      final result = await pickImageFromCamera();
      if (result != null) {
        emit(BrandImagePickedSuccess(result));
      } else {
        emit(ImagePickedError('Node Image Selcted'));
      }
    });

    on<ChooseBrandImageFromGalleryEvent>((event, emit) async {
      emit(PickingImageBrand());
      final result = await pickImageFromGallery();
      print(result);
      if (result != null) {
        emit(BrandImagePickedSuccess(result));
      } else {
        emit(ImagePickedError('Node Image Selcted'));
      }
    });

    on<VariantBrandImageFromCameraEvent>((event, emit) async {
      emit(PickingImageBrand());
      final result = await pickImageFromCamera();
      if (result != null) {
        emit(BrandImagePickedSuccess(result));
      } else {
        emit(ImagePickedError('Node Image Selcted'));
      }
    });
    on<VarinatBrandImageFromGalleryEvent>((event, emit) async {
      emit(PickingImageBrand());
      final result = await pickImageFromGallery();
      if (result != null) {
        emit(BrandImagePickedSuccess(result));
      } else {
        emit(ImagePickedError('Node Image Selcted'));
      }
    });
    on<ClearPickedBrandImageEvent>((event, emit) {
      emit(BrandImageInitial());
    });
    on<SelectedProductBrandImage>((event, emit) {
      if (state is BrandImagePickedSuccess) {
        emit(BrandImagePickedSuccess(event.selectedId));
      }
    });
  }
}
