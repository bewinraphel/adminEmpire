import 'package:empire/feature/category/domain/usecase/categories/category_image_camera.dart';
import 'package:empire/feature/category/domain/usecase/categories/catgeroyimgae_gallery.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CategoryImagePickerEvent {}

class CategoryImageFromCameraEvent extends CategoryImagePickerEvent {}

class CategoryImageFromGalleryEvent extends CategoryImagePickerEvent {}

class ClearPickedImageEvent extends CategoryImagePickerEvent {}

class SelectedProductImage extends CategoryImagePickerEvent {
  final String selectedId;
  SelectedProductImage(this.selectedId);
  @override
  List<Object> get props => [selectedId];
}

abstract class ImagePickercategory {}

class ImageInitial extends ImagePickercategory {}

class PickingImage extends ImagePickercategory {}

class ImagePickedSuccess extends ImagePickercategory {
  final dynamic image;
  ImagePickedSuccess(this.image);
}

class Categorystate extends ImagePickercategory {
  final dynamic image;
  Categorystate(this.image);
}

class ImagePickedError extends ImagePickercategory {
  final String errot;
  ImagePickedError(this.errot);
}

class CategoryImageBloc
    extends Bloc<CategoryImagePickerEvent, ImagePickercategory> {
  final CategoryImageCamera PickImageFromCameraUsecase;
  final CategoryImagegallery PickImageFromGalleryusecase;

  CategoryImageBloc(
    this.PickImageFromCameraUsecase,
    this.PickImageFromGalleryusecase,
  ) : super(ImageInitial()) {
    on<CategoryImageFromCameraEvent>((event, emit) async {
      emit(PickingImage());
      final result = await PickImageFromCameraUsecase();
      if (result != null) {
        emit(ImagePickedSuccess(result));
      } else {
        emit(ImagePickedError('Node Image Selcted'));
      }
    });
    on<CategoryImageFromGalleryEvent>((event, emit) async {
      emit(PickingImage());
      final result = await PickImageFromGalleryusecase();
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
