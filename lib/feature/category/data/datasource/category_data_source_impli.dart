import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/core/utilis/widgets.dart';
import 'package:empire/feature/category/data/datasource/category_data_source.dart';
import 'package:empire/feature/category/domain/entities/category_entities.dart';

import 'package:logger/logger.dart';

class CategoryDataSourceImpl implements CategoryDataSource {
  CategoryDataSourceImpl(this.logger);
  final Logger logger;

  @override
  Future<Either<List<CategoryEntities>, Failures>> getCategory() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('category')
          .get();

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
      return right(Failures.server(e.toString()));
    }
  }

  @override
  Future<Either<Failures, Unit>> addCategory(
    String category,
    String imageUrl,
    String description,
  ) async {
    String? image;

    try {
      logger.i('Starting category image upload ');
      final file = File(imageUrl);

      if (!await file.exists()) {
        return left(const Failures.validation('Image file does not exist'));
      }

      try {
        image = await uploadImageToCloudinary(file);
        if (image == null || image.isEmpty) {
          return left(const Failures.validation('Image URL is empty'));
        }
        logger.i('Category image uploaded: $image');
      } catch (e) {
        logger.e('Category image upload failed: $e');
        return left(Failures.network('Failed to upload image: $e'));
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
      return left(Failures.server('Failed to add category: $e'));
    }
  }

  @override
  Future<Either<Failures, Unit>> addingSubCategory(
    String id,
    String category,
    String imageUrl,
    String description,
  ) async {
    String? image;

    try {
      logger.i('Starting Subcategory image upload ');
      final file = File(imageUrl);

      if (!await file.exists()) {
        return left(const Failures.validation('Image file does not exist'));
      }

      try {
        image = await uploadImageToCloudinary(file);

        if (image == null || image.isEmpty) {
          return left(const Failures.validation('Image URL is empty'));
        }
        logger.i('Subcategory image uploaded: $image');
      } catch (e) {
        logger.e('Subcategory image upload failed: $e');
        return left(Failures.network('Failed to upload image: $e'));
      }
      final subcategoryRef = FirebaseFirestore.instance
          .collection('category')
          .doc(id)
          .collection('subcategory')
          .doc(); // auto-generated ID

      await subcategoryRef.set({
        'Subcategory': category,
        'imageurl': image,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
      });

      logger.i('Subcategory added successfully: $category');
      return right(unit);
    } catch (e, stack) {
      logger.e('Failed to add Subcategory: $e', stackTrace: stack);
      return left(Failures.server('Failed to add category: $e'));
    }
  }

  @override
  Future<Either<Failures, List<CategoryEntities>>> getSubCategory(
    String id,
  ) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('category')
          .doc(id)
          .collection('subcategory')
          .get();

      final categories = snapshot.docs.map((doc) {
        return CategoryEntities(
          description: doc['description'] ?? '',
          uid: doc.id,
          imageUrl: doc['imageurl'] ?? '',
          category: doc['Subcategory'] ?? '',
        );
      }).toList();

      return right(categories);
    } catch (e) {
      return left(Failures.server(e.toString()));
    }
  }
}
