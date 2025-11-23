import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImageSources {
  final ImagePicker picker = ImagePicker();

  Future<dynamic> pickFromCamera() async {
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedImage == null) return null;

    if (kIsWeb) {
      return await pickedImage.readAsBytes();
    } else {
      return pickedImage.path;
    }
  }

  Future<dynamic> pickFromGallery() async {
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null) return null;

    if (kIsWeb) {
      return await pickedImage.readAsBytes();
    } else {
      return pickedImage.path;
    }
  }
}
