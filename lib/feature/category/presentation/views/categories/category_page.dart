import 'package:empire/feature/category/presentation/bloc/category_bloc/get_category_bloc.dart';
import 'package:empire/feature/category/presentation/views/categories/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

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
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CategoryBloc>().add(GetCategoryEvent());

          await Future.delayed(const Duration(milliseconds: 600));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
    );
  }
}
