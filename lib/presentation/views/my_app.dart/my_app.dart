import 'package:empire/core/di/service_locator.dart';
import 'package:empire/domain/repositories/category_repository.dart';
import 'package:empire/domain/usecase/authcase/Login_status_usecase.dart';
import 'package:empire/domain/usecase/category/adding_category_usecase.dart';
import 'package:empire/domain/usecase/category/get_category_usecase.dart';
import 'package:empire/domain/usecase/authcase/login_usecase.dart';
import 'package:empire/domain/usecase/authcase/login_auth_usecase.dart';
import 'package:empire/domain/usecase/common/pick_image_camera_usecase.dart';
import 'package:empire/domain/usecase/common/pick_image_gallery_usecase.dart';
import 'package:empire/domain/usecase/authcase/register_usecase.dart';
import 'package:empire/domain/usecase/authcase/save_login_status_usecase.dart';
import 'package:empire/domain/usecase/authcase/send_otp_usecase.dart';
import 'package:empire/domain/usecase/authcase/verify_user_usecase.dart';
import 'package:empire/presentation/bloc/auth/login_bloc.dart';
import 'package:empire/presentation/bloc/auth/login_status_bloc.dart';
import 'package:empire/presentation/bloc/auth/loginpage_bloc.dart';
import 'package:empire/presentation/bloc/auth/otp_bloc.dart';

import 'package:empire/presentation/bloc/auth/profile_image_bloc.dart';
import 'package:empire/presentation/bloc/auth/registerpage_bloc.dart';
import 'package:empire/presentation/bloc/auth/savepassowrd_bloc.dart';
import 'package:empire/presentation/bloc/category_bloc/adding_category.dart';
import 'package:empire/presentation/bloc/category_bloc/adding_subcategory.dart';
import 'package:empire/presentation/bloc/category_bloc/get_category_bloc.dart';

import 'package:empire/presentation/views/homepage/home_page.dart';
import 'package:empire/presentation/views/loginpage/home_page.dart';
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
          create: (_) => SubcategoryBloc(
            sl<AddingcategoryUseCase>(),
            sl<CategoryRepository>(),
          ),
        ),
        BlocProvider<AddingcategoryEventBloc>(
          create: (_) => AddingcategoryEventBloc(sl<AddingcategoryUseCase>()),
        ),
      ],
      child: MaterialApp(
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
