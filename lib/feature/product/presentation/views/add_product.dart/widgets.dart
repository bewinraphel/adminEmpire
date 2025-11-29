import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire/core/utilis/app_strings.dart';
import 'package:empire/core/utilis/constants.dart';
import 'package:empire/core/utilis/layout_constants.dart';
import 'package:empire/core/utilis/validation_error.dart';
import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/presentation/bloc/add_product_form_bloc/add_product_form_event.dart';
import 'package:empire/feature/product/presentation/bloc/add_product_form_bloc/add_product_form_bloc.dart';
import 'package:empire/feature/product/presentation/bloc/add_product_form_bloc/add_product_form_state.dart';
import 'package:empire/feature/product/presentation/bloc/varient_image_bloc.dart/vareint_Image_bloc.dart';
import 'package:empire/feature/product/presentation/bloc/brand.dart';
import 'package:empire/feature/product/presentation/bloc/product_image.dart';
import 'package:empire/feature/product/presentation/bloc/varient_image_bloc.dart/vareint_image_event.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class InputFieldNew extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  const InputFieldNew({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: const Duration(milliseconds: 200),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
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
            child: SizedBox(
              height: 50.0,
              child: Center(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  validator: validator,
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Titlesnew extends StatelessWidget {
  final String nametitle;

  const Titlesnew({super.key, required this.nametitle});

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 150),
      child: SlideAnimation(
        horizontalOffset: -50.0,
        child: FadeInAnimation(
          child: Text(
            nametitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class GradientButtonNew extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final double? height;
  final double? width;

  const GradientButtonNew({
    super.key,
    required this.text,
    required this.onTap,
    this.height,
    this.width,
  });

  @override
  State<GradientButtonNew> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButtonNew>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap!();
      },
      onTapCancel: () => _controller.reverse(),
      child: ZoomIn(
        duration: const Duration(milliseconds: 200),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 103, 206, 34),
                  Color.fromARGB(255, 29, 161, 88),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(4, 4),
                  blurRadius: 8,
                ),
                BoxShadow(
                  color: Colors.white24,
                  offset: Offset(-4, -4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InStock extends StatelessWidget {
  final ValueNotifier<bool> isInStock;

  const InStock({super.key, required this.isInStock});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isInStock,
      builder: (context, value, child) {
        return Container(
          decoration: kCardDecoration,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('In Stock', style: TextStyle(color: Colors.black87)),
              Switch(
                value: value,
                onChanged: (newValue) => isInStock.value = newValue,
                activeColor: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }
}

AppBar appbar() {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: BounceInDown(
      duration: const Duration(milliseconds: 600),
      child: const Text(
        'Add Product',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          shadows: [
            Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
      ),
    ),
    centerTitle: true,
  );
}

class ValidatedTextField extends StatefulWidget {
  final String label;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final ValidationError? error;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? hintText;

  const ValidatedTextField({
    super.key,
    required this.label,
    this.initialValue,
    required this.onChanged,
    this.error,
    this.keyboardType,
    this.maxLines = 1,
    this.hintText,
  });

  @override
  State<ValidatedTextField> createState() => _ValidatedTextFieldState();
}

class _ValidatedTextFieldState extends State<ValidatedTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(ValidatedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Enter ${widget.label}',
            filled: true,
            fillColor: Colors.grey[100],
            errorText: widget.error?.message,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.error != null ? Colors.red : Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.error != null ? Colors.red : Colors.blue,
                width: 2,
              ),
            ),
          ),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}

class ProductNameField extends StatelessWidget {
  const ProductNameField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      AddProductFormBloc,
      AddProductFormState,
      ({String name, ValidationError? error})
    >(
      selector: (state) => (
        name: state.productName,
        error: state.validationResult.getError('productName'),
      ),
      builder: (context, data) {
        return ValidatedTextField(
          label: AppStrings.productName,
          initialValue: data.name,
          error: data.error,
          onChanged: (value) {
            context.read<AddProductFormBloc>().add(
              UpdateProductNameEvent(value),
            );
          },
        );
      },
    );
  }
}

class ProductDescriptionField extends StatelessWidget {
  const ProductDescriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      AddProductFormBloc,
      AddProductFormState,
      ({String desc, ValidationError? error})
    >(
      selector: (state) => (
        desc: state.description,
        error: state.validationResult.getError('description'),
      ),
      builder: (context, data) {
        return ValidatedTextField(
          label: AppStrings.description,
          initialValue: data.desc,
          error: data.error,
          maxLines: 4,
          onChanged: (value) {
            context.read<AddProductFormBloc>().add(
              UpdateDescriptionEvent(value),
            );
          },
        );
      },
    );
  }
}

class ProductTagsField extends StatelessWidget {
  const ProductTagsField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddProductFormBloc, AddProductFormState, String>(
      selector: (state) => state.tags.join(', '),
      builder: (context, tagsString) {
        return ValidatedTextField(
          label: AppStrings.tags,
          initialValue: tagsString,
          onChanged: (value) {
            final tags = value
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
            context.read<AddProductFormBloc>().add(UpdateTagsEvent(tags));
          },
        );
      },
    );
  }
}

// Product Availability Switch
class ProductAvailabilitySwitch extends StatelessWidget {
  const ProductAvailabilitySwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddProductFormBloc, AddProductFormState, bool>(
      selector: (state) => state.inStock,
      builder: (context, inStock) {
        return SwitchListTile(
          title: const Text(AppStrings.inStock),
          value: inStock,
          onChanged: (value) {
            context.read<AddProductFormBloc>().add(UpdateInStockEvent(value));
          },
        );
      },
    );
  }
}

// Product Category Dropdown
class ProductCategoryDropdown extends StatelessWidget {
  static const List<String> categories = [
    'dress',
    'Drinks',
    'electronics',
    'accessories',
  ];

  const ProductCategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      AddProductFormBloc,
      AddProductFormState,
      ({String category, ValidationError? error})
    >(
      selector: (state) => (
        category: state.category,
        error: state.validationResult.getError('category'),
      ),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: data.category.isEmpty ? null : data.category,
              hint: const Text(AppStrings.selectCategory),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                errorText: data.error?.message,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<AddProductFormBloc>().add(
                    UpdateCategoryEvent(value),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// PART 10: PRESENTATION LAYER - IMAGE SECTION
// ============================================================================

class ProductImagesSection extends StatelessWidget {
  const ProductImagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.productImages,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        BlocSelector<
          AddProductFormBloc,
          AddProductFormState,
          ({List<dynamic> images, ValidationError? error})
        >(
          selector: (state) => (
            images: state.productImages,
            error: state.validationResult.getError('images'),
          ),
          builder: (context, data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: LayoutConstants.productImageGridCount,
                    crossAxisSpacing: LayoutConstants.productImageGridSpacing,
                    mainAxisSpacing: LayoutConstants.productImageGridSpacing,
                    childAspectRatio: 1,
                  ),
                  itemCount: data.images.length + 1,
                  itemBuilder: (context, index) {
                    if (index == data.images.length) {
                      return const AddImageButton();
                    }
                    return ImageTile(
                      imagePath: data.images[index],
                      index: index,
                    );
                  },
                ),
                if (data.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      data.error!.message,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class ImageTile extends StatelessWidget {
  final dynamic imagePath;
  final int index;

  const ImageTile({super.key, required this.imagePath, required this.index});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildImagePreview(),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              context.read<AddProductFormBloc>().add(
                RemoveProductImageEvent(index),
              );
            },
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

  Widget _buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (imagePath is Uint8List) {
      return Image.memory(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    }
    if (imagePath.image == null) {
      return const Center(
        child: Icon(Icons.add_photo_alternate, size: 32, color: Colors.grey),
      );
    }

    // Handle Uint8List (Web)
    if (imagePath.image!.bytes != null) {
      return Image.memory(
        imagePath.image!.bytes!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    }

    // Handle URL
    if (imagePath.image!.webUrl != null) {
      return Image.network(
        imagePath.image!.webUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    }

    // Handle File Path (Mobile)
    if (imagePath.image!.filePath != null) {
      if (kIsWeb) {
        // On web, treat as network image
        return Image.network(
          imagePath.image!.filePath!,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget();
          },
        );
      } else {
        // On mobile, use file
        return Image.file(
          File(imagePath.image!.filePath!),
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget();
          },
        );
      }
    }

    return _buildErrorWidget();
  }

  Widget _buildErrorWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red, size: 24),
          SizedBox(height: 4),
          Text(
            'Failed to load',
            style: TextStyle(fontSize: 10, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class AddImageButton extends StatelessWidget {
  const AddImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageSourceSheet(context),
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

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text(AppStrings.takePhoto),
              onTap: () {
                context.read<ProductImageBloc>().add(
                  const PickFromCameraEvent(),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text(AppStrings.pickFromGallery),
              onTap: () {
                context.read<ProductImageBloc>().add(
                  const PickFromGalleryEvent(),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// PART 11: PRESENTATION LAYER - DIMENSIONS SECTION
// ============================================================================
class ConditionalDimensionsSection extends StatelessWidget {
  const ConditionalDimensionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddProductFormBloc, AddProductFormState, String>(
      selector: (state) => state.category,
      builder: (context, category) {
        if (category.toLowerCase() != 'electronics') {
          return const SizedBox.shrink();
        }
        return const DimensionsSection();
      },
    );
  }
}

class DimensionsSection extends StatelessWidget {
  const DimensionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      AddProductFormBloc,
      AddProductFormState,
      ({double weight, double length, double width, double height})
    >(
      selector: (state) => (
        weight: state.weight,
        length: state.length,
        width: state.width,
        height: state.height,
      ),
      builder: (context, dimensions) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.dimensionsWeight,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DimensionField(
                    label: 'Weight (kg)',
                    value: dimensions.weight,
                    onChanged: (value) {
                      context.read<AddProductFormBloc>().add(
                        UpdateDimensionsEvent(weight: value),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DimensionField(
                    label: 'Length',
                    value: dimensions.length,
                    onChanged: (value) {
                      context.read<AddProductFormBloc>().add(
                        UpdateDimensionsEvent(length: value),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DimensionField(
                    label: 'Width',
                    value: dimensions.width,
                    onChanged: (value) {
                      context.read<AddProductFormBloc>().add(
                        UpdateDimensionsEvent(width: value),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DimensionField(
                    label: 'Height',
                    value: dimensions.height,
                    onChanged: (value) {
                      context.read<AddProductFormBloc>().add(
                        UpdateDimensionsEvent(height: value),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class DimensionField extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const DimensionField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValidatedTextField(
      label: label,
      initialValue: value == 0.0 ? '' : value.toString(),
      onChanged: (v) => onChanged(double.tryParse(v) ?? 0.0),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }
}

class ProductVariantsSection extends StatelessWidget {
  const ProductVariantsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddProductFormBloc, AddProductFormState, List<Variant>>(
      selector: (state) => state.variants,
      builder: (context, variants) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.variants,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...variants.asMap().entries.map(
              (entry) => VariantRow(variant: entry.value, index: entry.key),
            ),
            const SizedBox(height: 12),
            const AddVariantField(),
          ],
        );
      },
    );
  }
}

class VariantRow extends StatelessWidget {
  final Variant variant;
  final int index;

  const VariantRow({super.key, required this.variant, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                _showImageSourceSheet(context, index);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: variant.imageweb != null && variant.imageweb!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildImage(variant),
                      )
                    : const Icon(
                        Icons.photo_size_select_actual,
                        size: 24,
                        color: Colors.grey,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              variant.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: 100,
              child: TextFormField(
                initialValue: variant.regularPrice == 0.0
                    ? ''
                    : variant.regularPrice.toStringAsFixed(2),
                decoration: const InputDecoration(
                  labelText: 'Price',
                  isDense: true,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (v) {
                  context.read<AddProductFormBloc>().add(
                    UpdateVariantPriceEvent(
                      variantIndex: index,
                      regularPrice: double.tryParse(v) ?? 0,
                      salePrice: variant.salePrice,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: variant.quantity == 0
                    ? ''
                    : variant.quantity.toString(),
                decoration: const InputDecoration(
                  labelText: 'Qty',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) {
                  context.read<AddProductFormBloc>().add(
                    UpdateVariantQuantityEvent(index, int.tryParse(v) ?? 0),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(Variant variant) {
    if (variant.imageweb != null) {
      // Handle Uint8List (Mobile)
      if (variant.imageweb is Uint8List) {
        return Image.memory(
          variant.imageweb!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
        );
      }
      // Handle Uint8List (Web)
      if (variant.imageweb != null) {
        return Image.memory(
          variant.imageweb!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget();
          },
        );
      }
    } else if (variant.image != null) {
      /////////
      if (variant.image == null) {
        return const Center(
          child: Icon(Icons.add_photo_alternate, size: 32, color: Colors.grey),
        );
      }

      // Handle File Path (Mobile)
      if (variant.image!.filePath != null) {
        if (kIsWeb) {
          // On web, treat as network image
          return Image.network(
            variant.image!.filePath!,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return _buildErrorWidget();
            },
          );
        } else {
          // On mobile, use file
          return Image.file(
            File(variant.image!.filePath!),
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return _buildErrorWidget();
            },
          );
        }
      }
    }

    return _buildErrorWidget();
  }

  Widget _buildErrorWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red, size: 24),
          SizedBox(height: 4),
          Text(
            'Failed to load',
            style: TextStyle(fontSize: 10, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

void _showImageSourceSheet(BuildContext context, int index) {
  showModalBottomSheet(
    context: context,
    builder: (_) => SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text(AppStrings.takePhoto),
            onTap: () {
              context.read<VariantImageBloc>().add(
                PickImageFromCameraForVariantEvent(index),
              );
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text(AppStrings.pickFromGallery),
            onTap: () {
              context.read<VariantImageBloc>().add(
                PickImageFromGalleryForVariantEvent(index),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}

class AddVariantField extends StatefulWidget {
  const AddVariantField({super.key});

  @override
  State<AddVariantField> createState() => _AddVariantFieldState();
}

class _AddVariantFieldState extends State<AddVariantField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'New variant (e.g., Red)',
              filled: true,
              fillColor: Colors.grey,
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.green),
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              context.read<AddProductFormBloc>().add(
                AddVariantEvent(_controller.text),
              );
              _controller.clear();
            }
          },
        ),
      ],
    );
  }
}

// ============================================================================
// PART 13: PRESENTATION LAYER - BRAND SECTION
// ============================================================================
class ProductBrandSection extends StatelessWidget {
  const ProductBrandSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddProductFormBloc, AddProductFormState>(
      builder: (context, formState) {
        final brandError = formState.validationResult.getError('brand');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocSelector<BrandBloc, BrandState, Brand?>(
              selector: (state) =>
                  state is LoadedBrand ? state.selectedBrand : null,
              builder: (context, brand) {
                return ListTile(
                  title: Text(brand?.label ?? AppStrings.selectBrand),
                  trailing: const Icon(Icons.arrow_drop_down),
                  tileColor: brandError != null ? Colors.red[50] : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: brandError != null
                          ? Colors.red
                          : Colors.grey[300]!,
                    ),
                  ),
                  onTap: () => _showBrandSelectionBottomSheet(context),
                );
              },
            ),
            if (brandError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 16),
                child: Text(
                  brandError.message,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
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
      builder: (modalContext) {
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
                        onPressed: () => Navigator.pop(modalContext),
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
                                Navigator.pop(modalContext);
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
}

// ============================================================================
// PART 14: PRESENTATION LAYER - SUBMIT BUTTON
// ============================================================================
class SubmitProductButton extends StatelessWidget {
  final String mainCategoryId;
  final String subcategoryId;
  final String mainCategoryName;
  final String subcategoryName;

  const SubmitProductButton({
    super.key,
    required this.mainCategoryId,
    required this.subcategoryId,
    required this.mainCategoryName,
    required this.subcategoryName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddProductFormBloc, AddProductFormState>(
      builder: (context, state) {
        final isLoading = state.isSubmitting;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : () => _onSubmit(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isLoading
                  ? AppStrings.addingProduct
                  : AppStrings.addProductButton,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void _onSubmit(BuildContext context) {
    final brandState = context.read<BrandBloc>().state;
    final selectedBrand = brandState is LoadedBrand
        ? brandState.selectedBrand
        : null;

    context.read<AddProductFormBloc>().add(
      SubmitFormEvent(
        mainCategoryId: mainCategoryId,
        subcategoryId: subcategoryId,
        mainCategoryName: mainCategoryName,
        subcategoryName: subcategoryName,
        selectedBrandLabel: selectedBrand?.label,
      ),
    );
  }
}
