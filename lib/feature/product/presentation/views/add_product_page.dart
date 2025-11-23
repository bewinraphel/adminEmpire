import 'package:empire/feature/product/presentation/views/add_product.dart/add_product.dart';
import 'package:empire/feature/product/presentation/views/add_product.dart/mobile_add_product_page.dart';
import 'package:flutter/material.dart';

class AddProductPage extends StatelessWidget {
  final String mainCategoryId;
  final String subcategoryId;
  final String mainCategoryName;
  final String subcategoryName;
  const AddProductPage({
    super.key,
    required this.mainCategoryId,
    required this.subcategoryId,
    required this.mainCategoryName,
    required this.subcategoryName,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
 
        final isMobile = constraints.maxWidth < 450;
        return isMobile
            ? MobileAddProdutsPage(
                subcategoryId: subcategoryId,
                mainCategoryId: mainCategoryId,
                mainCategoryName: mainCategoryName,
                subcategoryName: subcategoryName,
              )
            : const AddProductsPageContent(
                mainCategoryId: '',
                subcategoryId: '',
                mainCategoryName: '',
                subcategoryName: '',
              );
      },
    );
  }
}