import 'package:dio/dio.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/auth/login_page.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';

class WrapperApi {
  final _dioService = locator<DioService>();
  final _hiveService = locator<HiveService>();
  final _navigationService = locator<CustomNavigationService>();

  Future<Response<dynamic>> getProfile({
    required String id,
    required List<dynamic> roles,
    required String token,
  }) async {
    return await _dioService.post(
      path: getProfilePath,
      token: "Bearer $token",
      body: {
        "user": {"id": id, "roles": roles},
      },
    );
  }

  Future<Response<dynamic>> getTrail({
    required String id,
    required List<dynamic> roles,
    required String token,
  }) async {
    return await _dioService.post(
      path: getTrailsPath,
      token: "Bearer $token",
      body: {
        "user": {"id": id, "roles": roles},
      },
    );
  }

  Future<void> logout() async {
    //Simply, when user want to logout we delete his information stored on his storage
    await _hiveService.deleteBoxField(
      boxUser,
      "user",
    );
    //We also delete his skin
    await _hiveService.deleteBoxField(skinUserBox, "skin");

    //After delete user data then we redirect user to a login page, with some message using snack bar
    _navigationService.navigateToAndRemoveUntil(LoginPage.routeName);
    _navigationService.showSnackBack(
      content: AppMessages.tokenExpiredMessage,
      isError: true,
    );
  }
}
