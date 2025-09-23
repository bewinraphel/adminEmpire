import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/commonvalidator.dart';
import 'package:empire/core/utilis/constants.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/core/utilis/widgets.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_gallery_usecase.dart';
import 'package:empire/feature/auth/presentation/bloc/login_bloc.dart';

import 'package:empire/feature/auth/presentation/bloc/profile_image_bloc.dart';

import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/domain/usecase/product/add_product_usecae.dart';
import 'package:empire/feature/product/presentation/bloc/add_product_bloc/add_brand.dart';
import 'package:empire/feature/product/presentation/bloc/add_product_bloc/brand.dart';

import 'package:empire/feature/product/presentation/views/add_product.dart/add_product.dart';
import 'package:empire/feature/product/domain/repository/prodcuct_call_repository.dart';
import 'package:empire/feature/product/domain/usecase/productcaliing_usecase.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc.dart';
import 'package:empire/feature/product/presentation/views/add_product.dart/widgets.dart';
import 'package:empire/feature/product/presentation/views/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductScreen extends StatelessWidget {
  String? mainCategoryId;
  String? subcategory;
  ProductScreen({super.key, this.subcategory, this.mainCategoryId});
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController brandImage = TextEditingController();
  TextEditingController brandname = TextEditingController();
  final brandKey = GlobalKey<FormState>();
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductcalingBloc>(
          create: (_) =>
              ProductcalingBloc(
                ProductcallingUsecase(sl<ProdcuctsRepository>()),
              )..add(
                ProductCallingEvent(
                  mainCategoryId: mainCategoryId!,
                  subCategoryId: subcategory!,
                ),
              ),
        ),
        BlocProvider(
          create: (context) =>
              BrandBloc(sl<ProductcallingUsecase>(), sl<AddProductUseCase>())
                ..add(
                  BrandFetching(
                    mainCategoryId: mainCategoryId!,
                    subCategoryId: subcategory!,
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
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<ProductcalingBloc>().add(
            ProductCallingEvent(
              mainCategoryId: mainCategoryId!,
              subCategoryId: subcategory!,
            ),
          );
          context.read<BrandBloc>().add(
            BrandFetching(
              mainCategoryId: mainCategoryId!,
              subCategoryId: subcategory!,
            ),
          );
          await Future.delayed(const Duration(milliseconds: 600));
        },
        child: Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoRs.elevatedButtonColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AddProdutsPage(
                        mainCategoryId: mainCategoryId,
                        id: subcategory,
                      );
                    },
                  ),
                );
              },
              child: const Text(
                'Add prodcut',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: ColoRs.whiteColor,
                  fontFamily: Fonts.raleway,
                ),
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.grey[300],
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            title: const Text('', style: TextStyle(color: Colors.black)),
            centerTitle: true,
          ),
          body: Builder(
            builder: (context) {
              return SingleChildScrollView(
                reverse: true,
                child: BlocBuilder<ProductcalingBloc, Productstate>(
                  builder: (context, state) {
                    if (state is ProductError) {
                      return Center(child: Text(state.messange));
                    }
                    if (state is Productfetched) {
                      return Builder(
                        builder: (context) {
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final isWideScreen = constraints.maxWidth > 600;
                              final maxWidth = isWideScreen
                                  ? 480.0
                                  : constraints.maxWidth * 0.9;
                              return Container(
                                margin: const EdgeInsets.only(
                                  left: 9,
                                  right: 9,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    sreach(),
                                    Row(
                                      children: [
                                        brand(
                                          context,
                                          maxWidth,

                                          label: brandname.text,
                                        ),

                                        // Product(context, state),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  SizedBox Product(BuildContext context, Productfetched state) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.80,
      child: Column(
        children: [
          const Text(
            'New Product',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          state.products.isEmpty
              ? const SizedBox()
              : GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 1.0,
                    childAspectRatio: 1 / .60,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ProductDetailsPage(
                                product: state.products[index],
                                mainCategoryId: mainCategoryId,
                                subcategory: subcategory,
                              );
                            },
                          ),
                        );
                      },
                      child: ProductCard(
                        imageUrl: state.products[index].images.first == []
                            ? null
                            : state.products[index].images.first,
                        title: state.products[index].name,
                        discount: state.products[index].discountPrice
                            .toString(),
                        price: state.products[index].price,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  SizedBox brand(
    BuildContext context,
    double maxWidth, {

    required String label,
  }) {
    File? image;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.20,
      child: BlocBuilder<BrandBloc, BrandState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return const CircularProgressIndicator();
          } else if (state is LoadedBrand) {
            if (state.brands.isEmpty) {
              return const Center(child: Text('No Brand '));
            } else {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
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
                    child: ListView.builder(
                      shrinkWrap: true,

                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.brands.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return BrandIcon(
                          imageUrl: state.brands[index].imageUrl,
                          label: state.brands[index].label,
                          isActive: true,
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final brands = context.read<BrandBloc>();
                      final brandImage = context.read<BrandImageAuth>();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        useSafeArea: true,
                        builder: (bottomSheetContext) {
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider.value(value: brands),
                              BlocProvider.value(value: brandImage),
                            ],
                            child: SlideInUp(
                              duration: const Duration(milliseconds: 150),
                              child: SingleChildScrollView(
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
                                        Builder(
                                          builder: (context) {
                                            return BlocBuilder<
                                              BrandImageAuth,
                                              BrandImagePickerState
                                            >(
                                              builder: (context, state) {
                                                if (state
                                                    is BrandImagePickedSuccess) {
                                                  image = File(state.image);
                                                }

                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 16),

                                                    Text(
                                                      'Upload Brand Image',
                                                      style: GoogleFonts.inter(
                                                        color: const Color(
                                                          0xFF111418,
                                                        ),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        letterSpacing:
                                                            -0.015 * 18,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                            maxWidth: maxWidth,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: const Color(
                                                            0xFFD5DBE2,
                                                          ),
                                                          width: 2,
                                                          style:
                                                              BorderStyle.solid,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 56,
                                                            horizontal: 24,
                                                          ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          if (image != null)
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                              child: Image.file(
                                                                image!,
                                                                width: 380,
                                                                height: 200,
                                                                fit: BoxFit
                                                                    .cover,
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
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    letterSpacing:
                                                                        -0.015 *
                                                                        18,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
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
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ],
                                                            ),
                                                          const SizedBox(
                                                            height: 24,
                                                          ),
                                                          const SizedBox(
                                                            height: 24,
                                                          ),
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  ColoRs
                                                                      .elevatedButtonColor,
                                                              foregroundColor:
                                                                  ColoRs
                                                                      .whiteColor,
                                                              textStyle:
                                                                  GoogleFonts.inter(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    letterSpacing:
                                                                        0.015 *
                                                                        14,
                                                                  ),
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        16,
                                                                    vertical:
                                                                        10,
                                                                  ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      10,
                                                                    ),
                                                              ),
                                                              minimumSize:
                                                                  const Size(
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
                                        const SizedBox(height: 24),
                                        const Align(
                                          alignment: Alignment.topLeft,
                                          child: Titlesnew(
                                            nametitle: 'Add Brand',
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Form(
                                          key: brandKey,
                                          child: InputFieldNew(
                                            controller: brandname,
                                            hintText: 'Enter new Brand',
                                            validator: (value) =>
                                                Validators.validateString(
                                                  value ?? "",
                                                  'Brand',
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 20.0),
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
                                            if (brandKey.currentState!
                                                .validate()) {
                                              context.read<BrandBloc>().add(
                                                BrandAdding(
                                                  mainCategoryId:
                                                      mainCategoryId!,
                                                  subCategoryId: subcategory!,
                                                  brand: Brand(
                                                    imageUrl: image!.path,
                                                    label: label,
                                                  ),
                                                ),
                                              );
                                              context.read<BrandBloc>().add(
                                                BrandFetching(
                                                  mainCategoryId:
                                                      mainCategoryId!,
                                                  subCategoryId: subcategory!,
                                                ),
                                              );
                                              context.read<BrandImageAuth>().add(
                                                ClearPickedBrandImageEvent(),
                                              );
                                              brandname.clear();
                                              Navigator.pop(context);
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 20.0),
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

                    icon: const Icon(Icons.add_circle_outline, size: 38),
                  ),
                ],
              );
            }
          }

          return const CircleAvatar();
        },
      ),
    );
  }

  Container sreach() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          filled: true,
          fillColor: const Color(0xFFF3F4F6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class BrandIcon extends StatelessWidget {
  final String imageUrl;
  final String label;
  final bool isActive;

  const BrandIcon({
    super.key,
    required this.imageUrl,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
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

class ProductCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String discount;
  final double price;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.discount,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        padding: const EdgeInsets.all(12),
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
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl == null
                  ? const Icon(Icons.image)
                  : CachedNetworkImage(
                      fit: BoxFit.fill,
                      height: 100,
                      width: 100,
                      placeholder: (BuildContext context, String url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                      imageUrl: imageUrl!,
                    ),
            ),
            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70,
                  child: Text(
                    limitWords(title, 6),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 70,
                  child: Text(
                    limitWords('\u0025${discount.toString()}', 6),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 70,
                  child: Text(
                    limitWords('\u{20B9}${price.toString()}', 4),

                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
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
}
