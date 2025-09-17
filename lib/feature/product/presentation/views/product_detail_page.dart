import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/core/utilis/widgets.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/presentation/bloc/add_product_bloc/add_product.dart';

import 'package:empire/feature/product/presentation/views/add_product.dart/widgets.dart';
import 'package:empire/feature/product/presentation/views/editpage/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductEntity? product;
  String? mainCategoryId;
  String? subcategory;
  ProductDetailsPage({
    super.key,
    this.product,
    this.subcategory,
    this.mainCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: product == null
          ? const Center(child: Text('No product data available'))
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageSection(context, product!.images),
                      _buildDetailsSection(
                        context,
                        product!,
                        mainCategoryId,
                        subcategory,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildImageSection(BuildContext context, List<String> images) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
          child: images.isNotEmpty
              ? Image.network(
                  images[0],
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.30,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 50),
                      ),
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 50),
                  ),
                ),
        ),

        if (images.isNotEmpty)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => Container(
                  width: index == 0 ? 24 : 8,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: index == 0 ? Colors.blue[500] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDetailsSection(
    BuildContext context,
    ProductEntity product,
    String? mainCategoryId,
    String? subcategory,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 300),
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            Text(
              product.name,
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),

            Text(
              product.description,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: const Color(0xFF4B5563),
              ),
            ),
            const SizedBox(height: 24),

            _buildDetailRow('Quantity', product.quantities.toString()),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildDetailRow(
                    'Price',
                    '\$${product.price.toStringAsFixed(2)}',
                  ),
                ),
                Expanded(
                  child: _buildDetailRow(
                    'Tax Rate',
                    '${product.taxRate.toStringAsFixed(1)}%',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildDetailRow('Filter Tag', product.filterTags.join(', ')),
            const SizedBox(height: 16),

            _buildTagsSection(product.tags),
            const SizedBox(height: 16),

            _buildDetailRow('Category', product.category),
            const SizedBox(height: 24),

            const Divider(),
            product.category == 'electronics'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Titlesnew(nametitle: 'Shipping Details'),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Weight (kg)',
                        product.weight.toStringAsFixed(2),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailRow(
                              'Length (cm)',
                              product.length.toStringAsFixed(0),
                            ),
                          ),
                          Expanded(
                            child: _buildDetailRow(
                              'Width (cm)',
                              product.width.toStringAsFixed(0),
                            ),
                          ),
                          Expanded(
                            child: _buildDetailRow(
                              'Height (cm)',
                              product.height.toStringAsFixed(0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  )
                : const SizedBox(),

            if (product.variantDetails.isNotEmpty) ...[
              const Titlesnew(nametitle: 'Variants'),
              const SizedBox(height: 16),
              _buildVariantsSection(product.variantDetails),
            ],
            const SizedBox20(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.40,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Product'),
                          content: const Text(
                            'Are you sure you want to delete this product?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<ProductBloc>().add(
                                  DeleteProductEvent(
                                    mainCategoryId!,
                                    subcategory!,
                                    product.productDocId!,
                                  ),
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    label: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: Fonts.raleway,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.40,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return EditProdutsPage(
                              mainCategoryId: mainCategoryId!,
                              subcategoryId: subcategory,

                              product: product,
                              productId: product.productDocId,
                            );
                          },
                        ),
                      );
                    },
                    label: const Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: Fonts.raleway,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF4B5563),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 14,
            color: const Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection(List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF4B5563),
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: tags
              .map(
                (tag) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    tag,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1E40AF),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildVariantsSection(List<Variant> variants) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: variants.length,
      itemBuilder: (context, index) {
        final variant = variants[index];
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 150),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(5, 5),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: Colors.white70,
                      offset: Offset(-5, -5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: variant.image == null
                          ? const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.black54,
                              ),
                            )
                          : Image.network(
                              variant.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.black54,
                                    ),
                                  ),
                            ),
                    ),
                    const SizedBox(width: 16),
                    // Variant Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            variant.name,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Price: \$${variant.salePrice.toStringAsFixed(2)}',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'Sale price: ${variant.regularPrice}',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: const Color(0xFF111827),
                            ),
                          ),
                          Text(
                            'Quantity: ${variant.quantity}',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: const Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
