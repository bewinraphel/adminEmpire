import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/presentation/bloc/category_bloc/get_category_bloc.dart';
import 'package:empire/presentation/views/add_product.dart/add_category.dart';
import 'package:empire/presentation/views/add_product.dart/widgets.dart';
import 'package:empire/presentation/views/add_subcategorys.dart/add_subcategory.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});

  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final double maxWidth = MediaQuery.of(context).size.width < 450
        ? MediaQuery.of(context).size.width * 0.92
        : 400;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        title: const Text(
          'Category',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: maxWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 26),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Add_Category();
                          },
                        ),
                      );
                    },
                    child: Container(
                      width: 2000,
                      height: 190,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.black38,
                          style: BorderStyle.solid,
                          width: 1.2,
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 38, color: Colors.black45),
                          SizedBox(height: 6),
                          Text(
                            'Category',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoadingState) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: const Column(
                          children: [
                            SizedBox(width: 180, height: 120),
                            Text(
                              '...........,',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: Fonts.raleway,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is CategoryErrorState) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.error),
                          TextButton(
                            onPressed: () => context.read<CategoryBloc>().add(
                              GetCategoryEvent(),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      );
                    } else if (state is CategoryLoadedState) {
                      return Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 14,
                        runSpacing: 14,
                        children: state.categories.map((doc) {
                          return CategoryItem(
                            doc: doc,
                            isSelectedSelector: (state) =>
                                state is CategoryLoadedState &&
                                state.selectedCategoryId == doc.uid,
                            onTap: () {
                              context.read<CategoryBloc>().add(
                                SelectedCategoryEvent(doc.uid),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AddSubcategory(id: doc.uid);
                                  },
                                ),
                              );
                            },
                          );
                        }).toList(),
                      );
                    }
                    return const Text('No categories found');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
