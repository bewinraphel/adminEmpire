import 'package:empire/feature/category/domain/entities/product_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class ProductEvent {}

class UpdateSkuEvent extends ProductEvent {
  final String sku;
  UpdateSkuEvent(this.sku);
}

class UpdateStockStatusEvent extends ProductEvent {
  final bool inStock;
  UpdateStockStatusEvent(this.inStock);
}

class UpdateQuantityEvent extends ProductEvent {
  final int quantity;
  UpdateQuantityEvent(this.quantity);
}

class UpdateWeightEvent extends ProductEvent {
  final double weight;
  UpdateWeightEvent(this.weight);
}

class UpdateLengthEvent extends ProductEvent {
  final double length;
  UpdateLengthEvent(this.length);
}

class UpdateWidthEvent extends ProductEvent {
  final double width;
  UpdateWidthEvent(this.width);
}

class UpdateHeightEvent extends ProductEvent {
  final double height;
  UpdateHeightEvent(this.height);
}

class UpdateTagsEvent extends ProductEvent {
  final List<String> tags;
  UpdateTagsEvent(this.tags);
}

class UpdateTaxRateEvent extends ProductEvent {
  final double taxRate;
  UpdateTaxRateEvent(this.taxRate);
}

class UpdateVariantsEvent extends ProductEvent {
  final List<String> variants;
  UpdateVariantsEvent(this.variants);
}

class UpdatePriceMinEvent extends ProductEvent {
  final double priceMin;
  UpdatePriceMinEvent(this.priceMin);
}

class UpdatePriceMaxEvent extends ProductEvent {
  final double priceMax;
  UpdatePriceMaxEvent(this.priceMax);
}

class UpdateFilterTagsEvent extends ProductEvent {
  final List<String> filterTags;
  UpdateFilterTagsEvent(this.filterTags);
}

class UpdateTimestampEvent extends ProductEvent {
  final DateTime? timestamp;
  UpdateTimestampEvent(this.timestamp);
}

class SaveProductEvent extends ProductEvent {}

// BLoC State
class ProductState {
  final ProductEntity product;
  final bool isValid;

  ProductState({required this.product, this.isValid = false});

  ProductState copyWith({ProductEntity? product, bool? isValid}) {
    return ProductState(
      product: product ?? this.product,
      isValid: isValid ?? this.isValid,
    );
  }
}

// BLoC
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(ProductEntity initialProduct)
    : super(ProductState(product: initialProduct)) {
    on<UpdateSkuEvent>((event, emit) {
      emit(state.copyWith(product: state.product.copyWith(sku: event.sku)));
    });
    on<UpdateStockStatusEvent>((event, emit) {
      emit(
        state.copyWith(product: state.product.copyWith(inStock: event.inStock)),
      );
    });
    on<UpdateQuantityEvent>((event, emit) {
      emit(
        state.copyWith(
          product: state.product.copyWith(
            quantities: {
              ?state.product.variants.isNotEmpty
                      ? state.product.variants.first
                      : 'default':
                  event.quantity,
            },
          ),
        ),
      );
    });
    on<UpdateWeightEvent>((event, emit) {
      emit(
        state.copyWith(product: state.product.copyWith(weight: event.weight)),
      );
    });
    on<UpdateLengthEvent>((event, emit) {
      emit(
        state.copyWith(product: state.product.copyWith(length: event.length)),
      );
    });
    on<UpdateWidthEvent>((event, emit) {
      emit(state.copyWith(product: state.product.copyWith(width: event.width)));
    });
    on<UpdateHeightEvent>((event, emit) {
      emit(
        state.copyWith(product: state.product.copyWith(height: event.height)),
      );
    });
    on<UpdateTagsEvent>((event, emit) {
      emit(state.copyWith(product: state.product.copyWith(tags: event.tags)));
    });
    on<UpdateTaxRateEvent>((event, emit) {
      emit(
        state.copyWith(product: state.product.copyWith(taxRate: event.taxRate)),
      );
    });
    on<UpdateVariantsEvent>((event, emit) {
      emit(
        state.copyWith(
          product: state.product.copyWith(variants: event.variants),
        ),
      );
    });
    on<UpdatePriceMinEvent>((event, emit) {
      emit(
        state.copyWith(
          product: state.product.copyWith(priceRangeMin: event.priceMin),
        ),
      );
    });
    on<UpdatePriceMaxEvent>((event, emit) {
      emit(
        state.copyWith(
          product: state.product.copyWith(priceRangeMax: event.priceMax),
        ),
      );
    });
    on<UpdateFilterTagsEvent>((event, emit) {
      emit(
        state.copyWith(
          product: state.product.copyWith(filterTags: event.filterTags),
        ),
      );
    });
    on<UpdateTimestampEvent>((event, emit) {
      emit(
        state.copyWith(
          product: state.product.copyWith(timestamp: event.timestamp),
        ),
      );
    });
    on<SaveProductEvent>((event, emit) {
      bool isValid =
          state.product.sku.isNotEmpty &&
          state.product.quantities.values.every((q) => q > 0) &&
          state.product.weight > 0 &&
          state.product.length > 0 &&
          state.product.width > 0 &&
          state.product.height > 0 &&
          state.product.taxRate >= 0 &&
          state.product.priceRangeMin >= 0 &&
          state.product.priceRangeMax >= state.product.priceRangeMin;
      emit(state.copyWith(isValid: isValid));
    });
  }
}

class ProductDetailsPage extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(product),
      child: const ProductDetailsView(),
    );
  }
}

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  _ProductDetailsViewState createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _skuController;
  late TextEditingController _quantityController;
  late TextEditingController _weightController;
  late TextEditingController _lengthController;
  late TextEditingController _widthController;
  late TextEditingController _heightController;
  late TextEditingController _tagsController;
  late TextEditingController _taxRateController;
  late TextEditingController _variantsController;
  late TextEditingController _priceMinController;
  late TextEditingController _priceMaxController;
  late TextEditingController _filterTagsController;
  late TextEditingController _timestampController;
  late String _stockStatus;
  int _currentImageIndex = 0;
  String _selectedSize = 'XL';

  @override
  void initState() {
    super.initState();
    final product = context.read<ProductBloc>().state.product;
    _skuController = TextEditingController(text: product.sku);
    _quantityController = TextEditingController(
      text: product.quantities.values
          .fold(0, (sum, qty) => sum + qty)
          .toString(),
    );
    _weightController = TextEditingController(text: product.weight.toString());
    _lengthController = TextEditingController(text: product.length.toString());
    _widthController = TextEditingController(text: product.width.toString());
    _heightController = TextEditingController(text: product.height.toString());
    _tagsController = TextEditingController(text: product.tags.join(', '));
    _taxRateController = TextEditingController(
      text: product.taxRate.toString(),
    );
    _variantsController = TextEditingController(
      text: product.variants.join(', '),
    );
    _priceMinController = TextEditingController(
      text: product.priceRangeMin.toString(),
    );
    _priceMaxController = TextEditingController(
      text: product.priceRangeMax.toString(),
    );
    _filterTagsController = TextEditingController(
      text: product.filterTags.join(', '),
    );
    _timestampController = TextEditingController(
      text: product.timestamp != null
          ? product.timestamp!.toIso8601String()
          : '',
    );
    _stockStatus = product.inStock ? 'In Stock' : 'Out of Stock';
  }

  @override
  void dispose() {
    _skuController.dispose();
    _quantityController.dispose();
    _weightController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _tagsController.dispose();
    _taxRateController.dispose();
    _variantsController.dispose();
    _priceMinController.dispose();
    _priceMaxController.dispose();
    _filterTagsController.dispose();
    _timestampController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          context.read<ProductBloc>().state.product.timestamp ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          context.read<ProductBloc>().state.product.timestamp ?? DateTime.now(),
        ),
      );
      if (pickedTime != null && context.mounted) {
        final DateTime combined = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _timestampController.text = combined.toIso8601String();
        context.read<ProductBloc>().add(UpdateTimestampEvent(combined));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final product = state.product;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Details',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  // Implement more options functionality
                },
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        itemCount: product.images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            product.images[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                          );
                        },
                      ),
                      const Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black54],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // Implement favorite functionality
                          },
                        ).animate().scale(),
                      ),
                    ],
                  ),
                ),
                pinned: true,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnails
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(product.images.length, (
                            index,
                          ) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentImageIndex = index;
                                });
                                // Optionally, control PageView to sync
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                child:
                                    Image.network(
                                      product.images[index],
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                color: Colors.grey[200],
                                                child: const Icon(
                                                  Icons.broken_image,
                                                  size: 30,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                    ).animate().fadeIn(
                                      delay: Duration(
                                        milliseconds: 200 * index,
                                      ),
                                    ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Product Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ).animate().slideY(begin: 0.2, end: 0, duration: 400.ms),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color(0xFFFBBF24),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${product.rating.toStringAsFixed(1)} Ratings',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '2.3k+ Reviews',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '2.9k+ Sold',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 200.ms),
                      const SizedBox(height: 16),
                      // Size Selection
                      Text(
                        'Size:',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: ['S', 'M', 'L', 'XL'].map((size) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedSize = size;
                                });
                                context.read<ProductBloc>().add(
                                  UpdateVariantsEvent([size]),
                                );
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: _selectedSize == size
                                      ? const Color(0xFF2DD4BF)
                                      : Colors.white,
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    size,
                                    style: GoogleFonts.roboto(
                                      color: _selectedSize == size
                                          ? Colors.white
                                          : Colors.grey[500],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ).animate().slideX(begin: -0.2, end: 0, duration: 400.ms),
                      const SizedBox(height: 24),
                      // Form Sections
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Description
                            ExpansionTile(
                              title: Text(
                                'Description',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  child: Text(
                                    product.description,
                                    style: GoogleFonts.roboto(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Toggle description visibility if needed
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'See less',
                                        style: GoogleFonts.roboto(
                                          color: const Color(0xFF2DD4BF),
                                          fontSize: 14,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.expand_less,
                                        color: Color(0xFF2DD4BF),
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Inventory & Shipping
                            ExpansionTile(
                              title: Text(
                                'Inventory & Shipping',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  child: Column(
                                    children: [
                                      _buildTextField(
                                        label: 'SKU',
                                        controller: _skuController,
                                        validator: (value) => value!.isEmpty
                                            ? 'SKU is required'
                                            : null,
                                        onChanged: (value) => context
                                            .read<ProductBloc>()
                                            .add(UpdateSkuEvent(value)),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildDropdownField(
                                              label: 'Stock Status',
                                              items: [
                                                'In Stock',
                                                'Out of Stock',
                                              ],
                                              value: _stockStatus,
                                              onChanged: (value) {
                                                setState(() {
                                                  _stockStatus = value!;
                                                });
                                                context.read<ProductBloc>().add(
                                                  UpdateStockStatusEvent(
                                                    value == 'In Stock',
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: _buildTextField(
                                              label: 'Quantity',
                                              controller: _quantityController,
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) =>
                                                  value!.isEmpty ||
                                                      int.tryParse(value) ==
                                                          null
                                                  ? 'Enter a valid number'
                                                  : null,
                                              onChanged: (value) => context
                                                  .read<ProductBloc>()
                                                  .add(
                                                    UpdateQuantityEvent(
                                                      int.tryParse(value) ?? 0,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      _buildTextField(
                                        label: 'Weight (lbs)',
                                        controller: _weightController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) =>
                                            value!.isEmpty ||
                                                double.tryParse(value) == null
                                            ? 'Enter a valid number'
                                            : null,
                                        onChanged: (value) =>
                                            context.read<ProductBloc>().add(
                                              UpdateWeightEvent(
                                                double.tryParse(value) ?? 0.0,
                                              ),
                                            ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildTextField(
                                              label: 'L (in)',
                                              controller: _lengthController,
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) =>
                                                  value!.isEmpty ||
                                                      double.tryParse(value) ==
                                                          null
                                                  ? 'Enter a valid number'
                                                  : null,
                                              onChanged: (value) => context
                                                  .read<ProductBloc>()
                                                  .add(
                                                    UpdateLengthEvent(
                                                      double.tryParse(value) ??
                                                          0.0,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: _buildTextField(
                                              label: 'W (in)',
                                              controller: _widthController,
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) =>
                                                  value!.isEmpty ||
                                                      double.tryParse(value) ==
                                                          null
                                                  ? 'Enter a valid number'
                                                  : null,
                                              onChanged: (value) => context
                                                  .read<ProductBloc>()
                                                  .add(
                                                    UpdateWidthEvent(
                                                      double.tryParse(value) ??
                                                          0.0,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      _buildTextField(
                                        label: 'H (in)',
                                        controller: _heightController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) =>
                                            value!.isEmpty ||
                                                double.tryParse(value) == null
                                            ? 'Enter a valid number'
                                            : null,
                                        onChanged: (value) =>
                                            context.read<ProductBloc>().add(
                                              UpdateHeightEvent(
                                                double.tryParse(value) ?? 0.0,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Details & Variants
                            ExpansionTile(
                              title: Text(
                                'Details & Variants',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  child: Column(
                                    children: [
                                      _buildTextField(
                                        label: 'Tags',
                                        controller: _tagsController,
                                        hintText: 'e.g. shoes, summer, sale',
                                        onChanged: (value) =>
                                            context.read<ProductBloc>().add(
                                              UpdateTagsEvent(
                                                value
                                                    .split(', ')
                                                    .where((e) => e.isNotEmpty)
                                                    .toList(),
                                              ),
                                            ),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildTextField(
                                        label: 'Tax Rate (%)',
                                        controller: _taxRateController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) =>
                                            value!.isEmpty ||
                                                double.tryParse(value) == null
                                            ? 'Enter a valid number'
                                            : null,
                                        onChanged: (value) =>
                                            context.read<ProductBloc>().add(
                                              UpdateTaxRateEvent(
                                                double.tryParse(value) ?? 0.0,
                                              ),
                                            ),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildTextField(
                                        label: 'Variants',
                                        controller: _variantsController,
                                        hintText: 'e.g. Small, Medium, Large',
                                        onChanged: (value) =>
                                            context.read<ProductBloc>().add(
                                              UpdateVariantsEvent(
                                                value
                                                    .split(', ')
                                                    .where((e) => e.isNotEmpty)
                                                    .toList(),
                                              ),
                                            ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildTextField(
                                              label: 'Price Min',
                                              controller: _priceMinController,
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) =>
                                                  value!.isEmpty ||
                                                      double.tryParse(value) ==
                                                          null
                                                  ? 'Enter a valid number'
                                                  : null,
                                              onChanged: (value) => context
                                                  .read<ProductBloc>()
                                                  .add(
                                                    UpdatePriceMinEvent(
                                                      double.tryParse(value) ??
                                                          0.0,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: _buildTextField(
                                              label: 'Price Max',
                                              controller: _priceMaxController,
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) =>
                                                  value!.isEmpty ||
                                                      double.tryParse(value) ==
                                                          null
                                                  ? 'Enter a valid number'
                                                  : null,
                                              onChanged: (value) => context
                                                  .read<ProductBloc>()
                                                  .add(
                                                    UpdatePriceMaxEvent(
                                                      double.tryParse(value) ??
                                                          0.0,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      _buildTextField(
                                        label: 'Filter Tags',
                                        controller: _filterTagsController,
                                        hintText: 'e.g. featured, new-arrival',
                                        onChanged: (value) =>
                                            context.read<ProductBloc>().add(
                                              UpdateFilterTagsEvent(
                                                value
                                                    .split(', ')
                                                    .where((e) => e.isNotEmpty)
                                                    .toList(),
                                              ),
                                            ),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildDateTimeField(context),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Reviews & Ratings
                            ExpansionTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Reviews & Ratings',
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Navigate to full reviews
                                    },
                                    child: Text(
                                      'See all',
                                      style: GoogleFonts.roboto(
                                        color: const Color(0xFF2DD4BF),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '4.9/5.0',
                                              style: GoogleFonts.roboto(
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              children: List.generate(5, (
                                                index,
                                              ) {
                                                return Icon(
                                                  index < 4
                                                      ? Icons.star
                                                      : Icons.star_half,
                                                  color: const Color(
                                                    0xFFFBBF24,
                                                  ),
                                                  size: 16,
                                                );
                                              }),
                                            ),
                                            Text(
                                              '2.3k+ Reviews',
                                              style: GoogleFonts.roboto(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            _buildReviewBar(5, 80, 1500),
                                            _buildReviewBar(4, 30, 710),
                                            _buildReviewBar(3, 10, 140),
                                            _buildReviewBar(2, 5, 10),
                                            _buildReviewBar(1, 2, 4),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Reviews with Images & Videos
                            ExpansionTile(
                              title: Text(
                                'Reviews with Images & Videos',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ...product.images.map(
                                          (image) => Container(
                                            margin: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            child: Image.network(
                                              image,
                                              width: 96,
                                              height: 96,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Container(
                                                    color: Colors.grey[200],
                                                    child: const Icon(
                                                      Icons.broken_image,
                                                      size: 30,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 96,
                                          height: 96,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[800],
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '132+',
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<ProductBloc>().add(SaveProductEvent());
                final isValid = context.read<ProductBloc>().state.isValid;
                if (isValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Product saved: ${product.name}')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please fill all required fields correctly',
                      ),
                    ),
                  );
                }
              }
            },
            label: Text(
              'Save Changes',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            icon: const Icon(Icons.save),
            backgroundColor: const Color(0xFF2DD4BF),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.roboto(color: Colors.grey[400]),
            border: const UnderlineInputBorder(),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF2DD4BF)),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          style: GoogleFonts.roboto(),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: GoogleFonts.roboto()),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF2DD4BF)),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          style: GoogleFonts.roboto(),
        ),
      ],
    );
  }

  Widget _buildDateTimeField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Timestamp',
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => _selectDateTime(context),
          child: AbsorbPointer(
            child: TextFormField(
              controller: _timestampController,
              decoration: const InputDecoration(
                hintText: 'Select date and time',
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2DD4BF)),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                suffixIcon: Icon(
                  Icons.calendar_today,
                  color: Color(0xFF2DD4BF),
                ),
              ),
              style: GoogleFonts.roboto(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewBar(int rating, double percentage, int count) {
    return Row(
      children: [
        const Icon(Icons.star, color: Color(0xFFFBBF24), size: 14),
        const SizedBox(width: 4),
        Text('$rating', style: GoogleFonts.roboto(fontSize: 12)),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Container(
                height: 6,
                width: MediaQuery.of(context).size.width * percentage / 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF2DD4BF),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$count',
          style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }
}
