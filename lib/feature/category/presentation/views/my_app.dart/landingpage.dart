import 'dart:io';

import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/app_theme.dart';
import 'package:empire/core/utilis/constants.dart';

import 'package:empire/feature/auth/domain/usecase/Login_status_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_gallery_usecase.dart';
import 'package:empire/feature/auth/presentation/bloc/profile_image_bloc.dart';

import 'package:empire/feature/auth/presentation/view/login_page.dart';
import 'package:empire/feature/category/domain/usecase/categories/adding_category_usecase.dart';

import 'package:empire/feature/category/domain/usecase/categories/get_category_usecase.dart';

import 'package:empire/feature/category/domain/usecase/categories/getting_subcategory_usecase.dart';

import 'package:empire/feature/auth/presentation/bloc/login_status_bloc.dart';

import 'package:empire/feature/category/presentation/bloc/category_bloc/adding_category.dart';

import 'package:empire/feature/category/presentation/bloc/category_bloc/get_category_bloc.dart';
import 'package:empire/feature/category/presentation/bloc/category_bloc/get_subcategory.dart';

import 'package:empire/feature/homepage/presentation/view/home_page.dart';
import 'package:empire/feature/product/data/datasource/add_product_data_source.dart';
import 'package:empire/feature/product/data/repository/add_product_respository.dart';
import 'package:empire/feature/product/domain/usecase/product/add_product_usecae.dart';
import 'package:empire/feature/product/presentation/bloc/add_product_bloc/add_product.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _MyAppState();
}

class _MyAppState extends State<LandingPage> {
  @override
  void initState() {
    preloading();
  }

  preloading() async {
    await Future.delayed(const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
 
        BlocProvider<ImageAuth>(
          create: (_) =>
              ImageAuth(sl<PickImageFromCamera>(), sl<PickImageFromGallery>()),
        ),
       
        BlocProvider(
          create: (context) => ProductBloc(
            AddProductUseCase(ProductRepositoryImpl(sl<ProductDataSource>())),
          ),
        ),

        BlocProvider<CategoryBloc>(
          create: (_) =>
              CategoryBloc(sl<CategoryUsecase>())..add(GetCategoryEvent()),
        ),
       
        BlocProvider<AddingcategoryEventBloc>(
          create: (_) => AddingcategoryEventBloc(sl<AddingcategoryUseCase>()),
        ),

        BlocProvider<SubCategoryBloc>(
          create: (_) => SubCategoryBloc(sl<GettingSubcategoryUsecase>()),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,

        home: BlocProvider(
          create: (_) =>
              AuthBlocStatus(sl<CheckLoginStatus>())
                ..add(CheckingLoginStatusevent()),
          child: BlocBuilder<AuthBlocStatus, LoginStatusState>(
            builder: (context, state) {
              if (state is SucessLoginStatusState) {
                return const HomePage();
              } else if (state is NotLoginState) {
                return Loginpage();
              } else {
                return Image.asset(Constants.landingImage);
              }
            },
          ),
        ),
      ),
    );
  }
}
