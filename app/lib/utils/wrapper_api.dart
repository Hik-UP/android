import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/detail_trail_model.dart';
import 'package:hikup/model/hike.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/auth/login_page.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hikup/theme.dart';
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
      throw AppMessages.anErrorOcur;
    }
  }

  Future<List<Hike>> getAllHike({
    required String path,
    required AppState appState,
    required List<String> target,
  }) async {
    List<Hike> hikes = [];
    try {
      var result = await _dioService.post(
        token: "Bearer ${appState.token}",
        path: getHikePath,
        body: {
          "user": {
            "id": appState.id,
            "roles": appState.roles,
          },
          "hike": {"target": target},
        },
      );

      for (String state in target) {
        List<Hike> subElements = [];
        for (var content in result.data["hikes"][state] as List) {
          subElements.add(Hike.fromMap(data: content));
        }
        hikes.addAll(subElements);
      }
      return hikes;
    } catch (e) {
      print(e);
      throw AppMessages.anErrorOcur;
    }
  }

  Widget showTools({required List<String> toolsBack}) {
    List<Widget> tools = [];

    for (int i = 0; i + 1 < toolsBack.length; i += 2) {
      tools.add(Row(
        children: [
          Expanded(
            child: Text(
              "${i + 1}. ${toolsBack[i]}",
              style: WhiteAddressTextStyle,
            ),
          ),
          Expanded(
            child: Text(
              "${i + 2}. ${toolsBack[i + 1]}",
              style: WhiteAddressTextStyle,
            ),
          ),
        ],
      ));
    }

    return Column(children: tools);
  }
}
