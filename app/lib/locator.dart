import 'package:get_it/get_it.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/service/firebase_storage.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hikup/viewmodel/all_event_viewmodel.dart';
import 'package:hikup/viewmodel/community_page_viewmodel.dart';
import 'package:hikup/viewmodel/complete_profile_viewmodel.dart';
import 'package:hikup/viewmodel/create_event_viewmodel.dart';
import 'package:hikup/viewmodel/detail_hike_invite.dart';
import 'package:hikup/viewmodel/detail_screen_viewmodel.dart';
import 'package:hikup/viewmodel/dialog_content_skin_viewmodel.dart';
import 'package:hikup/viewmodel/event_card_viewmodel.dart';
import 'package:hikup/viewmodel/hike_card_viewmodel.dart';
import 'package:hikup/viewmodel/hikes_create_viewmodel.dart';
import 'package:hikup/viewmodel/map_viewmodel.dart';
import 'package:hikup/viewmodel/notification_viewmodel.dart';
import 'package:hikup/viewmodel/register_page_viewmodel.dart';
import 'package:hikup/viewmodel/shop_viewmodel.dart';
import 'package:hikup/viewmodel/skin_display_viewmodel.dart';
import 'package:hikup/viewmodel/update_profil_viewmodel.dart';
import 'package:hikup/viewmodel/search_viewmodel.dart';

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
  locator.registerFactory(() => SearchViewModel());
  locator.registerFactory(() => CompleteProfileViewModel());
  locator.registerFactory(() => DetailScreenViewModel());
  locator.registerFactory(() => HikeCreateViewModel());
  locator.registerFactory(() => HikeCardViewModel());
  locator.registerFactory(() => DetailHikeInviteViewModel());
  locator.registerFactory(() => CommunityPageViewModel());
  locator.registerFactory(() => SkinDisplayViewModel());
  locator.registerFactory(() => ShopViewModel());
  locator.registerFactory(() => DialogContentSkinViewModel());
  locator.registerFactory(() => CreateEventViewModel());
  locator.registerFactory(() => AllEventViewModel());
  locator.registerFactory(() => EventCardViewModel());
}
