import 'dart:io';
import 'dart:typed_data';

import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/widgets.dart';

import 'package:empire/feature/category/domain/entities/category_entities.dart';
import 'package:empire/feature/category/domain/usecase/categories/getting_subcategory_usecase.dart';

import 'package:empire/feature/category/presentation/bloc/category_bloc/get_category_bloc.dart';
import 'package:empire/feature/category/presentation/bloc/category_bloc/get_subcategory.dart';

import 'package:empire/feature/category/presentation/views/add_subcategorys.dart/subcategory_page.dart';
import 'package:empire/feature/category/presentation/views/add_subcategorys.dart/widget.dart';
import 'package:empire/feature/category/presentation/views/categories/add_category_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

Widget buildAddCategoryButton(BuildContext context) {
  return FloatingActionButton(
    backgroundColor: ColoRs.buttoncolor,
    onPressed: () async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return AddCategory();
          },
        ),
      );
    },
    mini: true,
    child: const Icon(Icons.add, color: Colors.white, size: 25),
  );
}

Widget buildShimmerLoadingweb() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('.......')],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 7,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.23,
                  margin: const EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget buildShimmerLoading() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('.......')],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 7,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.23,
                  margin: const EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

class BuildShimmerLoading extends StatelessWidget {
  const BuildShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 17),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.24,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 17,
                  horizontal: 17,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox20(),
                    Container(
                      height: 10,
                      width: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    const SizedBox10(),
                    SizedBox(
                      height: 130,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,

                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.23,
                            margin: const EdgeInsets.only(right: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: const SizedBox(height: 40),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    const SizedBox(height: 10),
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

class BuildShimmerLoadingweb extends StatelessWidget {
  final BoxConstraints constraints;
  const BuildShimmerLoadingweb({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, int index) {
        return Container(
          margin: EdgeInsets.only(
            left: constraints.maxWidth * 0.20,
            right: constraints.maxWidth * 0.20,
          ),
          height: MediaQuery.of(context).size.height * 0.24,
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox20(),
                  Container(
                    height: 10,
                    width: 100,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                  const SizedBox10(),
                  SizedBox(
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,

                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.23,
                          margin: const EdgeInsets.only(right: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: const SizedBox(height: 40),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget buildErrorState(BuildContext context, String error) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(error),
      const SizedBox(height: 8),
      TextButton(
        onPressed: () {
          context.read<CategoryBloc>().add(GetCategoryEvent());
        },
        child: const Text('Retry'),
      ),
    ],
  );
}

Widget buildCategoryList(BuildContext context, CategoryLoadedState state) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(8),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 6,
      childAspectRatio: 0.8,
    ),
    itemCount: state.categories.length,
    itemBuilder: (context, index) {
      final doc = state.categories[index];

      return CategoryItem(
        doc: doc,
        isSelectedSelector: (state) =>
            state is CategoryLoadedState && state.selectedCategoryId == doc.uid,
        onTap: () {
          context.read<CategoryBloc>().add(SelectedCategoryEvent(doc.uid));
          context.read<SubCategoryBloc>().add(GetSubCategoryEvent(doc.uid));

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AddSubcategory(category: doc, maincategoryName: doc.category),
            ),
          );
        },
      );
    },
  );
}

class CategoryItems extends StatelessWidget {
  final bool isDestop;
  final CategoryEntities category;

  const CategoryItems({
    super.key,
    required this.category,
    required this.isDestop,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SubCategoryBloc(sl<GettingSubcategoryUsecase>())
            ..add(GetSubCategoryEvent(category.uid)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.category,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<SubCategoryBloc, SubCategoryState>(
              builder: (context, state) {
                if (state is SubCategoryLoadingState) {
                  return const BuildShimmerLoading();
                } else if (state is SubCategoryErrorState) {
                  return buildErrorState(context, state.error);
                } else if (state is SubCategoryLoadedState) {
                  if (state.categories.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          const Text("No subcategories available."),
                          IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddSubcategory(
                                  category: category,
                                  subCategory: null,
                                  maincategoryName: category.category,
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox(
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final subCategory = state.categories[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddSubcategory(
                                category: category,
                                subCategory: subCategory,
                                maincategoryName: category.category,
                              ),
                            ),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.23,
                            margin: const EdgeInsets.only(right: 3),
                            decoration: BoxDecoration(
                              color: ColoRs.fieldcolor,
                              borderRadius: _getBorderRadius(
                                index,
                                state.categories.length,
                              ),
                            ),
                            child: OptimizedNetworkImage(
                              imageUrl: state.categories[index].imageUrl,
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
                          ),
                        );
                      },
                    ),
                  );
                }
                return buildShimmerLoading();
              },
            ),
          ],
        ),
      ),
    );
  }

  BorderRadius _getBorderRadius(int index, int length) {
    if (index == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      );
    } else if (index == length - 1) {
      return const BorderRadius.only(
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12),
      );
    }
    return BorderRadius.zero;
  }
}

class CategoryItemsweb extends StatelessWidget {
  final bool isDestop;
  final CategoryEntities category;
  final BoxConstraints constraints;

  const CategoryItemsweb({
    super.key,
    required this.category,
    required this.constraints,
    required this.isDestop,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SubCategoryBloc(sl<GettingSubcategoryUsecase>())
            ..add(GetSubCategoryEvent(category.uid)),
      child: Container(
        margin: EdgeInsets.only(
          left: constraints.maxWidth * 0.20,
          right: constraints.maxWidth * 0.20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.category,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<SubCategoryBloc, SubCategoryState>(
              builder: (context, state) {
                if (state is SubCategoryLoadingState) {
                  return const BuildShimmerLoading();
                } else if (state is SubCategoryErrorState) {
                  return buildErrorState(context, state.error);
                } else if (state is SubCategoryLoadedState) {
                  if (state.categories.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          const Text("No subcategories available."),
                          IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddSubcategory(
                                  category: category,
                                  subCategory: null,
                                  maincategoryName: category.category,
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox(
                    height: constraints.maxWidth * 0.07,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final subCategory = state.categories[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddSubcategory(
                                category: category,
                                subCategory: subCategory,
                                maincategoryName: category.category,
                              ),
                            ),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.07,
                            margin: const EdgeInsets.only(right: 3),
                            decoration: BoxDecoration(
                              color: ColoRs.fieldcolor,
                              borderRadius: _getBorderRadius(
                                index,
                                state.categories.length,
                              ),
                            ),
                            child: OptimizedNetworkImage(
                              imageUrl: state.categories[index].imageUrl,
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
                          ),
                        );
                      },
                    ),
                  );
                }
                return buildShimmerLoading();
              },
            ),
          ],
        ),
      ),
    );
  }

  BorderRadius _getBorderRadius(int index, int length) {
    if (index == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      );
    } else if (index == length - 1) {
      return const BorderRadius.only(
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12),
      );
    }
    return BorderRadius.zero;
  }
}

Widget buildPlaceholder() {
  return const Column(
    children: [
      SizedBox(height: 30),
      Icon(Icons.cloud_upload_outlined, size: 50),
      Text('Upload Cover'),
      SizedBox(height: 5),
      Text('Click here to upload cover photo'),
      SizedBox(height: 30),
    ],
  );
}

Widget buildImagePreview(dynamic image) {
  if (image is Uint8List) {
    // WEB
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Image.memory(image, height: 200, width: 300, fit: BoxFit.cover),
    );
  }

  if (image is String && image.startsWith('assets/')) {
  
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Image.asset(image, height: 200, width: 300, fit: BoxFit.cover),
    );
  }

  if (image is String && image.startsWith('http')) {
 
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Image.network(image, height: 200, width: 300, fit: BoxFit.cover),
    );
  }

  if (image is String) {
 
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Image.file(
        File(image),
        height: 200,
        width: 300,
        fit: BoxFit.cover,
      ),
    );
  }

  return const Text("Invalid image format");
}
