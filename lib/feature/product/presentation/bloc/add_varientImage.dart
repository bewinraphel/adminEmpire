import 'package:empire/feature/auth/domain/usecase/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_gallery_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class VarientImageEvent extends Equatable {
  const VarientImageEvent();

  @override
  List<Object> get props => [];
}

class PickImageFromCameraVarientEvent extends VarientImageEvent {}

class PickImageFromGalleryVarientEvent extends VarientImageEvent {}

class ClearImageEvent extends VarientImageEvent {}

class VarientSelectImageEvent extends VarientImageEvent {
  final String imagePath;

  const VarientSelectImageEvent(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

abstract class VarientImageState extends Equatable {
  const VarientImageState();

  @override
  List<Object> get props => [];
}

class VarientImageInitial extends VarientImageState {}

class VarientImageLoading extends VarientImageState {}

class VarientImagePicked extends VarientImageState {
  final String imagePath;

  const VarientImagePicked(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class VarientImageError extends VarientImageState {
  final String message;

  const VarientImageError(this.message);

  @override
  List<Object> get props => [message];
}

class VarientImageCleared extends VarientImageState {}

class VarientImageBloc extends Bloc<VarientImageEvent, VarientImageState> {
  final PickImageFromCameraUsecase pickImageFromCameraUsecaseUseCase;
  final PickImageFromGalleryusecase pickImageFromGalleryusecaseUseCase;

  VarientImageBloc({
    required this.pickImageFromCameraUsecaseUseCase,
    required this.pickImageFromGalleryusecaseUseCase,
  }) : super(VarientImageInitial()) {
    on<PickImageFromCameraVarientEvent>(_onPickImageFromCameraUsecase);
    on<PickImageFromGalleryVarientEvent>(_onPickImageFromGalleryusecase);
    on<ClearImageEvent>(_onClearImage);
    on<VarientSelectImageEvent>(_onSelectImage);
  }

  Future<void> _onPickImageFromCameraUsecase(
    PickImageFromCameraVarientEvent event,
    Emitter<VarientImageState> emit,
  ) async {
    emit(VarientImageLoading());
    final result = await pickImageFromCameraUsecaseUseCase();
    result.fold(
      (failure) => emit(VarientImageError(failure.message)),
      (imagePath) => emit(VarientImagePicked(imagePath)),
    );
  }

  Future<void> _onPickImageFromGalleryusecase(
    PickImageFromGalleryVarientEvent event,
    Emitter<VarientImageState> emit,
  ) async {
    emit(VarientImageLoading());
    final result = await pickImageFromGalleryusecaseUseCase();
    result.fold(
      (failure) => emit(VarientImageError(failure.message)),
      (imagePath) => emit(VarientImagePicked(imagePath)),
    );
  }

  void _onClearImage(ClearImageEvent event, Emitter<VarientImageState> emit) {
    emit(VarientImageCleared());
  }

  void _onSelectImage(
    VarientSelectImageEvent event,
    Emitter<VarientImageState> emit,
  ) {
    emit(VarientImagePicked(event.imagePath));
  }
}
