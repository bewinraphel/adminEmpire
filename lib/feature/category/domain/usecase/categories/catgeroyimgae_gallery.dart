 
import 'package:empire/feature/category/domain/repositories/categoryimage_repository.dart';

class CategoryImagegallery {
  final Categoryimage categoryImage;

  CategoryImagegallery(this.categoryImage);
  Future call() async {
    return await categoryImage.categoryImageFromGallery();
  }
}
