 import 'package:empire/core/utilis/layout_constants.dart';
import 'package:empire/core/utilis/validation_error.dart';
import 'package:empire/feature/product/domain/enities/form_validatioon.dart';

class ValidateProductFormUseCase {
  FormValidationResult call({
    required String productName,
    required String description,
    required List<dynamic> images,
    required String category,
    required String? brandLabel,
  }) {
    final Map<String, ValidationError> errors = {};

    // Validate product name
    if (productName.trim().isEmpty) {
      errors['productName'] = const ValidationError(
        field: 'productName',
        message: 'Product name is required',
      );
    } else if (productName.trim().length < 3) {
      errors['productName'] = const ValidationError(
        field: 'productName',
        message: 'Product name must be at least 3 characters',
      );
    }

    // Validate description
    if (description.trim().isEmpty) {
      errors['description'] = const ValidationError(
        field: 'description',
        message: 'Description is required',
      );
    } else if (description.trim().length < 10) {
      errors['description'] = const ValidationError(
        field: 'description',
        message: 'Description must be at least 10 characters',
      );
    }

    // Validate images
    if (images.length < LayoutConstants.minimumProductImages) {
      errors['images'] = const ValidationError(
        field: 'images',
        message: 'At least ${LayoutConstants.minimumProductImages} images required',
      );
    }

    // Validate category
    if (category.isEmpty) {
      errors['category'] = const ValidationError(
        field: 'category',
        message: 'Please select a category',
      );
    }

    // Validate brand
    if (brandLabel == null || brandLabel.isEmpty) {
      errors['brand'] = const ValidationError(
        field: 'brand',
        message: 'Please select a brand',
      );
    }

    return errors.isEmpty
        ? FormValidationResult.valid()
        : FormValidationResult.invalid(errors);
  }
}