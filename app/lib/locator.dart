import 'package:get_it/get_it.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/viewmodel/notification_viewmodel.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator
      .registerLazySingleton(() => DioService()); //Pour enregistrer un service
  locator.registerLazySingleton(() => CustomNavigationService());

  //  locator.registerFactory(() => null) //Pour enregistrer un ViewModel
  locator.registerFactory(() => NotificationViewModel());
}
