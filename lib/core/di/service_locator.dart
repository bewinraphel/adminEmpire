import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/data/datasource/auth_repo.dart';
import 'package:empire/data/datasource/category_data_source.dart';
import 'package:empire/data/datasource/category_data_source_impli.dart';
import 'package:empire/data/datasource/checking_login_status.dart';
import 'package:empire/data/datasource/image_profile.dart';
import 'package:empire/data/datasource/register.dart';
import 'package:empire/data/repository/auth_repository..dart';
import 'package:empire/data/repository/category_repository.dart';
import 'package:empire/data/repository/image_profile.dart';
import 'package:empire/data/repository/login_status.dart';
import 'package:empire/data/repository/register.dart';
import 'package:empire/domain/repositories/auth_repository.dart';
import 'package:empire/domain/repositories/category_repository.dart';
import 'package:empire/domain/repositories/image_profile.dart';
import 'package:empire/domain/repositories/login_status_auth.dart';
import 'package:empire/domain/repositories/register.dart';
import 'package:empire/domain/usecase/authcase/Login_status_usecase.dart';
import 'package:empire/domain/usecase/category/adding_category_usecase.dart';
import 'package:empire/domain/usecase/category/adding_subcategory_usecase.dart';
import 'package:empire/domain/usecase/category/get_category_usecase.dart';
import 'package:empire/domain/usecase/authcase/login_usecase.dart';
import 'package:empire/domain/usecase/authcase/login_auth_usecase.dart';
import 'package:empire/domain/usecase/common/pick_image_camera_usecase.dart';
import 'package:empire/domain/usecase/common/pick_image_gallery_usecase.dart';
import 'package:empire/domain/usecase/authcase/register_usecase.dart';

import 'package:empire/domain/usecase/authcase/save_login_status_usecase.dart';
import 'package:empire/domain/usecase/authcase/save_password_usecase.dart';
import 'package:empire/domain/usecase/authcase/send_otp_usecase.dart';
import 'package:empire/domain/usecase/authcase/verify_user_usecase.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/web.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;
Future<void> init() async {
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => SigningWithGoogle(sl()));
  sl.registerLazySingletonAsync(() => SharedPreferences.getInstance());
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl(), sl()));

  sl.registerLazySingleton(() => AuthCheckingLoginStatus());

  sl.registerLazySingleton<LoginStatus>(() => LoginStatusImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton(() => CheckLoginStatus(sl()));
  sl.registerLazySingleton(() => SaveLoginStatus(sl()));

  //////////////////////profile////////////////////
  sl.registerSingleton(() => ImagePicker());
  sl.registerLazySingleton(() => ImageSources());
  sl.registerSingleton<ProfileImage>(ProfileImageImpli(sl()));
  sl.registerSingleton<PickImageFromCamera>(PickImageFromCamera(sl()));
  sl.registerSingleton<PickImageFromGallery>(PickImageFromGallery(sl()));
  ////////register/////////////////////

  final firestore = FirebaseFirestore.instance;

  sl.registerLazySingleton(() => UserFirebaseSource(firestore));
  sl.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryimpli(sl()),
  );
  sl.registerLazySingleton(() => CheckingUser(sl()));
  ////////////otp////////
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => VerifyNumber(sl()));

  ///password//
  sl.registerLazySingleton(() => SavePassword(sl()));
  //login
  sl.registerLazySingleton(() => Login(sl()));
  ///// category
  sl.registerSingleton<Logger>(Logger());
  sl.registerLazySingleton<CategoryDataSource>(
    () => CategoryDataSourceImpl(sl<Logger>()),
  );

  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpli(sl()),
  );
  sl.registerLazySingleton(
    () => AddingcategoryUseCase(sl<CategoryRepository>()),
  );
  sl.registerLazySingleton(() => CategoryUsecase(sl<CategoryRepository>()));

  ///subcategory

  sl.registerLazySingleton(
    () => AddingSubcategoryUsecase(sl<CategoryRepository>()),
  );
}
