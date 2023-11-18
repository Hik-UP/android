import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/detail_trail_model.dart';
import 'package:hikup/model/hike.dart';
import 'package:hikup/model/notification.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/auth/login_page.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:google_fonts/google_fonts.dart';

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
      throw AppMessages.anErrorOcur;
    }
  }

  Widget showTools({required List<String> toolsBack}) {
    List<Widget> tools = [];

    for (int i = 0; i < toolsBack.length; i += 1) {
      tools.add(
        Text(
          "•  ${toolsBack[i]}",
          style: GoogleFonts.poppins(
              fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
      );
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tools);
  }

  sendFcmToken({
    required String id,
    required List<dynamic> roles,
    required String token,
    required String tokenFcm,
  }) async {
    _dioService.put(
      path: updateProfilePath,
      body: {
        "user": {
          "id": id,
          "roles": roles,
          "fcmToken": tokenFcm,
        },
      },
      token: "Bearer $token",
    );
  }

  Future<List<NotificationModel>> getAllNotification(
      {required AppState appState}) async {
    try {
      var response = await _dioService.post(
        path: retrieveNotificationPath,
        body: {
          "user": {
            "id": appState.id,
            "roles": appState.roles,
          },
        },
        token: "Bearer ${appState.token}",
      );

      return (response.data["notifications"] as List)
          .map<NotificationModel>(
            (e) => NotificationModel.fromMap(
              data: e,
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> moveNotificationToRead({required AppState appState}) async {
    var notifications = await getAllNotification(appState: appState);

    for (NotificationModel notif in notifications) {
      if (!notif.read) {
        _dioService.put(
          path: notifUpdatePath,
          body: {
            "user": {
              "id": appState.id,
              "roles": appState.roles,
            },
            "notification": {
              "id": notif.id,
              "read": true,
            },
          },
          token: "Bearer ${appState.token}",
        );
      }
    }
  }
}
