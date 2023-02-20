import 'package:get_it/get_it.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/service/firebase_storage.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hikup/viewmodel/map_viewmodel.dart';
import 'package:hikup/viewmodel/notification_viewmodel.dart';
import 'package:hikup/viewmodel/register_page_viewmodel.dart';
import 'package:hikup/viewmodel/update_profil_viewmodel.dart';

import 'viewmodel/login_page_viewmodel.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => HiveService());
  locator
      .registerLazySingleton(() => DioService()); //Pour enregistrer un service
  locator.registerLazySingleton(() => CustomNavigationService());
  locator.registerFactory(() => FirebaseStorageService());

  //  locator.registerFactory(() => null) //Pour enregistrer un ViewModel
  locator.registerFactory(() => NotificationViewModel());
  locator.registerFactory(() => LoginPageViewModel());
  locator.registerFactory(() => RegisterPageViewModel());
  locator.registerFactory(() => UpdateProfilModel());
  locator.registerFactory(() => MapViewModel());
}
