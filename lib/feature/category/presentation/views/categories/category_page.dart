import 'dart:async';

import 'package:empire/feature/category/presentation/bloc/category_bloc/get_category_bloc.dart';

import 'package:empire/feature/category/presentation/views/categories/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category')),
      floatingActionButton: buildAddCategoryButton(context),

      body: RefreshIndicator(
        onRefresh: () async {
          final completer = Completer<void>();
          context.read<CategoryBloc>().add(GetCategoryEvent());
          context
              .read<CategoryBloc>()
              .stream
              .firstWhere(
                (state) =>
                    state is CategoryLoadedState || state is CategoryErrorState,
              )
              .then((_) => completer.complete());
          return completer.future;
        },
        child: SafeArea(
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoadingState) {
                return buildShimmerLoading();
              } else if (state is CategoryErrorState) {
                return buildErrorState(context, state.error);
              } else if (state is CategoryLoadedState) {
                if (state.categories.isEmpty) {
                  return const Center(child: Text("No categories available."));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return CategoryItems(category: category);
                  },
                );
              }
              return buildShimmerLoading();
            },
          ),
        ),
      ),
    );
  }
}
