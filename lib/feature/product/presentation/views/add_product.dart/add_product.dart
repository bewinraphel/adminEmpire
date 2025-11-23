import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_gallery_usecase.dart';
import 'package:empire/feature/category/presentation/views/categories/widgets.dart';
import 'package:empire/feature/homepage/presentation/view/home_page.dart';
import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/domain/usecase/add_product_usecae.dart';
import 'package:empire/feature/product/domain/usecase/adding_brand_usecase.dart';
import 'package:empire/feature/product/domain/usecase/get_brand_usecase.dart';
import 'package:empire/feature/product/presentation/bloc/add_brand_image.dart';
import 'package:empire/feature/product/presentation/bloc/add_product.dart';
import 'package:empire/feature/product/presentation/bloc/add_product_form.dart';
import 'package:empire/feature/product/presentation/bloc/brand.dart';
import 'package:empire/feature/product/presentation/bloc/product_image.dart';
import 'package:empire/feature/product/presentation/views/add_product.dart/widgets.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AddProductsPageContent extends StatelessWidget {
  final String mainCategoryId;
  final String subcategoryId;
  final String mainCategoryName;
  final String subcategoryName;

  const AddProductsPageContent({
    super.key,
    required this.mainCategoryId,
    required this.subcategoryId,
    required this.mainCategoryName,
    required this.subcategoryName,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1200;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Titlesnew(nametitle: 'Add Product')),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AddProductFormBloc()),
          BlocProvider(create: (_) => ProductBloc(sl<AddProductUseCase>())),
          BlocProvider(
            create: (_) => ProductImageBloc(
              pickFromCamera: sl<PickImageFromCameraUsecase>(),
              pickFromGallery: sl<PickImageFromGalleryusecase>(),
            ),
          ),
          BlocProvider(
            create: (_) =>
                BrandBloc(sl<AddBrandUseCase>(), sl<GetBrandsUseCase>())..add(
                  BrandFetching(
                    mainCategoryId: mainCategoryId,
                    subCategoryId: subcategoryId,
                  ),
                ),
          ),
          BlocProvider(
            create: (_) => AddBrandImage(
              pickImageFromCameraUsecaseUseCase:
                  sl<PickImageFromCameraUsecase>(),
              pickImageFromGalleryusecaseUseCase:
                  sl<PickImageFromGalleryusecase>(),
            ),
          ),
        ],
        child: Builder(
          builder: (context) {
            return BlocListener<ProductImageBloc, ProductImageState>(
              listener: (context, state) {
                if (state is ProductImagePicked &&
                    state.targetVariantIndex != null) {
                  context.read<AddProductFormBloc>().add(
                    UpdateVariantImageEvent(
                      state.targetVariantIndex!,
                      state.images.first,
                    ),
                  );

                  context.read<ProductImageBloc>().add(
                    ClearTargetVariantIndexEvent(),
                  );
                }
                if (state is ProductSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product added successfully!'),
                    ),
                  );
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (_) => false,
                  );
                } else if (state is ProductFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('error')));
                }
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: isDesktop ? 6 : 1,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(constraints.maxWidth * 0.04),
                          child: AnimationConfiguration.staggeredList(
                            position: 0,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              horizontalOffset: 50,
                              child: FadeInAnimation(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!isDesktop) ...[
                                      _buildProductImagesSection(
                                        context,
                                        constraints,
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                    _buildProductNameSection(context),
                                    const SizedBox(height: 24),
                                    _buildDescriptionSection(context),
                                    const SizedBox(height: 24),

                                    _buildTagsSection(context),
                                    const SizedBox(height: 24),
                                    _buildAvailabilitySection(context),

                                    _buildCategorySection(context),
                                    const SizedBox(height: 24),
                                    _buildConditionalDimensions(
                                      context,
                                      constraints,
                                    ),
                                    const SizedBox(height: 24),
                                    // _buildVariantsSection(context, constraints,State.),
                                    const SizedBox(height: 24),
                                    _buildBrandSection(context),
                                    const SizedBox(height: 40),
                                    _buildSubmitButton(context, constraints),
                                    const SizedBox(height: 40),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      if (isDesktop)
                        Expanded(
                          flex: 4,
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: _buildProductImagesSection(
                              context,
                              constraints,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductImagesSection(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Images',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        BlocListener<ProductImageBloc, ProductImageState>(
          listener: (context, state) {
            if (state is ProductImagePicked) {
              context.read<AddProductFormBloc>().add(
                AddProductImagesEvent([state.images]),
              );
            }
          },
          child:
              BlocSelector<
                AddProductFormBloc,
                AddProductFormState,
                List<dynamic>
              >(
                selector: (state) =>
                    state is AddProductFormUpdated ? state.productImages : [],
                builder: (context, images) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                    itemCount: images.length + 1,
                    itemBuilder: (context, index) {
                      if (index == images.length) {
                        return _buildAddImageButton(context);
                      }
                      return _buildImageTile(context, images[index], index);
                    },
                  );
                },
              ),
        ),
      ],
    );
  }

  Widget _buildImageTile(BuildContext context, dynamic path, int index) {
    return Stack(
      children: [
        buildImagePreview(path),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => context.read<AddProductFormBloc>().add(
              RemoveProductImageEvent(index),
            ),
            child: const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.red,
              child: Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a picture'),
                  onTap: () {
                    context.read<ProductImageBloc>().add(PickFromCameraEvent());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Pick from gallery'),
                  onTap: () {
                    context.read<ProductImageBloc>().add(
                      PickFromGalleryEvent(),
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[400]!,
            style: BorderStyle.solid,
          ),
        ),
        child: const Icon(Icons.add_a_photo, size: 32, color: Colors.grey),
      ),
    );
  }

  Widget _buildProductNameSection(BuildContext context) => _reactiveTextField(
    context,
    label: 'Product Name',
    selector: (s) => s.productName,
    onChanged: (v) => UpdateProductNameEvent(v),
  );

  Widget _buildDescriptionSection(BuildContext context) => _reactiveTextField(
    context,
    label: 'Description',
    selector: (s) => s.description,
    onChanged: (v) => UpdateDescriptionEvent(v),
    maxLines: 4,
  );

  Widget _buildTagsSection(BuildContext context) => _reactiveTextField(
    context,
    label: 'Tags (comma separated)',
    selector: (s) => s.tags.join(', '),
    onChanged: (v) => UpdateTagsEvent(
      v.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
    ),
  );

  Widget _reactiveTextField(
    BuildContext context, {
    required String label,
    required String Function(AddProductFormUpdated) selector,
    required AddProductFormEvent Function(String) onChanged,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        BlocSelector<AddProductFormBloc, AddProductFormState, String>(
          selector: (state) =>
              state is AddProductFormUpdated ? selector(state) : '',
          builder: (context, value) {
            return TextFormField(
              initialValue: value,
              keyboardType: keyboardType,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: 'Enter $label',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) =>
                  context.read<AddProductFormBloc>().add(onChanged(v)),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection(BuildContext context) {
    return BlocSelector<AddProductFormBloc, AddProductFormState, bool>(
      selector: (s) => s is AddProductFormUpdated ? s.inStock : true,
      builder: (context, inStock) {
        return SwitchListTile(
          title: const Text('In Stock'),
          value: inStock,
          onChanged: (v) =>
              context.read<AddProductFormBloc>().add(UpdateInStockEvent(v)),
        );
      },
    );
  }

  Widget _buildConditionalDimensions(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    return BlocSelector<AddProductFormBloc, AddProductFormState, String>(
      selector: (s) => s is AddProductFormUpdated ? s.category : '',
      builder: (context, category) {
        if (category != 'electronics') return const SizedBox();
        return _buildDimensionsSection(context);
      },
    );
  }

  Widget _buildDimensionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dimensions & Weight',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: ['Weight (kg)', 'Length', 'Width', 'Height'].map((label) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _reactiveTextField(
                  context,
                  label: label,
                  selector: (s) {
                    switch (label) {
                      case 'Weight (kg)':
                        return s.weight.toString();
                      case 'Length':
                        return s.length.toString();
                      case 'Width':
                        return s.width.toString();
                      case 'Height':
                        return s.height.toString();
                      default:
                        return '';
                    }
                  },
                  onChanged: (v) {
                    final val = double.tryParse(v) ?? 0;
                    return UpdateDimensionsEvent(
                      weight: label.contains('Weight') ? val : null,
                      length: label.contains('Length') ? val : null,
                      width: label.contains('Width') ? val : null,
                      height: label.contains('Height') ? val : null,
                    );
                  },
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildVariantsSection(
    BuildContext context,
    BoxConstraints constraints,
    int index,
    Variant variant,
  ) {
    final imageBloc = context.read<ProductImageBloc>();
    return BlocSelector<AddProductFormBloc, AddProductFormState, List<Variant>>(
      selector: (s) => s is AddProductFormUpdated ? s.variants : [],
      builder: (context, variants) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                imageBloc.add(SetTargetVariantIndexEvent(index));

                _showImageSourceSheet(context);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: variant.image != null && variant.image!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        // Use the image path for preview
                        child: kIsWeb
                            ? Image.network(variant.image!, fit: BoxFit.cover)
                            : Image.file(
                                File(variant.image!),
                                fit: BoxFit.cover,
                              ),
                      )
                    : const Icon(
                        Icons.photo_size_select_actual,
                        size: 24,
                        color: Colors.grey,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Variants',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...variants.asMap().entries.map(
              (entry) => _buildVariantRow(context, entry.key, entry.value),
            ),
            _buildAddVariantField(context),
          ],
        );
      },
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a picture'),
              onTap: () {
                context.read<ProductImageBloc>().add(PickFromCameraEvent());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from gallery'),
              onTap: () {
                context.read<ProductImageBloc>().add(PickFromGalleryEvent());
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantRow(BuildContext context, int index, Variant variant) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text(
              variant.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: 100,
              child: TextFormField(
                initialValue: variant.regularPrice.toStringAsFixed(2),
                decoration: const InputDecoration(labelText: 'Price'),
                onChanged: (v) => context.read<AddProductFormBloc>().add(
                  UpdateVariantPriceEvent(
                    variantIndex: index,
                    regularPrice: double.tryParse(v) ?? 0,
                    salePrice: variant.salePrice,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: variant.quantity.toString(),
                decoration: const InputDecoration(labelText: 'Qty'),
                onChanged: (v) => context.read<AddProductFormBloc>().add(
                  UpdateVariantQuantityEvent(index, int.tryParse(v) ?? 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddVariantField(BuildContext context) {
    final controller = TextEditingController();
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'New variant (e.g., Red)',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.green),
          onPressed: () {
            if (controller.text.isNotEmpty) {
              context.read<AddProductFormBloc>().add(
                AddVariantEvent(controller.text),
              );
              controller.clear();
            }
          },
        ),
      ],
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return BlocSelector<AddProductFormBloc, AddProductFormState, String>(
      selector: (s) => (s as AddProductFormUpdated).category,
      builder: (context, selected) {
        return DropdownButtonFormField<String>(
          value: selected.isEmpty ? null : selected,
          hint: const Text('Select Category'),
          items: [
            'dress',
            'Drinks',
            'electronics',
            'accessories',
          ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (v) => v != null
              ? context.read<AddProductFormBloc>().add(UpdateCategoryEvent(v))
              : null,
        );
      },
    );
  }

  Widget _buildBrandSection(BuildContext context) {
    return BlocSelector<BrandBloc, BrandState, Brand?>(
      selector: (s) => s is LoadedBrand ? s.selectedBrand : null,
      builder: (context, brand) {
        return ListTile(
          title: Text(brand?.label ?? 'Select Brand'),
          trailing: const Icon(Icons.arrow_drop_down),
          onTap: () => _showBrandSelectionBottomSheet(context),
        );
      },
    );
  }

  void _showBrandSelectionBottomSheet(BuildContext context) {
    final brandBloc = context.read<BrandBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modelcontext) {
        return BlocProvider.value(
          value: brandBloc,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Brand',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: BlocBuilder<BrandBloc, BrandState>(
                    builder: (context, state) {
                      if (state is BrandLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is LoadedBrand) {
                        if (state.brands.isEmpty) {
                          return const Center(
                            child: Text('No brands available'),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: state.brands.length,
                          itemBuilder: (context, index) {
                            final brand = state.brands[index];
                            final isSelected =
                                state.selectedBrand?.label == brand.label;

                            return GestureDetector(
                              onTap: () {
                                context.read<BrandBloc>().add(
                                  SelectBrandEvent(brand),
                                );
                                Navigator.pop(context);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.green
                                            : Colors.grey.shade300,
                                        width: isSelected ? 3 : 1,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: brand.imageUrl ?? '',
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => const Icon(
                                          Icons.branding_watermark,
                                          size: 30,
                                        ),
                                        errorWidget: (_, __, ___) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    brand.label,
                                    style: const TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }

                      return const Center(child: Text('Something went wrong'));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context, BoxConstraints constraints) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, productState) {
        final loading = productState is ProductLoading;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: loading ? null : () => _submitProduct(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColoRs.background,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              loading ? 'Adding Product...' : 'Add Product',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );
      },
    );
  }

  void _submitProduct(BuildContext context) {
    final formState =
        context.read<AddProductFormBloc>().state as AddProductFormUpdated;
    final brandState = context.read<BrandBloc>().state as LoadedBrand;

    if (formState.productImages.length < 2 ||
        formState.productName.isEmpty ||
        brandState.selectedBrand == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final product = ProductEntity(
      mainCategoryId: mainCategoryId,
      subcategoryId: subcategoryId,
      name: formState.productName,
      description: formState.description,
      mainCategoryName: mainCategoryName,
      tags: formState.tags,
      length: formState.length,
      width: formState.width,
      height: formState.height,
      category: formState.category,
      filterTags: formState.filterTags,
      weight: formState.weight,
      inStock: formState.inStock,
      subcategoryName: subcategoryName,
      images: formState.productImages,
      variantDetails: formState.variants,
      brand: brandState.selectedBrand!.label,
    );

    context.read<ProductBloc>().add(
      AddProductEvent(product, mainCategoryId, subcategoryId),
    );
  }
}
