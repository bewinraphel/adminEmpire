import 'dart:io';

import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/commonvalidator.dart';

import 'package:empire/core/utilis/widgets.dart';

import 'package:empire/feature/category/data/datasource/product_data_source.dart';
import 'package:empire/feature/category/data/repository/product_respository.dart';
import 'package:empire/feature/category/domain/entities/product_entities.dart';
import 'package:empire/feature/category/domain/usecase/product/product_usecae.dart';
import 'package:empire/feature/auth/presentation/bloc/profile_image_bloc.dart';
import 'package:empire/feature/category/presentation/bloc/product_bloc/product.dart';
import 'package:empire/feature/category/presentation/views/add_product.dart/widgets.dart';
import 'package:empire/feature/category/presentation/views/homepage/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:animate_do/animate_do.dart';

ValueNotifier<String?> image2 = ValueNotifier(null);
ValueNotifier<String?> image3 = ValueNotifier(null);
ValueNotifier<String?> previewImage = ValueNotifier(null);

class AddProdutsPage extends StatefulWidget {
  String? mainCategoryId;
  String? id;
  AddProdutsPage({super.key, this.id, this.mainCategoryId});

  @override
  State<AddProdutsPage> createState() => _AddProdutsPageState();
}

class _AddProdutsPageState extends State<AddProdutsPage> {
  final globalKey = GlobalKey<FormState>();
  final categoryKey = GlobalKey<FormState>();
  final variantKey = GlobalKey<FormState>();

  final productName = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final discountPrice = TextEditingController();
  final sku = TextEditingController();
  final tags = TextEditingController();
  final weight = TextEditingController();
  final length = TextEditingController();
  final width = TextEditingController();
  final height = TextEditingController();
  final taxRate = TextEditingController();
  final priceRangeMin = TextEditingController();
  final priceRangeMax = TextEditingController();
  final categoryController = TextEditingController();
  final variantName = TextEditingController();
  final List<String> filterTags = [];

  final ValueNotifier<bool> isInStock = ValueNotifier(true);
  final ValueNotifier<String> selectedCategory = ValueNotifier('');
  final ValueNotifier<double> ratingValue = ValueNotifier(0.0);
  final images = List.generate(3, (dynamic index) => 'null', growable: true);

  String? image4;
  List<String> categoryList = ['dress', 'food', 'electronics', 'accessories'];
  ValueNotifier<List<String>> variants = ValueNotifier([]);

  Map<String, int> variantQuantities = {};

  void _updateVariants() {
    if (selectedCategory.value == 'dress') {
      variants.value = ['S', 'M', 'L', 'XL'];
    } else if (selectedCategory.value == 'food') {
      variants.value = ['200ml', '1l', '500g', '1kg'];
    } else if (selectedCategory.value == 'electronics') {
      variants.value = ['black', 'silver', 'white'];
    } else if (selectedCategory.value == 'accessories') {
      variants.value = ['small', 'large'];
    } else {
      variants.value = [];
    }
    variantQuantities = {for (var v in variants.value) v: 0};
  }

  @override
  void dispose() {
    // productName.dispose();
    // description.dispose();
    // price.dispose();
    // discountPrice.dispose();
    // sku.dispose();
    // tags.dispose();
    // weight.dispose();
    // length.dispose();
    // width.dispose();
    // height.dispose();
    // taxRate.dispose();
    // priceRangeMin.dispose();
    // priceRangeMax.dispose();
    // categoryController.dispose();
    // variantName.dispose();
    // isInStock.dispose();
    // selectedCategory.dispose();
    // ratingValue.dispose();
    // previewImage.dispose();
    // image2.dispose();
    // image3.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(
        AddProduct(ProductRepositoryImpl(sl<ProductDataSource>())),
      ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(title: const Titlesnew(nametitle: 'Products ')),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(constraints.maxWidth * 0.04),
                    child: Form(
                      key: globalKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 300),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(child: widget),
                          ),
                          children: [
                            const SizedBox(height: 20.0),
                            const Text(
                              'Product Images',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox10(),

                            ///image........
                            AnimationConfiguration.staggeredList(
                              position: 0,
                              duration: const Duration(milliseconds: 300),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BlocListener<ImageAuth, ImagePickerState>(
                                        listener: (context, state) {
                                          if (state is ImagePickedSuccess) {
                                            previewImage.value = state.image;

                                            if (image2.value == null) {
                                              image2.value = previewImage.value;
                                            } else if (image3.value == null) {
                                              image3.value = previewImage.value;
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: constraints.maxWidth * 0.70,
                                          height: constraints.maxHeight * 0.21,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(
                                              16.0,
                                            ),
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
                                          child:
                                              BlocBuilder<
                                                ImageAuth,
                                                ImagePickerState
                                              >(
                                                builder: (context, state) {
                                                  if (state
                                                      is ImagePickedSuccess) {
                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      child: Image.file(
                                                        File(state.image),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    );
                                                  }

                                                  return const Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(height: 10),
                                                      Icon(
                                                        Icons.upload,
                                                        size: 30,
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        'Image Upload',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18.0,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                        child: Text(
                                                          'Click here to upload an image for the new category.',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Raleway',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                        ),
                                      ),

                                      ///side////
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: constraints.maxWidth * 0.19,

                                        child: Column(
                                          children: [
                                            ValueListenableBuilder(
                                              valueListenable: image2,
                                              builder: (context, value, child) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    if (image2.value != null) {
                                                      context
                                                          .read<ImageAuth>()
                                                          .add(
                                                            SelectedProductImage(
                                                              image2.value!,
                                                            ),
                                                          );
                                                    }
                                                  },
                                                  child: Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .topEnd,
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Container(
                                                        width:
                                                            constraints
                                                                .maxWidth *
                                                            0.15,
                                                        height:
                                                            constraints
                                                                .maxHeight *
                                                            0.07,
                                                        decoration: BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16.0,
                                                              ),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black12,
                                                              offset: Offset(
                                                                5,
                                                                5,
                                                              ),
                                                              blurRadius: 10,
                                                            ),
                                                            BoxShadow(
                                                              color: Colors
                                                                  .white70,
                                                              offset: Offset(
                                                                -5,
                                                                -5,
                                                              ),
                                                              blurRadius: 10,
                                                            ),
                                                          ],
                                                        ),

                                                        child: kIsWeb
                                                            ? Image.network(
                                                                image2.value!,
                                                              )
                                                            : ClipRRect(
                                                                borderRadius: const BorderRadiusGeometry.only(
                                                                  topLeft:
                                                                      Radius.circular(
                                                                        10,
                                                                      ),
                                                                  topRight:
                                                                      Radius.circular(
                                                                        10,
                                                                      ),
                                                                  bottomLeft:
                                                                      Radius.circular(
                                                                        10,
                                                                      ),
                                                                  bottomRight:
                                                                      Radius.circular(
                                                                        10,
                                                                      ),
                                                                ),
                                                                child:
                                                                    image2.value ==
                                                                        null
                                                                    ? Image.asset(
                                                                        'assets/default.jpg',
                                                                      )
                                                                    : Image.file(
                                                                        File(
                                                                          image2
                                                                              .value!,
                                                                        ),
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        width:
                                                                            constraints.maxWidth *
                                                                            0.13,
                                                                        height:
                                                                            constraints.maxHeight *
                                                                            0.07,
                                                                      ),
                                                              ),
                                                      ),

                                                      image2.value == null
                                                          ? const SizedBox()
                                                          : Positioned(
                                                              top: -1,
                                                              right: -2,

                                                              child: GestureDetector(
                                                                behavior:
                                                                    HitTestBehavior
                                                                        .translucent,
                                                                onTap: () {
                                                                  if (previewImage
                                                                              .value !=
                                                                          null &&
                                                                      previewImage
                                                                          .value!
                                                                          .contains(
                                                                            image2.value!,
                                                                          )) {
                                                                    const updatedList =
                                                                        null;
                                                                    previewImage
                                                                            .value =
                                                                        updatedList;
                                                                    context
                                                                        .read<
                                                                          ImageAuth
                                                                        >()
                                                                        .add(
                                                                          ClearPickedImageEvent(),
                                                                        );
                                                                  }

                                                                  image2.value =
                                                                      null;
                                                                },
                                                                child: const Icon(
                                                                  Icons
                                                                      .remove_circle_rounded,
                                                                  color:
                                                                      Color.fromARGB(
                                                                        255,
                                                                        233,
                                                                        55,
                                                                        43,
                                                                      ),
                                                                  size: 20,
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizedBox10(),

                                            GestureDetector(
                                              onTap: () {
                                                if (image3.value != null) {
                                                  context.read<ImageAuth>().add(
                                                    SelectedProductImage(
                                                      image3.value!,
                                                    ),
                                                  );
                                                }
                                              },
                                              child: ValueListenableBuilder(
                                                valueListenable: image3,
                                                builder: (context, value, child) {
                                                  return Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .topEnd,
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Container(
                                                        width:
                                                            constraints
                                                                .maxWidth *
                                                            0.15,
                                                        height:
                                                            constraints
                                                                .maxHeight *
                                                            0.07,
                                                        decoration: BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16.0,
                                                              ),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black12,
                                                              offset: Offset(
                                                                5,
                                                                5,
                                                              ),
                                                              blurRadius: 10,
                                                            ),
                                                            BoxShadow(
                                                              color: Colors
                                                                  .white70,
                                                              offset: Offset(
                                                                -5,
                                                                -5,
                                                              ),
                                                              blurRadius: 10,
                                                            ),
                                                          ],
                                                        ),

                                                        child: kIsWeb
                                                            ? Image.network(
                                                                image3.value!,
                                                              )
                                                            : ClipRRect(
                                                                borderRadius:
                                                                    BorderRadiusGeometry.circular(
                                                                      10,
                                                                    ),
                                                                child:
                                                                    image3.value ==
                                                                        null
                                                                    ? Image.asset(
                                                                        'assets/default.jpg',
                                                                      )
                                                                    : Image.file(
                                                                        File(
                                                                          image3
                                                                              .value!,
                                                                        ),
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        width:
                                                                            constraints.maxWidth *
                                                                            0.13,
                                                                        height:
                                                                            constraints.maxHeight *
                                                                            0.07,
                                                                      ),
                                                              ),
                                                      ),

                                                      image3.value == null
                                                          ? const SizedBox()
                                                          : Positioned(
                                                              top: -1,
                                                              right: -2,

                                                              child: GestureDetector(
                                                                behavior:
                                                                    HitTestBehavior
                                                                        .translucent,
                                                                onTap: () {
                                                                  if (previewImage
                                                                              .value !=
                                                                          null &&
                                                                      previewImage
                                                                          .value!
                                                                          .contains(
                                                                            image3.value!,
                                                                          )) {
                                                                    const updatedList =
                                                                        null;
                                                                    previewImage
                                                                            .value =
                                                                        updatedList;
                                                                    context
                                                                        .read<
                                                                          ImageAuth
                                                                        >()
                                                                        .add(
                                                                          ClearPickedImageEvent(),
                                                                        );
                                                                  }

                                                                  image3.value =
                                                                      null;
                                                                },
                                                                child: const Icon(
                                                                  Icons
                                                                      .remove_circle_rounded,
                                                                  color:
                                                                      Color.fromARGB(
                                                                        255,
                                                                        233,
                                                                        55,
                                                                        43,
                                                                      ),
                                                                  size: 20,
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox10(),
                                            GestureDetector(
                                              onTap: () {
                                                if (image2.value is String &&
                                                    image3.value is String) {
                                                } else {
                                                  galleryorcamera(context);
                                                }
                                              },
                                              child: imageaddingbutton(
                                                constraints,
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
                            const SizedBox(height: 20.0),
                            const Titlesnew(nametitle: 'Product Name'),
                            const SizedBox(height: 10.0),
                            InputFieldNew(
                              controller: productName,
                              hintText: 'Enter product name',
                              validator: (value) => Validators.validateString(
                                value ?? "",
                                "Product Name",
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            const Titlesnew(nametitle: 'Description'),
                            const SizedBox(height: 20.0),
                            InputFieldNew(
                              controller: description,
                              hintText: 'Enter description',
                              validator: (value) => Validators.validateString(
                                value ?? "",
                                "Description",
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            const Titlesnew(nametitle: 'Price'),
                            const SizedBox(height: 10.0),
                            InputFieldNew(
                              controller: price,
                              hintText: 'Enter price (e.g., 29.99)',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              validator: (value) => Validators.validatePrice(
                                value ?? "",
                                "Price",
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            const Titlesnew(
                              nametitle: 'Discount Price (Optional)',
                            ),
                            const SizedBox(height: 10.0),
                            InputFieldNew(
                              controller: discountPrice,
                              hintText: 'Enter discount price (e.g., 19.99)',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return null;
                                return Validators.validatePrice(
                                  value,
                                  "Discount Price",
                                );
                              },
                            ),
                            const SizedBox(height: 20.0),
                            const Titlesnew(nametitle: 'SKU'),
                            const SizedBox(height: 10.0),
                            InputFieldNew(
                              controller: sku,
                              hintText: 'Enter SKU (e.g., ABC123)',
                              validator: (value) =>
                                  Validators.validateSKU(value ?? ""),
                            ),
                            const SizedBox(height: 20.0),
                            const Titlesnew(nametitle: 'Tags'),
                            const SizedBox(height: 10.0),
                            InputFieldNew(
                              controller: tags,
                              hintText: 'Enter tags (e.g., casual, summer)',
                              validator: (value) => Validators.validateString(
                                value ?? "",
                                "Tags",
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            const Titlesnew(nametitle: 'Availability'),
                            const SizedBox(height: 10.0),
                            ValueListenableBuilder<bool>(
                              valueListenable: isInStock,
                              builder: (context, value, child) {
                                return Container(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'In Stock',
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                      Switch(
                                        value: value,
                                        onChanged: (newValue) =>
                                            isInStock.value = newValue,
                                        activeColor: Colors.green,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20.0),
                            const Titlesnew(nametitle: 'Weight (kg)'),
                            const SizedBox(height: 10.0),
                            InputFieldNew(
                              controller: weight,
                              hintText: 'Enter weight (e.g., 1.5)',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              validator: (value) =>
                                  Validators.validateWeight(value ?? ""),
                            ),
                            const SizedBox(height: 20.0),
                            const Titlesnew(nametitle: 'Dimensions (cm)'),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                Expanded(
                                  child: InputFieldNew(
                                    controller: length,
                                    hintText: 'Length',
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    validator: (value) =>
                                        Validators.validateDimension(
                                          value ?? "",
                                          "Length",
                                        ),
                                  ),
                                ),
                                SizedBox(width: constraints.maxWidth * 0.02),
                                Expanded(
                                  child: InputFieldNew(
                                    controller: width,
                                    hintText: 'Width',
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    validator: (value) =>
                                        Validators.validateDimension(
                                          value ?? "",
                                          "Width",
                                        ),
                                  ),
                                ),
                                SizedBox(width: constraints.maxWidth * 0.02),
                                Expanded(
                                  child: InputFieldNew(
                                    controller: height,
                                    hintText: 'Height',
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    validator: (value) =>
                                        Validators.validateDimension(
                                          value ?? "",
                                          "Height",
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            const Titlesnew(nametitle: 'Tax Rate (%)'),
                            const SizedBox(height: 10.0),
                            InputFieldNew(
                              controller: taxRate,
                              hintText: 'Enter tax rate (e.g., 10)',
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  Validators.validateTaxRate(value ?? ""),
                            ),
                            const SizedBox(height: 20.0),
                            const Titlesnew(nametitle: 'Rating'),
                            const SizedBox(height: 10.0),
                            ValueListenableBuilder<double>(
                              valueListenable: ratingValue,
                              builder: (context, value, child) {
                                return Container(
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
                                  child: Slider(
                                    value: value,
                                    min: 0.0,
                                    max: 5.0,
                                    divisions: 10,
                                    label: value.toStringAsFixed(1),
                                    onChanged: (newValue) {
                                      ratingValue.value = newValue;
                                    },
                                    activeColor: Colors.green,
                                    inactiveColor: Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20.0),
                            const Titlesnew(
                              nametitle: 'Price Range for Filter',
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                Expanded(
                                  child: InputFieldNew(
                                    controller: priceRangeMin,
                                    hintText: 'Min Price (e.g., 10)',
                                    keyboardType: TextInputType.number,
                                    validator: (value) =>
                                        Validators.validatePrice(
                                          value ?? "",
                                          "Min Price",
                                        ),
                                  ),
                                ),
                                SizedBox(width: constraints.maxWidth * 0.02),
                                Expanded(
                                  child: InputFieldNew(
                                    controller: priceRangeMax,
                                    hintText: 'Max Price (e.g., 100)',
                                    keyboardType: TextInputType.number,
                                    validator: (value) =>
                                        Validators.validatePrice(
                                          value ?? "",
                                          "Max Price",
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            const Titlesnew(nametitle: 'Filter Tags'),
                            const SizedBox(height: 10.0),
                            Container(
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
                              child: Wrap(
                                spacing: 8.0,
                                children: [
                                  ...['casual', 'summer', 'winter', 'sale'].map(
                                    (tag) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (filterTags.contains(tag)) {
                                            filterTags.remove(tag);
                                          } else {
                                            filterTags.add(tag);
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: filterTags.contains(tag)
                                                ? Colors.green[100]
                                                : Colors.grey[300],
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                offset: Offset(2, 2),
                                                blurRadius: 4,
                                              ),
                                              BoxShadow(
                                                color: Colors.white70,
                                                offset: Offset(-2, -2),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 4.0,
                                            ),
                                            child: Text(
                                              tag,
                                              style: const TextStyle(
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            const Titlesnew(nametitle: 'Category'),
                            const SizedBox(height: 10.0),
                            categoryLists(),
                            const SizedBox(height: 20.0),
                            const Titlesnew(nametitle: 'Variants'),
                            const SizedBox(height: 10.0),
                            variantsList(),
                            const SizedBox(height: 20.0),
                            const Titlesnew(nametitle: 'Quantities'),
                            const SizedBox(height: 10.0),
                            quantitiesList(),
                            const SizedBox(height: 20.0),
                            Center(
                              child: BlocConsumer<ProductBloc, ProductState>(
                                listener: (context, state) {
                                  if (state is ProductSuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Product added successfully!',
                                        ),
                                      ),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HomePage(),
                                      ),
                                    );
                                  } else if (state is ProductFailure) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.message)),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return GradientButtonNew(
                                    height: 60.0,
                                    width: constraints.maxWidth * 0.8,
                                    text: state is ProductLoading
                                        ? 'Uploading...'
                                        : 'Add Product',
                                    onTap: () {
                                      if (image2.value != null &&
                                          image3.value != null) {
                                        if (globalKey.currentState!
                                            .validate()) {
                                          final product = ProductEntity(
                                            name: productName.text,
                                            description: description.text,
                                            price:
                                                double.tryParse(price.text) ??
                                                0.0,
                                            discountPrice:
                                                discountPrice.text.isEmpty
                                                ? null
                                                : double.tryParse(
                                                    discountPrice.text,
                                                  ),
                                            sku: sku.text,
                                            tags: tags.text
                                                .split(',')
                                                .map((t) => t.trim())
                                                .toList(),
                                            inStock: isInStock.value,
                                            weight:
                                                double.tryParse(weight.text) ??
                                                0.0,
                                            length:
                                                double.tryParse(length.text) ??
                                                0.0,
                                            width:
                                                double.tryParse(width.text) ??
                                                0.0,
                                            height:
                                                double.tryParse(height.text) ??
                                                0.0,
                                            taxRate:
                                                double.tryParse(taxRate.text) ??
                                                0.0,
                                            rating: ratingValue.value,
                                            category: selectedCategory.value,
                                            variants: variants.value,
                                            quantities: variantQuantities,
                                            images: [
                                              image2.value!,
                                              image3.value!,
                                            ],
                                            priceRangeMin:
                                                double.tryParse(
                                                  priceRangeMin.text,
                                                ) ??
                                                0.0,
                                            priceRangeMax:
                                                double.tryParse(
                                                  priceRangeMax.text,
                                                ) ??
                                                0.0,
                                            filterTags: filterTags,
                                            timestamp: DateTime.now(),
                                          );

                                          context.read<ProductBloc>().add(
                                            AddProductEvent(
                                              product,
                                              widget.id ?? '',
                                              widget.mainCategoryId ?? "",
                                            ),
                                          );
                                          previewImage.value = null;
                                          image2.value = null;
                                          image3.value = null;
                                          context.read<ImageAuth>().add(
                                            ClearPickedImageEvent(),
                                          );
                                        }
                                      } else {
                                        print(
                                          'image 1:${image2.value}/n image 2:${image3.value} ',
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Container imageaddingbutton(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.15,
      height: constraints.maxHeight * 0.07,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.0),
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
      padding: const EdgeInsets.all(1),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: Icon(Icons.add, size: 30)),
      ),
    );
  }

  Future<dynamic> galleryorcamera(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a picture'),
              onTap: () {
                context.read<ImageAuth>().add(ChooseImageFromCameraEvent());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from gallery'),
              onTap: () {
                context.read<ImageAuth>().add(ChooseImageFromGalleryEvent());
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryLists() {
    return ValueListenableBuilder(
      valueListenable: selectedCategory,
      builder: (context, value, child) {
        return AnimationConfiguration.staggeredList(
          position: 5,
          duration: const Duration(milliseconds: 200),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: Row(
                children: [
                  Expanded(
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
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory.value.isEmpty
                            ? null
                            : selectedCategory.value,
                        hint: const Text('Select Category'),
                        items: categoryList.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(
                              category,
                              style: const TextStyle(color: Colors.black87),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            selectedCategory.value = value;

                            _updateVariants();
                          }
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                        ),
                        validator: (value) =>
                            value == null ? 'Please select a category' : null,
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  BounceInDown(
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(4, 4),
                            blurRadius: 8,
                          ),
                          BoxShadow(
                            color: Colors.white70,
                            offset: Offset(-4, -4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.green),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return SlideInUp(
                                duration: const Duration(milliseconds: 150),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(24.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(
                                        context,
                                      ).viewInsets.bottom,
                                      left: 16.0,
                                      right: 16.0,
                                      top: 16.0,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Titlesnew(
                                          nametitle: 'Add Category',
                                        ),
                                        const SizedBox(height: 10.0),
                                        InputFieldNew(
                                          controller: categoryController,
                                          hintText: 'Enter new category',
                                          validator: (value) =>
                                              Validators.validateString(
                                                value ?? "",
                                                'Category',
                                              ),
                                        ),
                                        const SizedBox(height: 20.0),
                                        GradientButtonNew(
                                          text: 'Add Category',
                                          width: double.infinity,
                                          onTap: () {
                                            if (categoryKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                categoryList.add(
                                                  categoryController.text,
                                                );
                                                categoryController.clear();
                                              });
                                              Navigator.pop(context);
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 20.0),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget variantsList() {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategory,
          builder: (context, value, child) {
            return Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: variants,
                  builder: (context, value, child) {
                    return Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: variants.value.asMap().entries.map((entry) {
                        int index = entry.key;
                        String variant = entry.value;
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 150),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(4, 4),
                                      blurRadius: 8,
                                    ),
                                    BoxShadow(
                                      color: Colors.white70,
                                      offset: Offset(-4, -4),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 10.0,
                                      ),
                                      child: Text(
                                        variant,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -8.0,
                                      right: -8.0,
                                      child: GestureDetector(
                                        onTap: () {
                                          variants.value.removeAt(index);
                                          variantQuantities.remove(variant);
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.redAccent,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 10.0),
        Row(
          children: [
            Expanded(
              child: Form(
                key: variantKey,
                child: InputFieldNew(
                  controller: variantName,
                  hintText:
                      'Add variant (e.g., ${selectedCategory.value == 'dress'
                          ? 'S, M, L'
                          : selectedCategory.value == 'food'
                          ? '200ml, 1l'
                          : 'black, silver'})',
                  validator: (value) =>
                      Validators.validateString(value ?? "", 'Variant'),
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            BounceInDown(
              duration: const Duration(milliseconds: 200),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(4, 4),
                      blurRadius: 8,
                    ),
                    BoxShadow(
                      color: Colors.white70,
                      offset: Offset(-4, -4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: () {
                    if (variantKey.currentState!.validate()) {
                      final updatalist = List<String>.from(variants.value)
                        ..add(variantName.text);
                      variants.value = updatalist;
                      variantQuantities[variantName.text] = 0;

                      variantName.clear();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget quantitiesList() {
    return ValueListenableBuilder(
      valueListenable: variants,
      builder: (context, value, child) {
        return Column(
          children: variants.value.asMap().entries.map((entry) {
            String variant = entry.value;
            return AnimationConfiguration.staggeredList(
              position: entry.key,
              duration: const Duration(milliseconds: 150),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Quantity for $variant',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          width: 120.0,
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
                            child: TextFormField(
                              controller: TextEditingController(
                                text:
                                    variantQuantities[variant]?.toString() ??
                                    '0',
                              ),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                              ),
                              validator: (value) =>
                                  Validators.validateQuantity(value ?? ""),
                              onChanged: (value) {
                                setState(() {
                                  variantQuantities[variant] =
                                      int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class SecondImage extends StatelessWidget {
  String? image;
  final BoxConstraints constraints;
  SecondImage({super.key, required this.constraints, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: constraints.maxWidth * 0.15,
          height: constraints.maxHeight * 0.07,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16.0),
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

          child: kIsWeb
              ? Image.network(image!)
              : ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: image == null
                      ? Image.asset('assets/default.jpg')
                      : Image.file(
                          File(image!),
                          fit: BoxFit.fill,
                          width: constraints.maxWidth * 0.13,
                          height: constraints.maxHeight * 0.07,
                        ),
                ),
        ),

        image == null
            ? const SizedBox()
            : Positioned(
                top: -10,
                right: -13,

                child: GestureDetector(
                  onTap: () {
                    if (previewImage.value!.contains(image!)) {
                      previewImage.value = null;
                    }
                    image = null;
                  },
                  child: const Icon(
                    Icons.remove_circle_outline_rounded,
                    color: Colors.redAccent,
                    size: 19,
                  ),
                ),
              ),
      ],
    );
  }
}
