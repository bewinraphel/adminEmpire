import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/feature/auth/data/datasource/auth_repo.dart';
import 'package:empire/feature/category/data/datasource/category_data_source.dart';
import 'package:empire/feature/category/data/datasource/category_data_source_impli.dart';
import 'package:empire/feature/auth/data/datasource/checking_login_status.dart';
import 'package:empire/feature/auth/data/datasource/image_profile.dart';
import 'package:empire/feature/category/data/datasource/categoryimage.dart';
import 'package:empire/feature/category/data/repository/categoryimage.dart';
import 'package:empire/feature/category/domain/repositories/categoryimage_repository.dart';
import 'package:empire/feature/category/domain/usecase/categories/category_image_camera.dart';
import 'package:empire/feature/category/domain/usecase/categories/catgeroyimgae_gallery.dart';
import 'package:empire/feature/product/data/datasource/add_product_data_source.dart';
import 'package:empire/feature/product/data/datasource/add_product_data_source_impli.dart';
import 'package:empire/feature/auth/data/datasource/register.dart';
import 'package:empire/feature/auth/data/repository/auth_repository..dart';
import 'package:empire/feature/category/data/repository/category_repository.dart';
import 'package:empire/feature/auth/data/repository/image_profile.dart';
import 'package:empire/feature/auth/data/repository/login_status.dart';
import 'package:empire/feature/product/data/repository/add_product_respository.dart';
import 'package:empire/feature/auth/data/repository/register.dart';
import 'package:empire/feature/auth/domain/repositories/auth_repository.dart';
import 'package:empire/feature/category/domain/repositories/category_repository.dart';
import 'package:empire/feature/auth/domain/repositories/image_profile.dart';
import 'package:empire/feature/auth/domain/repositories/login_status_auth.dart';
import 'package:empire/feature/product/domain/repository/product_repository.dart';
import 'package:empire/feature/auth/domain/repositories/register.dart';
import 'package:empire/feature/auth/domain/usecase/Login_status_usecase.dart';
import 'package:empire/feature/category/domain/usecase/categories/adding_category_usecase.dart';
import 'package:empire/feature/category/domain/usecase/categories/adding_subcategory_usecase.dart';
import 'package:empire/feature/category/domain/usecase/categories/get_category_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/login_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/login_auth_usecase.dart';
import 'package:empire/feature/category/domain/usecase/categories/getting_subcategory_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/pick_image_gallery_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/register_usecase.dart';

import 'package:empire/feature/auth/domain/usecase/save_login_status_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/save_password_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/send_otp_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/verify_user_usecase.dart';
import 'package:empire/feature/product/data/datasource/product_datasource.dart';
import 'package:empire/feature/product/data/repository/product_repositoy.dart';
import 'package:empire/feature/product/domain/repository/prodcuct_call_repository.dart';
import 'package:empire/feature/product/domain/usecase/product/add_product_usecae.dart';
import 'package:empire/feature/product/domain/usecase/productcaliing_usecase.dart';

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
  //////////////////////categoryimage////////////////////

  sl.registerLazySingleton(() => CategoryImageSources());
  sl.registerSingleton<Categoryimage>(CategoryImageImpli(sl()));
  sl.registerSingleton<CategoryImageCamera>(CategoryImageCamera(sl()));
  sl.registerSingleton<CategoryImagegallery>(CategoryImagegallery(sl()));

  ///subcategory

  sl.registerLazySingleton(
    () => AddingSubcategoryUsecase(sl<CategoryRepository>()),
  );

  ///getsubcategory
  sl.registerLazySingleton(
    () => GettingSubcategoryUsecase(sl<CategoryRepository>()),
  );
  //////product
  sl.registerLazySingleton(() => AddProductUseCase(sl<ProductRepository>()));
  sl.registerLazySingleton<ProductDataSource>(() => ProductDataSourceImpli());
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductDataSource>()),
  );

  ///
  sl.registerLazySingleton<ProductsDataSource>(() => ProducsDataSourceimpli());
  sl.registerLazySingleton<ProdcuctsRepository>(
    () => ProductsRepositoyImpi(sl<ProductsDataSource>()),
  );
  sl.registerLazySingleton<ProductcallingUsecase>(
    () => ProductcallingUsecase(sl<ProdcuctsRepository>()),
  );
}
