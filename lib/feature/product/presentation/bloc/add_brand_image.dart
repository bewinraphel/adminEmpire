import 'package:empire/feature/auth/domain/usecase/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_gallery_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class PickImageFromCameraEvent extends ImageEvent {}

class PickImageFromGalleryEvent extends ImageEvent {}

class ClearBrandImageEvent extends ImageEvent {}

class SelectImageEvent extends ImageEvent {
  final dynamic imagePath;

  const SelectImageEvent(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

abstract class AddBrandImageState extends Equatable {
  const AddBrandImageState();

  @override
  List<Object> get props => [];
}

class BarndImageInitial extends AddBrandImageState {}

class BarndImageLoading extends AddBrandImageState {}

class BarndImagePicked extends AddBrandImageState {
  final dynamic imagePath;

  const BarndImagePicked(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class ImageError extends AddBrandImageState {
  final String message;

  const ImageError(this.message);

  @override
  List<Object> get props => [message];
}

class BarndImageCleared extends AddBrandImageState {}

class AddBrandImage extends Bloc<ImageEvent, AddBrandImageState> {
  final PickImageFromCameraUsecase pickImageFromCameraUsecaseUseCase;
  final PickImageFromGalleryusecase pickImageFromGalleryusecaseUseCase;

  AddBrandImage({
    required this.pickImageFromCameraUsecaseUseCase,
    required this.pickImageFromGalleryusecaseUseCase,
  }) : super(BarndImageInitial()) {
    on<PickImageFromCameraEvent>(_onPickImageFromCameraUsecase);
    on<PickImageFromGalleryEvent>(_onPickImageFromGalleryusecase);
    on<ClearBrandImageEvent>(_onClearImage);
    on<SelectImageEvent>(_onSelectImage);
  }

  Future<void> _onPickImageFromCameraUsecase(
    PickImageFromCameraEvent event,
    Emitter<AddBrandImageState> emit,
  ) async {
    emit(BarndImageLoading());
    final result = await pickImageFromCameraUsecaseUseCase();
    if (result != null) {
      emit(BarndImagePicked(result));
    }
    {
      emit(const ImageError('Please try agin'));
    }
  }

  Future<void> _onPickImageFromGalleryusecase(
    PickImageFromGalleryEvent event,
    Emitter<AddBrandImageState> emit,
  ) async {
    emit(BarndImageLoading());
    final result = await pickImageFromGalleryusecaseUseCase();
    if (result != null) {
      emit(BarndImagePicked(result));
    }
    {
      emit(const ImageError('Please try agin'));
    }
  }

  void _onClearImage(
    ClearBrandImageEvent event,
    Emitter<AddBrandImageState> emit,
  ) {
    emit(BarndImageCleared());
  }

  void _onSelectImage(
    SelectImageEvent event,
    Emitter<AddBrandImageState> emit,
  ) {
    emit(BarndImagePicked(event.imagePath));
  }
}
