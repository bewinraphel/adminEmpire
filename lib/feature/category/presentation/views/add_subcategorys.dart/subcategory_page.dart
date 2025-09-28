import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/color.dart';

import 'package:empire/feature/category/domain/entities/category_entities.dart';
import 'package:empire/feature/category/domain/usecase/categories/getting_subcategory_usecase.dart';

import 'package:empire/feature/category/presentation/bloc/category_bloc/get_subcategory.dart';

import 'package:empire/feature/category/presentation/views/add_subcategorys.dart/widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddSubcategory extends StatelessWidget {
  CategoryEntities category;
  CategoryEntities? subCategory;
  String? maincategoryName;
  AddSubcategory({super.key, required this.category, this.subCategory,required this.maincategoryName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SubCategoryBloc>(
      create: (context) =>
          SubCategoryBloc(sl<GettingSubcategoryUsecase>())
            ..add(GetSubCategoryEvent(category.uid)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: ColoRs.whiteColor,
            appBar: appbar(category.category),
            bottomNavigationBar: addSubcategory(context, category),
            body: RefreshIndicator(
              onRefresh: () => refresh(context, category),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [searchProduct(), categorySection(category,maincategoryName!)],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
