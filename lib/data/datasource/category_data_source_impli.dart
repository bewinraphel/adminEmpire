import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/widgets.dart';
import 'package:empire/data/datasource/category_data_source.dart';
import 'package:empire/domain/entities/category_entities.dart';
import 'package:empire/domain/failures/category_failures.dart';

import 'package:logger/logger.dart';

class CategoryDataSourceImpl implements CategoryDataSource {
  CategoryDataSourceImpl(this.logger);
  final Logger logger;

  @override
  Future<Either<List<CategoryEntities>, CategoryFailure>> getCategory() async {
    try {
      final snapshot =await FirebaseFirestore.instance.collection('category').get();

      final categories = snapshot.docs.map((doc) {
        return CategoryEntities(
          description: doc['description'] ?? '',
          uid: doc.id,
          imageUrl: doc['imageurl'] ?? '',
          category: doc['name'] ?? '',
        );
      }).toList();

      return left(categories);
    } catch (e) {
      return  right(CategoryFailure.server(e.toString()));
    }
  }

  @override
  Future<Either<CategoryFailure, Unit>> addCategory(
    String category,
    String imageUrl,
    String description,
  ) async {
    String? image;

    try {
      logger.i('Starting category image upload ');
      final file = File(imageUrl);

      if (!await file.exists()) {
        return left(
          const CategoryFailure.validation('Image file does not exist'),
        );
      }

      try {
        image = await uploadImageToCloudinary(file);
        if (image == null || image.isEmpty) {
          return left(const CategoryFailure.validation('Image URL is empty'));
        }
        logger.i('Category image uploaded: $image');
      } catch (e) {
        logger.e('Category image upload failed: $e');
        return left(CategoryFailure.network('Failed to upload image: $e'));
      }

      await FirebaseFirestore.instance.collection('category').add({
        'name': category,
        'imageurl': image,
        'description': description,
      });

      logger.i('Category added successfully: $category');
      return right(unit);
    } catch (e, stack) {
      logger.e('Failed to add category: $e', stackTrace: stack);
      return left(CategoryFailure.server('Failed to add category: $e'));
    }
  }

  @override
  Future<Either<CategoryFailure, Unit>> addingSubCategory(
    String id,
    String category,
    String imageUrl,
    String description,
  ) async {
    String? image;

    try {
      logger.i('Starting category image upload ');
      final file = File(imageUrl);

      if (!await file.exists()) {
        return left(
          const CategoryFailure.validation('Image file does not exist'),
        );
      }

      try {
        image = await uploadImageToCloudinary(file);
        if (image == null || image.isEmpty) {
          return left(const CategoryFailure.validation('Image URL is empty'));
        }
        logger.i('Category image uploaded: $image');
      } catch (e) {
        logger.e('Category image upload failed: $e');
        return left(CategoryFailure.network('Failed to upload image: $e'));
      }

      await FirebaseFirestore.instance
          .collection('category')
          .doc(id)
          .collection('subcategory')
          .add({
            'name': category,
            'imageurl': image,
            'description': description,
          });

      logger.i('Category added successfully: $category');
      return right(unit);
    } catch (e, stack) {
      logger.e('Failed to add category: $e', stackTrace: stack);
      return left(CategoryFailure.server('Failed to add category: $e'));
    }
  }
}
