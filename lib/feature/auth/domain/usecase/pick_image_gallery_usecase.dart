import 'package:empire/feature/auth/domain/repositories/image_profile.dart';

class PickImageFromGalleryusecase {
  final ProfileImage profileImage;

  PickImageFromGalleryusecase(this.profileImage);
  Future<dynamic> call() async {
    return await profileImage.PickImageFromGalleryusecase();
  }
}
