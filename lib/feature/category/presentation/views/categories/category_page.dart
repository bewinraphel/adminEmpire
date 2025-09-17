import 'package:empire/core/di/service_locator.dart';
import 'package:empire/feature/category/domain/usecase/categories/getting_subcategory_usecase.dart';
import 'package:empire/feature/category/presentation/bloc/category_bloc/get_category_bloc.dart';
import 'package:empire/feature/category/presentation/bloc/category_bloc/get_subcategory.dart';
import 'package:empire/feature/category/presentation/views/add_subcategorys.dart/subcategory_page.dart';
import 'package:empire/feature/category/presentation/views/categories/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreens extends StatelessWidget {
  const CategoryScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final double maxWidth = MediaQuery.of(context).size.width < 450
        ? MediaQuery.of(context).size.width * 0.92
        : 400;

    return Scaffold(
      floatingActionButton: buildAddCategoryButton(context),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Category',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: buildAddCategoryButton(context),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CategoryBloc>().add(GetCategoryEvent());

          await Future.delayed(const Duration(milliseconds: 600));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Container(
              width: maxWidth,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoadingState) {
                    return buildShimmerLoading();
                  } else if (state is CategoryErrorState) {
                    return buildErrorState(context, state.error);
                  } else if (state is CategoryLoadedState) {
                    if (state.categories.isEmpty) {
                      return const Center(
                        child: Text("No categories available."),
                      );
                    }
                    return buildCategoryList(context, state);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category')),
      floatingActionButton: buildAddCategoryButton(context),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CategoryBloc>().add(GetCategoryEvent());

          await Future.delayed(const Duration(milliseconds: 600));
        },
        child: SafeArea(
          child: Column(
            children: [
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoadingState) {
                    return buildShimmerLoading();
                  } else if (state is CategoryErrorState) {
                    return buildErrorState(context, state.error);
                  } else if (state is CategoryLoadedState) {
                    if (state.categories.isEmpty) {
                      return const Center(
                        child: Text("No categories available."),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.categories.length,
                      itemBuilder: (context, indexs) {
                        final category = state.categories[indexs];

                        return BlocProvider<SubCategoryBloc>(
                          create: (context) =>
                              SubCategoryBloc(sl<GettingSubcategoryUsecase>())
                                ..add(GetSubCategoryEvent(category.uid)),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            category.category,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.chevron_right,
                                            size: 24,
                                          ),
                                        ],
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
                                      return buildErrorState(
                                        context,
                                        state.error,
                                      );
                                    } else if (state
                                        is SubCategoryLoadedState) {
                                      if (state.categories.isEmpty) {
                                        return Center(
                                          child: Column(
                                            children: [
                                              const Text(
                                                "No categories available.",
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          AddSubcategory(
                                                            category: category,
                                                          ),
                                                    ),
                                                  );
                                                },
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
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),

                                          itemCount: state.categories.length,
                                          itemBuilder: (context, index) {
                                            final subCategory =
                                                state.categories;
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        AddSubcategory(
                                                          category: category,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: 100,
                                                padding: const EdgeInsets.only(
                                                  right: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius: index == 0
                                                      ? const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                12,
                                                              ),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                12,
                                                              ),
                                                        )
                                                      : index ==
                                                            subCategory.length -
                                                                1
                                                      ? const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                12,
                                                              ),
                                                          bottomRight:
                                                              Radius.circular(
                                                                12,
                                                              ),
                                                        )
                                                      : const BorderRadius.all(
                                                          Radius.circular(0),
                                                        ),
                                                  color: Colors.grey[200],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: index == 0
                                                      ? const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                12,
                                                              ),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                12,
                                                              ),
                                                        )
                                                      : index ==
                                                            subCategory.length -
                                                                1
                                                      ? const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                12,
                                                              ),
                                                          bottomRight:
                                                              Radius.circular(
                                                                12,
                                                              ),
                                                        )
                                                      : const BorderRadius.all(
                                                          Radius.circular(0),
                                                        ),
                                                  child: Image.network(
                                                    subCategory[index].imageUrl,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return Container(
                                                            color: Colors
                                                                .grey[300],
                                                            child: Icon(
                                                              Icons.image,
                                                              color: Colors
                                                                  .grey[500],
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
                      },
                    );
                  }
                  return buildShimmerLoading();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
