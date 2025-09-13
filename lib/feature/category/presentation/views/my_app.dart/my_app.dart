import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/app_theme.dart';

import 'package:empire/feature/auth/domain/usecase/Login_status_usecase.dart';
import 'package:empire/feature/auth/presentation/bloc/login_bloc.dart';
import 'package:empire/feature/auth/presentation/view/login_page.dart';
import 'package:empire/feature/category/domain/usecase/categories/adding_category_usecase.dart';
import 'package:empire/feature/category/domain/usecase/categories/adding_subcategory_usecase.dart';
import 'package:empire/feature/category/domain/usecase/categories/category_image_camera.dart';
import 'package:empire/feature/category/domain/usecase/categories/catgeroyimgae_gallery.dart';

import 'package:empire/feature/category/domain/usecase/categories/get_category_usecase.dart';

import 'package:empire/feature/auth/domain/usecase/login_auth_usecase.dart';
import 'package:empire/feature/category/domain/usecase/categories/getting_subcategory_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_gallery_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/register_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/save_login_status_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/send_otp_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/verify_user_usecase.dart';

import 'package:empire/feature/auth/presentation/bloc/login_status_bloc.dart';
import 'package:empire/feature/auth/presentation/bloc/loginpage_bloc.dart';
import 'package:empire/feature/auth/presentation/bloc/otp_bloc.dart';

import 'package:empire/feature/auth/presentation/bloc/profile_image_bloc.dart';
import 'package:empire/feature/auth/presentation/bloc/registerpage_bloc.dart';
import 'package:empire/feature/auth/presentation/bloc/savepassowrd_bloc.dart';
import 'package:empire/feature/category/presentation/bloc/category_bloc/adding_category.dart';
import 'package:empire/feature/category/presentation/bloc/category_bloc/adding_subcategory.dart';
import 'package:empire/feature/category/presentation/bloc/category_bloc/category_image.dart'
    show CategoryImageBloc;

import 'package:empire/feature/category/presentation/bloc/category_bloc/get_category_bloc.dart';
import 'package:empire/feature/category/presentation/bloc/category_bloc/get_subcategory.dart';

import 'package:empire/feature/homepage/presentation/view/home_page.dart';
import 'package:empire/feature/product/data/datasource/add_product_data_source.dart';
import 'package:empire/feature/product/data/repository/add_product_respository.dart';
import 'package:empire/feature/product/domain/usecase/product/add_product_usecae.dart';
import 'package:empire/feature/product/presentation/bloc/add_product_bloc/add_product.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) =>
              AuthBloc(sl<SigningWithGoogle>(), sl<SaveLoginStatus>()),
        ),
        BlocProvider<AuthBlocStatus>(
          create: (_) =>
              AuthBlocStatus(sl<CheckLoginStatus>())
                ..add(CheckingLoginStatusevent()),
        ),
        BlocProvider<ImageAuth>(
          create: (_) =>
              ImageAuth(sl<PickImageFromCamera>(), sl<PickImageFromGallery>()),
        ),
        BlocProvider<CategoryImageBloc>(
          create: (_) => CategoryImageBloc(
            sl<CategoryImageCamera>(),
            sl<CategoryImagegallery>(),
          ),
        ),
        BlocProvider(
          create: (context) => ProductBloc(
            AddProduct(ProductRepositoryImpl(sl<ProductDataSource>())),
          ),
        ),
        BlocProvider<RegisterBloc>(
          create: (_) => RegisterBloc(sl<CheckingUser>(), sl<VerifyNumber>()),
        ),
        BlocProvider<OtpBloc>(create: (_) => OtpBloc(sl<VerifyOtp>())),
        BlocProvider<SavePasswordBloc>(create: (_) => SavePasswordBloc(sl())),
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(sl(), sl<SaveLoginStatus>()),
        ),
        BlocProvider<CategoryBloc>(
          create: (_) =>
              CategoryBloc(sl<CategoryUsecase>())..add(GetCategoryEvent()),
        ),
        BlocProvider<SubcategoryBloc>(
          create: (_) => SubcategoryBloc(sl<AddingSubcategoryUsecase>()),
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

        home: BlocBuilder<AuthBlocStatus, LoginStatusState>(
          builder: (context, state) {
            if (state is SucessLoginStatusState) {
              return const HomePage();
            } else if (state is NotLoginState) {
              return Loginpage();
            } else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}
