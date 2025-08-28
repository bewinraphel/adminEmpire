import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/feature/category/domain/entities/category_entities.dart';

import 'package:empire/feature/category/presentation/bloc/category_bloc/get_category_bloc.dart';
import 'package:empire/feature/category/presentation/bloc/category_bloc/get_subcategory.dart';

import 'package:empire/feature/category/presentation/views/add_subcategorys.dart/subcatergory_adding.dart';
import 'package:empire/feature/category/presentation/views/add_subcategorys.dart/widget.dart';
import 'package:empire/feature/category/presentation/views/categories/widgets.dart';
import 'package:empire/feature/product/presentation/views/product_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';

class AddSubcategory extends StatelessWidget {
  CategoryEntities category;

  AddSubcategory({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoRs.whiteColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        title: Text(
          category.category,
          style: GoogleFonts.inter(
            color: const Color(0xFF111418),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.015 * 18,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColoRs.elevatedButtonColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AddCategoryWidget(id: category.uid);
                },
              ),
            );
          },
          child: const Text(
            'Add SubCategory',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: ColoRs.whiteColor,
              fontFamily: Fonts.raleway,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<SubCategoryBloc>().add(
            GetSubCategoryEvent(category.uid),
          );
          await Future.delayed(const Duration(milliseconds: 600));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products',
                    hintStyle: GoogleFonts.inter(
                      color: const Color(0xFF5D7389),
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF5D7389),
                      size: 24,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFEAEDF1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  ' Categories',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF111418),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.015 * 18,
                  ),
                ),
              ),
              BlocBuilder<SubCategoryBloc, SubCategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoadingState) {
                    return buildShimmerLoading();
                  } else if (state is SubCategoryErrorState) {
                    return buildErrorState(context, state.error);
                  } else if (state is SubCategoryLoadedState) {
                    if (state.categories.isEmpty) {
                      return const Center(
                        child: Text("No categories available."),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Wrap(
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ProductScreen(
                                      mainCategoryId: category.uid,
                                      subcategory: doc.uid,
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
