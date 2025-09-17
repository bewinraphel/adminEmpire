import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/fonts.dart';

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
    onPressed: () {
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
      crossAxisSpacing: 14,
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
