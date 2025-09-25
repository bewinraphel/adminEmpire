import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/commonvalidator.dart';
import 'package:empire/core/utilis/widgets.dart';
import 'package:empire/feature/auth/data/datasource/image_profile.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_gallery_usecase.dart';
import 'package:empire/feature/product/data/datasource/add_product_data_source.dart';
import 'package:empire/feature/product/data/repository/add_product_respository.dart';
import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/domain/usecase/product/add_product_usecae.dart';
import 'package:empire/feature/auth/presentation/bloc/profile_image_bloc.dart';
import 'package:empire/feature/product/domain/usecase/productcaliing_usecase.dart';
import 'package:empire/feature/product/presentation/bloc/add_product_bloc/add_brand.dart';
import 'package:empire/feature/product/presentation/bloc/add_product_bloc/add_product.dart';
import 'package:empire/feature/product/presentation/bloc/add_product_bloc/brand.dart';

import 'package:empire/feature/product/presentation/views/add_product.dart/widgets.dart';
import 'package:empire/feature/homepage/presentation/view/home_page.dart';
import 'package:empire/feature/product/presentation/views/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';

ValueNotifier<String?> image2 = ValueNotifier(null);
ValueNotifier<String?> image3 = ValueNotifier(null);
ValueNotifier<String?> previewImage = ValueNotifier(null);

class EditProdutsPage extends StatefulWidget {
  String? mainCategoryId;
  String? subcategoryId;
  final ProductEntity? product;
  String? productId;
  File? imageFile;
  EditProdutsPage({
    super.key,
    this.subcategoryId,
    this.mainCategoryId,
    this.product,
    this.productId,
  });

  @override
  State<EditProdutsPage> createState() => _AddProdutsPageState();
}

class _AddProdutsPageState extends State<EditProdutsPage> {
  final globalKey = GlobalKey<FormState>();
  final categoryKey = GlobalKey<FormState>();
  final variantKey = GlobalKey<FormState>();
  final productName = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final quantity = TextEditingController();
  final discountPrice = TextEditingController();
  final sku = TextEditingController();
  final tags = TextEditingController();
  final weight = TextEditingController();
  final length = TextEditingController();
  final width = TextEditingController();
  final height = TextEditingController();
  final taxRate = TextEditingController();
  final priceRangeMin = TextEditingController();
  final brandname = TextEditingController();
  final addbrandname = TextEditingController();
  final priceRangeMax = TextEditingController();
  ValueNotifier<String> bradname = ValueNotifier('');
  final categoryController = TextEditingController();
  final brandlabel = TextEditingController();
  final variantName = TextEditingController();
  final List<String> filterTags = [];
  final brandKey = GlobalKey<FormState>();
  final ValueNotifier<bool> isInStock = ValueNotifier(true);
  final ValueNotifier<String> selectedCategory = ValueNotifier('');
  final ValueNotifier<double> ratingValue = ValueNotifier(0.0);
  final images = List.generate(3, (dynamic index) => 'null', growable: true);
  ImageSources gallery = ImageSources();
  String? image4;
  List<String> categoryList = ['dress', 'food', 'electronics', 'accessories'];
  final List<String> brandList = [];
  ValueNotifier<List<Variant>> variants = ValueNotifier([]);
  List<Variant> newVariants = [];
  Map<String, int> variantQuantities = {};
  final List<TextEditingController> weightControllers = [];
  final List<TextEditingController> regularpriceControllers = [];
  final List<TextEditingController> quantityControllers = [];
  final List<FocusNode> focusNodes = [];
  List<String?> pickedImage = [];

  ValueNotifier<String>? brandImage = ValueNotifier('');
  File? imageFile;
  @override
  void initState() {
    super.initState();

    productName.text = widget.product!.name;
    description.text = widget.product!.description;
    price.text = widget.product!.price.toString();
    quantity.text = widget.product!.quantities.toString();
    discountPrice.text = widget.product!.discountPrice.toString();
    sku.text = widget.product!.sku;
    tags.text = widget.product!.tags.join(', ');
    weight.text = widget.product!.weight.toString();
    length.text = widget.product!.length.toString();
    width.text = widget.product!.width.toString();
    height.text = widget.product!.height.toString();
    taxRate.text = widget.product!.taxRate.toString();
    brandname.text = widget.product!.brand!;
    isInStock.value = widget.product!.inStock;
    selectedCategory.value = widget.product!.category;
    widget.product!.variantDetails;
    filterTags.addAll(widget.product!.filterTags);

    image2.value = widget.product!.images.isNotEmpty
        ? widget.product!.images[0]
        : null;
    image3.value = widget.product!.images.length > 1
        ? widget.product!.images[1]
        : null;
    newVariants.addAll(List.from(widget.product!.variantDetails));
    for (var variant in newVariants) {
      weightControllers.add(
        TextEditingController(text: variant.regularPrice.toString()),
      );
      regularpriceControllers.add(
        TextEditingController(text: variant.salePrice.toString()),
      );
      quantityControllers.add(
        TextEditingController(text: variant.quantity.toString()),
      );
      focusNodes.add(FocusNode());
    }
    variants.value = List.from(newVariants);
  }

  void _updateVariants() {
    variants.value.clear();
    if (selectedCategory.value == 'dress') {
      newVariants = [
        const Variant(name: 'S'),
        const Variant(name: 'M'),
        const Variant(name: 'L'),
        const Variant(name: 'XL'),
      ];
      variants.value = List.from(newVariants);
    } else if (selectedCategory.value == 'food') {
      newVariants = [
        const Variant(name: '200ml'),
        const Variant(name: '1l'),
        const Variant(name: '500g'),
        const Variant(name: '1kg'),
      ];
      variants.value = List.from(newVariants);
    } else if (selectedCategory.value == 'electronics') {
      newVariants = [
        const Variant(name: 'black'),
        const Variant(name: 'silver'),
        const Variant(name: 'white'),
      ];
      variants.value = List.from(newVariants);
    } else if (selectedCategory.value == 'accessories') {
      newVariants = [
        const Variant(name: 'small'),
        const Variant(name: 'large'),
      ];
      variants.value = List.from(newVariants);
    }

    weightControllers.clear();
    regularpriceControllers.clear();
    quantityControllers.clear();
    focusNodes.clear();

    for (var variant in newVariants) {
      weightControllers.add(
        TextEditingController(text: variant.regularPrice.toString()),
      );
      regularpriceControllers.add(
        TextEditingController(text: variant.salePrice.toString()),
      );
      quantityControllers.add(
        TextEditingController(text: variant.quantity.toString()),
      );
      focusNodes.add(FocusNode());
    }

    variantQuantities = {for (var v in variants.value) v.name: 0};
  }

  @override
  void dispose() {
    for (var controller in weightControllers) {
      controller.dispose();
    }
    for (var controller in regularpriceControllers) {
      controller.dispose();
    }
    for (var controller in quantityControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductBloc(
            AddProductUseCase(ProductRepositoryImpl(sl<ProductDataSource>())),
          ),
        ),
        BlocProvider(
          create: (context) =>
              BrandBloc(sl<ProductcallingUsecase>(), sl<AddProductUseCase>())
                ..add(
                  BrandFetching(
                    mainCategoryId: widget.mainCategoryId!,
                    subCategoryId: widget.subcategoryId!,
                  ),
                ),
        ),
        BlocProvider(
          create: (_) => BrandImageAuth(
            sl<PickImageFromCamera>(),
            sl<PickImageFromGallery>(),
          ),
        ),
      ],

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
                                                      child: Image.network(
                                                        state.image,
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
                                                                    : Image.network(
                                                                        image2
                                                                            .value!,

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
                                                                      null) {
                                                                    previewImage
                                                                            .value =
                                                                        null;
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
                                                                    : Image.network(
                                                                        image3
                                                                            .value!,

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
                                                                      null) {
                                                                    previewImage
                                                                            .value =
                                                                        null;
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
                            const Titlesnew(nametitle: 'quantity'),

                            const SizedBox(height: 10.0),
                            InputFieldNew(
                              controller: quantity,
                              hintText: 'Enter Qunatity (e.g.,10)',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              validator: (value) => Validators.validatePrice(
                                value ?? "",
                                "quantity",
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            const SizedBox(height: 20.0),
                            const Titlesnew(nametitle: 'price'),

                            const SizedBox(height: 10.0),
                            InputFieldNew(
                              controller: price,
                              hintText: 'Enter price (e.g.34.90)',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              validator: (value) => Validators.validatePrice(
                                value ?? "",
                                "price",
                              ),
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
                            instock(isInStock: isInStock),
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
                            BlocBuilder<ProductBloc, ProductState>(
                              builder: (context, state) {
                                if (state is SeletedState &&
                                    state.productweight == 'electronics') {
                                  return Wieghts(
                                    constraint: constraints,
                                    weight: weight,
                                    length: length,
                                    width: width,
                                    height: height,
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                            const Titlesnew(nametitle: 'Variants'),
                            const SizedBox(height: 10.0),
                            const SizedBox(height: 10.0),
                            variantsList(constraints),
                            const SizedBox(height: 10.0),
                            const Titlesnew(nametitle: 'Brand'),
                            const SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.79,
                                  decoration: boxshadow(),
                                  child: ListTile(
                                    onTap: () {
                                      context.read<BrandBloc>().add(
                                        BrandFetching(
                                          mainCategoryId:
                                              widget.mainCategoryId!,
                                          subCategoryId: widget.subcategoryId!,
                                        ),
                                      );
                                      final brands = context.read<BrandBloc>();
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.white,
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) {
                                          return MultiBlocProvider(
                                            providers: [
                                              BlocProvider.value(value: brands),
                                            ],
                                            child: SizedBox(
                                              height:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height /
                                                  2,
                                              child: Column(
                                                children: [
                                                  BlocBuilder<
                                                    BrandBloc,
                                                    BrandState
                                                  >(
                                                    builder: (context, state) {
                                                      if (state
                                                          is BrandLoading) {
                                                        return const CircularProgressIndicator();
                                                      } else if (state
                                                          is LoadedBrand) {
                                                        if (state
                                                            .brands
                                                            .isEmpty) {
                                                          return const Center(
                                                            child: Text(
                                                              'No Brand ',
                                                            ),
                                                          );
                                                        } else {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  8.0,
                                                                ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const SizedBox30(),
                                                                const Titlesnew(
                                                                  nametitle:
                                                                      'Select Brand',
                                                                ),
                                                                GridView.builder(
                                                                  gridDelegate:
                                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                                        crossAxisCount:
                                                                            4,
                                                                      ),
                                                                  shrinkWrap:
                                                                      true,

                                                                  physics:
                                                                      const AlwaysScrollableScrollPhysics(),
                                                                  itemCount: state
                                                                      .brands
                                                                      .length,
                                                                  scrollDirection:
                                                                      Axis.vertical,
                                                                  itemBuilder:
                                                                      (
                                                                        context,
                                                                        index,
                                                                      ) {
                                                                        return GestureDetector(
                                                                          onTap: () {
                                                                            brandname.text =
                                                                                state.brands[index].label;
                                                                            bradname.value =
                                                                                state.brands[index].label;
                                                                            brandImage!.value =
                                                                                state.brands[index].imageUrl;
                                                                            Navigator.pop(
                                                                              context,
                                                                            );
                                                                          },
                                                                          child: BrandIcon(
                                                                            imageUrl:
                                                                                state.brands[index].imageUrl,
                                                                            label:
                                                                                state.brands[index].label,
                                                                            isActive:
                                                                                true,
                                                                          ),
                                                                        );
                                                                      },
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                      }

                                                      return const CircleAvatar();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    leading: ValueListenableBuilder(
                                      valueListenable: bradname,
                                      builder: (context, value, child) {
                                        return Text(
                                          brandname.text.isEmpty
                                              ? 'No brand Name'
                                              : brandname.text,
                                        );
                                      },
                                    ),
                                    trailing: SizedBox(
                                      height: 50,
                                      width: 50,

                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(30),
                                        child: ValueListenableBuilder<String>(
                                          valueListenable: brandImage!,
                                          builder: (context, value, child) {
                                            return CachedNetworkImage(
                                              imageUrl: brandImage!.value,
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) {
                                                return const CircularProgressIndicator();
                                              },

                                              errorWidget:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(Icons.error),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: boxshadow(),
                                  child: IconButton(
                                    onPressed: () async {
                                      final brands = context.read<BrandBloc>();
                                      final brandImage = context
                                          .read<BrandImageAuth>();
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.white,
                                        useSafeArea: true,
                                        builder: (bottomSheetContext) {
                                          return MultiBlocProvider(
                                            providers: [
                                              BlocProvider.value(value: brands),
                                              BlocProvider.value(
                                                value: brandImage,
                                              ),
                                            ],
                                            child: SlideInUp(
                                              duration: const Duration(
                                                milliseconds: 150,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            24.0,
                                                          ),
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
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Builder(
                                                          builder: (context) {
                                                            return BlocBuilder<
                                                              BrandImageAuth,
                                                              BrandImagePickerState
                                                            >(
                                                              builder: (context, state) {
                                                                if (state
                                                                    is BrandImagePickedSuccess) {
                                                                  imageFile = File(
                                                                    state.image,
                                                                  );
                                                                }

                                                                return Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const SizedBox(
                                                                      height:
                                                                          16,
                                                                    ),

                                                                    Text(
                                                                      'Upload Brand Image',
                                                                      style: GoogleFonts.inter(
                                                                        color: const Color(
                                                                          0xFF111418,
                                                                        ),
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                        letterSpacing:
                                                                            -0.015 *
                                                                            18,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                          color: const Color(
                                                                            0xFFD5DBE2,
                                                                          ),
                                                                          width:
                                                                              2,
                                                                          style:
                                                                              BorderStyle.solid,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              12,
                                                                            ),
                                                                      ),
                                                                      padding: const EdgeInsets.symmetric(
                                                                        vertical:
                                                                            56,
                                                                        horizontal:
                                                                            24,
                                                                      ),
                                                                      child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          if (imageFile !=
                                                                              null)
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(
                                                                                8,
                                                                              ),
                                                                              child: Image.file(
                                                                                imageFile!,
                                                                                width: 380,
                                                                                height: 200,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            )
                                                                          else
                                                                            Column(
                                                                              children: [
                                                                                Text(
                                                                                  'Upload Image',
                                                                                  style: GoogleFonts.inter(
                                                                                    color: const Color(
                                                                                      0xFF111418,
                                                                                    ),
                                                                                    fontSize: 18,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    letterSpacing:
                                                                                        -0.015 *
                                                                                        18,
                                                                                  ),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 8,
                                                                                ),
                                                                                Text(
                                                                                  'Click here to upload an image for the new category.',
                                                                                  style: GoogleFonts.inter(
                                                                                    color: const Color(
                                                                                      0xFF111418,
                                                                                    ),
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.normal,
                                                                                  ),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          const SizedBox(
                                                                            height:
                                                                                24,
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                24,
                                                                          ),
                                                                          ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(
                                                                              backgroundColor: ColoRs.elevatedButtonColor,
                                                                              foregroundColor: ColoRs.whiteColor,
                                                                              textStyle: GoogleFonts.inter(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                                letterSpacing:
                                                                                    0.015 *
                                                                                    14,
                                                                              ),
                                                                              padding: const EdgeInsets.symmetric(
                                                                                horizontal: 16,
                                                                                vertical: 10,
                                                                              ),
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(
                                                                                  10,
                                                                                ),
                                                                              ),
                                                                              minimumSize: const Size(
                                                                                84,
                                                                                40,
                                                                              ),
                                                                            ),
                                                                            onPressed: () {
                                                                              context
                                                                                  .read<
                                                                                    BrandImageAuth
                                                                                  >()
                                                                                  .add(
                                                                                    ChooseBrandImageFromGalleryEvent(),
                                                                                  );
                                                                            },
                                                                            child: const Text(
                                                                              'Upload Image',
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                        const SizedBox(
                                                          height: 24,
                                                        ),
                                                        const Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Titlesnew(
                                                            nametitle:
                                                                'Add Brand',
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 24,
                                                        ),
                                                        Form(
                                                          key: brandKey,
                                                          child: InputFieldNew(
                                                            controller:
                                                                addbrandname,
                                                            hintText:
                                                                'Enter new Brand',
                                                            validator: (value) =>
                                                                Validators.validateString(
                                                                  value ?? "",
                                                                  'Brand',
                                                                ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20.0,
                                                        ),
                                                        GradientButtonNew(
                                                          text: 'Add Brand',
                                                          height:
                                                              MediaQuery.of(
                                                                context,
                                                              ).size.height *
                                                              0.05,
                                                          width:
                                                              MediaQuery.of(
                                                                context,
                                                              ).size.width -
                                                              100,
                                                          onTap: () async {
                                                            if (brandKey
                                                                .currentState!
                                                                .validate()) {
                                                              context.read<BrandBloc>().add(
                                                                BrandAdding(
                                                                  mainCategoryId:
                                                                      widget
                                                                          .mainCategoryId!,
                                                                  subCategoryId:
                                                                      widget
                                                                          .subcategoryId!,
                                                                  brand: Brand(
                                                                    imageUrl:
                                                                        imageFile!
                                                                            .path,
                                                                    label:
                                                                        addbrandname
                                                                            .text,
                                                                  ),
                                                                ),
                                                              );
                                                              context.read<BrandBloc>().add(
                                                                BrandFetching(
                                                                  mainCategoryId:
                                                                      widget
                                                                          .mainCategoryId!,
                                                                  subCategoryId:
                                                                      widget
                                                                          .subcategoryId!,
                                                                ),
                                                              );
                                                              context
                                                                  .read<
                                                                    BrandImageAuth
                                                                  >()
                                                                  .add(
                                                                    ClearPickedBrandImageEvent(),
                                                                  );
                                                              brandname.clear();
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            }
                                                          },
                                                        ),
                                                        const SizedBox(
                                                          height: 20.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },

                                    icon: const Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),

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
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          if (context.mounted) {
                                            context.read<ImageAuth>().add(
                                              ClearPickedImageEvent(),
                                            );
                                            Navigator.of(
                                              context,
                                            ).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const HomePage(),
                                              ),
                                              (route) => false,
                                            );
                                          }
                                        });
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
                                        : 'Edit Product',
                                    onTap: () {
                                      if (image2.value != null &&
                                          image3.value != null) {
                                        if (globalKey.currentState!
                                            .validate()) {
                                          final products = ProductEntity(
                                            name: productName.text,
                                            description: description.text,
                                            price:
                                                double.tryParse(price.text) ??
                                                0.0,
                                            discountPrice: 10.0,
                                            sku: 'ABCD21234',
                                            brand: brandname.text,
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

                                            category: selectedCategory.value,

                                            quantities: int.parse(
                                              quantity.text,
                                            ),
                                            images: [
                                              image2.value!,
                                              image3.value!,
                                            ],

                                            filterTags: filterTags,

                                            variantDetails: variants.value,
                                          );

                                          context.read<ProductBloc>().add(
                                            UpdateProductEvent(
                                              productId: widget.productId!,
                                              product: products,
                                              subcategoryId:
                                                  widget.subcategoryId!,
                                              mainCategoryId:
                                                  widget.mainCategoryId!,
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Please upload both images and fill all required fields',
                                              ),
                                            ),
                                          );

                                          previewImage.value = null;
                                          image2.value = null;
                                          image3.value = null;
                                          context.read<ImageAuth>().add(
                                            ClearPickedImageEvent(),
                                          );
                                        }
                                      } else {}
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
                context.read<ImageAuth>().add(VariantImageFromCameraEvent());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from gallery'),
              onTap: () {
                context.read<ImageAuth>().add(VarinatImageFromGalleryEvent());
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
                            context.read<ProductBloc>().add(
                              Productweight(selectedCategory.value),
                            );
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
                            backgroundColor: Colors.white,
                            builder: (context) {
                              return SlideInUp(
                                duration: const Duration(milliseconds: 150),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
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
                                        Form(
                                          key: categoryKey,
                                          child: InputFieldNew(
                                            controller: categoryController,
                                            hintText: 'Enter new category',
                                            validator: (value) =>
                                                Validators.validateString(
                                                  value ?? "",
                                                  'Category',
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 20.0),
                                        GradientButtonNew(
                                          text: 'Add Category',
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.05,
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width -
                                              100,
                                          onTap: () {
                                            if (categoryKey.currentState!
                                                .validate()) {
                                              categoryList.add(
                                                categoryController.text,
                                              );
                                              categoryController.clear();

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

  Widget variantsList(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategory,
          builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                  valueListenable: variants,
                  builder: (context, value, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: variants.value.length,
                      itemBuilder: (context, index) {
                        final variant = variants.value[index];
                        final variantImage = ValueNotifier<String?>(
                          variant.image,
                        );
                        pickedImage.add(null);

                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 150),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: constraints.maxWidth * 0.30,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Regular Price',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.0,
                                                      ),
                                                ),
                                                child: InputFieldNew(
                                                  controller:
                                                      regularpriceControllers[index],
                                                  hintText:
                                                      'Enter price (e.g., 29.99)',
                                                  keyboardType:
                                                      const TextInputType.numberWithOptions(
                                                        decimal: true,
                                                      ),
                                                  validator: (value) =>
                                                      Validators.validatePrice(
                                                        value ?? "",
                                                        "Price",
                                                      ),
                                                  onChanged: (value) {
                                                    final updatedVariants =
                                                        List<Variant>.from(
                                                          variants.value,
                                                        );
                                                    updatedVariants[index] =
                                                        Variant(
                                                          name: variant.name,
                                                          image: variant.image,
                                                          regularPrice: variant
                                                              .regularPrice,
                                                          salePrice:
                                                              double.tryParse(
                                                                value,
                                                              ) ??
                                                              0.0,
                                                          quantity:
                                                              variant.quantity,
                                                        );
                                                    variants.value =
                                                        updatedVariants;
                                                  },
                                                  futuristic: true,
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              const Text(
                                                'Quantity',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.0,
                                                      ),
                                                ),
                                                child: InputFieldNew(
                                                  controller:
                                                      quantityControllers[index],
                                                  hintText:
                                                      'Enter quantity (e.g., 10)',
                                                  keyboardType:
                                                      TextInputType.number,
                                                  validator: (value) =>
                                                      Validators.validateQuantity(
                                                        value ?? "",
                                                      ),
                                                  onChanged: (value) {
                                                    final updatedVariants =
                                                        List<Variant>.from(
                                                          variants.value,
                                                        );
                                                    updatedVariants[index] =
                                                        Variant(
                                                          name: variant.name,
                                                          image: variant.image,
                                                          regularPrice: variant
                                                              .regularPrice,
                                                          salePrice:
                                                              variant.salePrice,
                                                          quantity:
                                                              int.tryParse(
                                                                quantityControllers[index]
                                                                    .text,
                                                              ) ??
                                                              0,
                                                        );
                                                    variants.value =
                                                        updatedVariants;
                                                    variantQuantities[variant
                                                            .name] =
                                                        int.tryParse(value) ??
                                                        0;
                                                  },
                                                  futuristic: true,
                                                ),
                                              ),

                                              const Text(
                                                'Sale Price ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.0,
                                                      ),
                                                ),
                                                child: InputFieldNew(
                                                  controller:
                                                      weightControllers[index],
                                                  hintText:
                                                      'Enter weight (e.g., 1.5 kg)',
                                                  keyboardType:
                                                      const TextInputType.numberWithOptions(
                                                        decimal: true,
                                                      ),
                                                  validator: (value) =>
                                                      Validators.validateWeight(
                                                        value ?? "",
                                                      ),
                                                  onChanged: (value) {
                                                    final updatedVariants =
                                                        List<Variant>.from(
                                                          variants.value,
                                                        );
                                                    updatedVariants[index] =
                                                        Variant(
                                                          name: variant.name,
                                                          image: variant.image,
                                                          regularPrice:
                                                              double.tryParse(
                                                                value,
                                                              ) ??
                                                              0.0,
                                                          salePrice:
                                                              variant.salePrice,
                                                          quantity:
                                                              variant.quantity,
                                                        );
                                                    variants.value =
                                                        updatedVariants;
                                                  },
                                                  futuristic: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: constraints.maxWidth * 0.05,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "${productName.text}- ${variant.name}",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            ValueListenableBuilder(
                                              valueListenable: variantImage,
                                              builder: (context, value, child) {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    final String? variantImage =
                                                        await gallery
                                                            .pickFromGallery();
                                                    pickedImage[index] =
                                                        variantImage!;
                                                    final updatedVariants =
                                                        List<Variant>.from(
                                                          variants.value,
                                                        );
                                                    updatedVariants[index] =
                                                        Variant(
                                                          name: variant.name,
                                                          image: variantImage,
                                                          regularPrice: variant
                                                              .regularPrice,
                                                          salePrice:
                                                              variant.salePrice,
                                                          quantity:
                                                              variant.quantity,
                                                        );
                                                    variants.value =
                                                        updatedVariants;
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 20,
                                                        ),
                                                    child: Container(
                                                      width:
                                                          constraints.maxWidth *
                                                          0.57,
                                                      height:
                                                          constraints
                                                              .maxHeight *
                                                          0.22,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12.0,
                                                            ),
                                                      ),
                                                      child: value == null
                                                          ? const Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .add_a_photo,
                                                                    color: Colors
                                                                        .black87,
                                                                    size: 20,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 4.0,
                                                                  ),
                                                                  Text(
                                                                    'Add Image',
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .black87,
                                                                      fontSize:
                                                                          12.0,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : kIsWeb
                                                          ? Image.network(value)
                                                          : ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12.0,
                                                                  ),
                                                              child:
                                                                  pickedImage[index] ==
                                                                      null
                                                                  ? Image.network(
                                                                      value,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    )
                                                                  : Image.file(
                                                                      File(
                                                                        value,
                                                                      ),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                            ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
                  futuristic: true,
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
                      final updatedVariants = List<Variant>.from(variants.value)
                        ..add(Variant(name: variantName.text));
                      variantQuantities[variantName.text] = 0;
                      weightControllers.add(
                        TextEditingController(text: 0.toString()),
                      );
                      regularpriceControllers.add(
                        TextEditingController(text: 0.toString()),
                      );
                      quantityControllers.add(
                        TextEditingController(text: 0.toString()),
                      );
                      variants.value = updatedVariants;

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
}

class Wieghts extends StatelessWidget {
  const Wieghts({
    super.key,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    required this.constraint,
  });

  final TextEditingController weight;
  final TextEditingController length;
  final TextEditingController width;
  final TextEditingController height;
  final BoxConstraints constraint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Titlesnew(nametitle: 'Weight (kg)'),
        const SizedBox(height: 10.0),
        InputFieldNew(
          controller: weight,
          hintText: 'Enter weight (e.g., 1.5)',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) => Validators.validateWeight(value ?? ""),
          futuristic: true,
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
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) =>
                    Validators.validateDimension(value ?? "", "Length"),
                futuristic: true,
              ),
            ),
            SizedBox(width: constraint.maxWidth * 0.02),
            Expanded(
              child: InputFieldNew(
                controller: width,
                hintText: 'Width',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) =>
                    Validators.validateDimension(value ?? "", "Width"),
                futuristic: true,
              ),
            ),
            SizedBox(width: constraint.maxWidth * 0.02),
            Expanded(
              child: InputFieldNew(
                controller: height,
                hintText: 'Height',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) =>
                    Validators.validateDimension(value ?? "", "Height"),
                futuristic: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}

class instock extends StatelessWidget {
  const instock({super.key, required this.isInStock});

  final ValueNotifier<bool> isInStock;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
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

class BrandIcons extends StatelessWidget {
  final String imageUrl;
  final String label;
  final bool isActive;

  const BrandIcons({
    super.key,
    required this.imageUrl,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 40,
            decoration: const BoxDecoration(
              // color: isActive ? Colors.black : const Color(0xFFF3F4F6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(30),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.fill,
                placeholder: (context, url) {
                  return const CircularProgressIndicator();
                },
                // color: isActive ? Colors.white : null,
                errorWidget: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium!.copyWith(color: Colors.black),
          ),
          const SizedBox10(),
        ],
      ),
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

class InputFieldNew extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool futuristic;

  const InputFieldNew({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.futuristic = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: futuristic ? Colors.grey[200] : Colors.grey[200],
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
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          color: futuristic ? Colors.black87 : Colors.black87,
          fontSize: 14.0,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: futuristic ? Colors.grey[600] : Colors.grey[600],
            fontSize: 14.0,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
