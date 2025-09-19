import 'dart:async';

import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/fonts.dart';
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

Widget buildShimmerLoading() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: const Column(
      children: [
        SizedBox(width: 180, height: 120),
        Text(
          '...........',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: Fonts.raleway, fontSize: 13),
        ),
      ],
    ),
  );
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
            MaterialPageRoute(builder: (_) => AddSubcategory(category: doc)),
          );
        },
      );
    },
  );
}
class CategoryItems extends StatelessWidget {
  final CategoryEntities category;

  const CategoryItems({required this.category});

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
                  return buildShimmerLoading();
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
                              ),
                            ),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.23,
                            margin: const EdgeInsets.only(right: 3),
                            decoration: BoxDecoration(
                              borderRadius: _getBorderRadius(
                                index,
                                state.categories.length,
                              ),
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            child: ClipRRect(
                              borderRadius: _getBorderRadius(
                                index,
                                state.categories.length,
                              ),
                              child: Image.network(
                                subCategory.imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Shimmer(
                                          child: child,
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black,
                                              Colors.white,
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceVariant,
                                    child: Icon(
                                      Icons.image,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                      size: 40,
                                    ),
                                  );
                                },
                              ),
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