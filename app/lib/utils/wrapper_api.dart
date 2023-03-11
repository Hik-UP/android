import 'package:dio/dio.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/detail_trail_model.dart';
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
    _dioService
        .addInterceptors(); //In order to add the interceptors that we have previously created
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

  Future<void> logout({required bool isLogout}) async {
    //Simply, when user want to logout we delete his information stored on his storage
    await _hiveService.deleteBoxField(
      boxUser,
      "user",
    );
    //We also delete his skin
    await _hiveService.deleteBoxField(skinUserBox, "skin");
    await _hiveService.deleteBoxField(sensibleUserDataBox, "sensibleUserData");

    //After delete user data then we redirect user to a login page, with some message using snack bar
    _navigationService.navigateToAndRemoveUntil(LoginPage.routeName);
    _navigationService.showSnackBack(
      content: isLogout ? AppMessages.logout : AppMessages.tokenExpiredMessage,
      isError: !isLogout,
    );
  }

  Future<DetailTrailMode> getDetailsTrails({
    required AppState appState,
    required String trailId,
  }) async {
    try {
      var response = await _dioService.post(
        path: getDetailsPath,
        body: {
          "user": {
            "id": appState.id,
            "roles": appState.roles,
            "weight": 160,
            "tall": 168,
            "sex": "M",
            "age": 19
          },
          "trail": {
            "id": trailId,
          },
        },
        token: "Bearer ${appState.token}",
      );

      return DetailTrailMode.fromMap(
          data: response.data as Map<String, dynamic>);
    } catch (e) {
      print(e);
      throw AppMessages.anErrorOcur;
    }
  }
}
