import 'package:empire/feature/auth/domain/repositories/image_profile.dart';

class PickImageFromCameraUsecase {
  final ProfileImage profileImage;

  PickImageFromCameraUsecase(this.profileImage);
  Future call() async {
    return await profileImage.PickImageFromCameraUsecase();
  }
}
