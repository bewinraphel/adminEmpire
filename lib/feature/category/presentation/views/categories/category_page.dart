import 'dart:async';

import 'package:empire/core/di/service_locator.dart';
import 'package:empire/feature/category/domain/usecase/categories/get_category_usecase.dart';
import 'package:empire/feature/category/presentation/bloc/category_bloc/get_category_bloc.dart';

import 'package:empire/feature/category/presentation/views/categories/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryBloc>(
      create: (_) =>
          CategoryBloc(sl<CategoryUsecase>())..add(GetCategoryEvent()),
      child: Scaffold(
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
                      state is CategoryLoadedState ||
                      state is CategoryErrorState,
                )
                .then((_) => completer.complete());
            return completer.future;
          },
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool isDeskdop = constraints.maxWidth > 1200;
                return BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoadingState) {
                      return isDeskdop
                          ? BuildShimmerLoadingweb(constraints: constraints)
                          : const BuildShimmerLoading();
                    } else if (state is CategoryErrorState) {
                      return buildErrorState(context, state.error);
                    } else if (state is CategoryLoadedState) {
                      if (state.categories.isEmpty) {
                        return const Center(
                          child: Text("No categories available."),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.categories.length,
                          itemBuilder: (context, index) {
                            final category = state.categories[index];
                            return isDeskdop
                                ? RepaintBoundary(
                                    child: CategoryItemsweb(
                                      category: category,
                                      isDestop: isDeskdop,
                                      constraints: constraints,
                                    ),
                                  )
                                : CategoryItems(
                                    category: category,
                                    isDestop: isDeskdop,
                                  );
                          },
                        );
                      }
                    }
                    return const CircularProgressIndicator();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
