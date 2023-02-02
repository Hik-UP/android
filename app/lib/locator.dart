import 'package:get_it/get_it.dart';
import 'package:hikup/service/dio_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator
      .registerLazySingleton(() => DioService()); //Pour enregistrer un service

  //  locator.registerFactory(() => null) //Pour enregistrer un ViewModel
}
