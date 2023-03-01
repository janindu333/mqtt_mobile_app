import 'package:bloodDonate/blocks/slide_bar_menu_povider.dart';
import 'package:bloodDonate/data/repository/bloodrequest_repo.dart';
import 'package:bloodDonate/ui/utils/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocks/AuthProvider.dart';
import 'blocks/blood_request_block_provider.dart';
import 'blocks/splash_provider.dart';
import 'data/repository/auth_repo.dart';
import 'data/repository/dio/dio_client.dart';
import 'data/repository/dio/logging_interceptor.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.BASE_URL, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(
      () => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => BloodRequestRepo(dioClient: sl(), sharedPreferences: sl()));

  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => BloodRequestProvider(bloodRequestRepo: sl()));
  sl.registerFactory(() => SplashProvider(prefs: sl()));
  sl.registerFactory(() => MenuProvider());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
