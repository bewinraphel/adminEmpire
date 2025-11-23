import 'package:empire/feature/auth/data/datasource/image_profile.dart';
import 'package:empire/feature/auth/domain/repositories/image_profile.dart';

class ProfileImageImpli implements ProfileImage {
  final ImageSources imageSource;
  ProfileImageImpli(this.imageSource);
  @override
  Future<dynamic> PickImageFromGalleryusecase() {
    return imageSource.pickFromGallery();
  }

  @override
  Future<dynamic> PickImageFromCameraUsecase() {
    return imageSource.pickFromCamera();
  }
}
