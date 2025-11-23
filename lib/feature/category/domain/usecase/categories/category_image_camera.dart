import 'package:empire/feature/category/domain/repositories/categoryimage_repository.dart';

class CategoryImageCamera {
  final Categoryimage profileImage;

  CategoryImageCamera(this.profileImage);
  Future call() async {
    return await profileImage.categoryPickImageFromCameraUsecase();
  }
}
