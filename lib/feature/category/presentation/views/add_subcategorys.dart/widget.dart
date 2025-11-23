import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/core/utilis/widgets.dart';
import 'package:empire/feature/category/domain/entities/category_entities.dart';
import 'package:empire/feature/category/presentation/bloc/category_bloc/get_category_bloc.dart';
import 'package:empire/feature/category/presentation/bloc/category_bloc/get_subcategory.dart';
import 'package:empire/feature/category/presentation/views/add_subcategorys.dart/subcatergory_adding.dart';
import 'package:empire/feature/category/presentation/views/categories/widgets.dart';
import 'package:empire/feature/product/presentation/views/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ProductItem extends StatelessWidget {
  final String name;
  final double price;
  final int stock;
  final String imageUrl;

  const ProductItem({
    super.key,
    required this.name,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF111418),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\$${price.toStringAsFixed(2)} | $stock in stock',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF5D7389),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubCategoryShimmer extends StatelessWidget {
  const SubCategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.50,
        height: MediaQuery.of(context).size.height * 0.29,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Column(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.20,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 4,
                        color: const Color(0xFFF5F5F5),
                      ),
                    ),
                    const SizedBox10(),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 4,
                        color: const Color(0xFFF5F5F5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryItemweb extends StatelessWidget {
  final CategoryEntities doc;
  final bool Function(CategoryState) isSelectedSelector;
  final VoidCallback onTap;
  final bool isDesktop;

  const CategoryItemweb({
    super.key,
    required this.doc,
    required this.isSelectedSelector,
    required this.onTap,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CategoryBloc, CategoryState, bool>(
      selector: isSelectedSelector,
      builder: (context, isSelected) {
        return Container(
          decoration: BoxDecoration(
            color: ColoRs.fieldcolor,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: onTap,
              child: Column(
                children: [
                  Container(
                    height: isDesktop ? 90 : 90,
                    width: isDesktop ? 100 : 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: OptimizedNetworkImage(
                      imageUrl: doc.imageUrl,
                      errorWidget: const Icon(Icons.error),
                      borderRadius: 7,
                      fit: BoxFit.fill,
                      placeholder: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: const SizedBox(height: 80, width: 85),
                      ),
                      widthQueryParam: 'resize_width',
                    ),
                    // ClipRRect(
                    //   borderRadius: BorderRadiusGeometry.circular(8),
                    //   child: CachedNetworkImage(
                    //     imageUrl: doc.imageUrl,

                    //     fit: BoxFit.fill,
                    //     placeholder: (context, url) {
                    //       return const CircularProgressIndicator();
                    //     },
                    //     errorWidget: (context, url, error) =>
                    //         const Icon(Icons.error),
                    //   ),
                    // ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.0020),
                  Text(
                    doc.category,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.bold,
                      fontFamily: 'Raleway',
                      fontSize: 15,
                      color: isSelected ? ColoRs.black87 : ColoRs.black,
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
}

class CategoryItem extends StatelessWidget {
  final CategoryEntities doc;
  final bool Function(CategoryState) isSelectedSelector;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.doc,
    required this.isSelectedSelector,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CategoryBloc, CategoryState, bool>(
      selector: isSelectedSelector,
      builder: (context, isSelected) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              const BoxShadow(
                color: Colors.black12,
                offset: Offset(5, 5),
                blurRadius: 10,
              ),
              BoxShadow(
                color: isSelected ? Colors.white : Colors.white70,
                offset: const Offset(-5, -5),
                blurRadius: 10,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: onTap,
              child: Column(
                children: [
                  Container(
                    height: isSelected ? 100 : 170,
                    width: isSelected ? 100 : 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: OptimizedNetworkImage(
                      imageUrl: doc.imageUrl,
                      errorWidget: const Icon(Icons.error),
                      borderRadius: 7,
                      fit: BoxFit.fill,
                      placeholder: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: const SizedBox(height: 80, width: 85),
                      ),
                      widthQueryParam: 'resize_width',
                    ),
                    // ClipRRect(
                    //   borderRadius: BorderRadiusGeometry.circular(8),
                    //   child: CachedNetworkImage(
                    //     imageUrl: doc.imageUrl,

                    //     fit: BoxFit.fill,
                    //     placeholder: (context, url) {
                    //       return const CircularProgressIndicator();
                    //     },
                    //     errorWidget: (context, url, error) =>
                    //         const Icon(Icons.error),
                    //   ),
                    // ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    doc.category,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                      fontFamily: 'Raleway',
                      fontSize: 15,
                      color: isSelected ? Colors.black87 : Colors.black45,
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
}

LayoutBuilder addSubcategory(BuildContext context, CategoryEntities category) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final bool isDeskdop = constraints.maxWidth > 1200;
      return isDeskdop
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.all(8),
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
                        return AddCategoryWidget(id: category.uid);
                      },
                    ),
                  );
                  context.read<SubCategoryBloc>().add(
                    GetSubCategoryEvent(category.uid),
                  );
                },
                child: const Text(
                  'Add SubCategory',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: ColoRs.whiteColor,
                    fontFamily: Fonts.raleway,
                  ),
                ),
              ),
            );
    },
  );
}

AppBar appbar(String title) {
  return AppBar(
    backgroundColor: const Color(0xFFF7F8FA),
    elevation: 0,
    title: Text(
      title,
      style: GoogleFonts.inter(
        color: const Color(0xFF111418),
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.015 * 18,
      ),
    ),
    centerTitle: true,
  );
}

Padding searchProduct() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Search products',
        hintStyle: GoogleFonts.inter(
          color: const Color(0xFF5D7389),
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xFF5D7389),
          size: 24,
        ),
        filled: true,
        fillColor: const Color(0xFFEAEDF1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
    ),
  );
}

Column categorySection(
  CategoryEntities category,
  String mainCatgoryName,
  bool isDesktop,
  BuildContext context,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ' Categories',
              style: GoogleFonts.inter(
                color: const Color(0xFF111418),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.015 * 18,
              ),
            ),
            isDesktop == false
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8),
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
                              return AddCategoryWidget(id: category.uid);
                            },
                          ),
                        );
                        context.read<SubCategoryBloc>().add(
                          GetSubCategoryEvent(category.uid),
                        );
                      },
                      child: const Text(
                        'Add SubCategory',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: ColoRs.whiteColor,
                          fontFamily: Fonts.raleway,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      BlocBuilder<SubCategoryBloc, SubCategoryState>(
        builder: (context, state) {
          if (state is SubCategoryLoadingState) {
            return const SubCategoryShimmer();
          } else if (state is SubCategoryErrorState) {
            return buildErrorState(context, state.error);
          } else if (state is SubCategoryLoadedState) {
            if (state.categories.isEmpty) {
              return const Center(child: Text("No categories available."));
            }
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 4 : 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: isDesktop
                      ? MediaQuery.of(context).size.aspectRatio * 0.90
                      : MediaQuery.of(context).size.aspectRatio * 1.60,
                ),
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final doc = state.categories[index];
                  return isDesktop
                      ? CategoryItemweb(
                          isDesktop: isDesktop,
                          doc: doc,
                          isSelectedSelector: (state) =>
                              state is CategoryLoadedState &&
                              state.selectedCategoryId == doc.uid,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ProductScreen(
                                    mainCategoryId: category.uid,
                                    subcategory: doc.uid,
                                    mainCategoryName: mainCatgoryName,
                                    subcategoryName: doc.category,
                                  );
                                },
                              ),
                            );
                          },
                        )
                      : CategoryItem(
                          doc: doc,
                          isSelectedSelector: (state) =>
                              state is CategoryLoadedState &&
                              state.selectedCategoryId == doc.uid,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ProductScreen(
                                    mainCategoryId: category.uid,
                                    subcategory: doc.uid,
                                    mainCategoryName: mainCatgoryName,
                                    subcategoryName: doc.category,
                                  );
                                },
                              ),
                            );
                          },
                        );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    ],
  );
}

Future<void> refresh(BuildContext context, CategoryEntities category) async {
  context.read<SubCategoryBloc>().add(GetSubCategoryEvent(category.uid));
  await Future.delayed(const Duration(milliseconds: 600));
}
