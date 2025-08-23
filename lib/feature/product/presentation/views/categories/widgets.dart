import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/feature/product/presentation/bloc/category_bloc/get_category_bloc.dart';
import 'package:empire/feature/product/presentation/bloc/category_bloc/get_subcategory.dart';

import 'package:empire/feature/product/presentation/views/add_subcategorys.dart/subcategory_page.dart';
import 'package:empire/feature/product/presentation/views/add_subcategorys.dart/widget.dart';
import 'package:empire/feature/product/presentation/views/categories/add_category_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

Widget buildAddCategoryButton(BuildContext context) {
  return Center(
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddCategory()),
        );
      },
      child: Container(
        width: double.infinity,
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
              'Add Category',
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
  );
}

/// Shimmer Loader
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

/// Error State Widget
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

/// Category List
Widget buildCategoryList(BuildContext context, CategoryLoadedState state) {
  return Wrap(
    alignment: WrapAlignment.start,
    spacing: 14,
    runSpacing: 14,
    children: state.categories.map((doc) {
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
              builder: (_) => AddSubcategory(mainCtiegoryid: doc.uid),
            ),
          );
        },
      );
    }).toList(),
  );
}
