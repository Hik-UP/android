import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/other_data.dart';
import 'package:hikup/model/user.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppState extends ChangeNotifier {
  final Box<OtherData> _boxOtherData = Hive.box("otherData");
  final Box<User> _boxUser = Hive.box("userBox");
  final _hiveService = locator<HiveService>();
  bool isFirstDownload = true;
  String token = "";
  String username = "";
  String id = "";
  String email = "";
  String picture = "";
  String fcmUserToken = "";
  List<dynamic> roles = [];

  void setIsFirstDownload({required bool value}) async {
    isFirstDownload = value;
    await _hiveService.addOnBoxViaKey<OtherData>(
      _boxOtherData,
      "otherData",
      OtherData(isFirstDownload: value),
    );

    notifyListeners();
  }

  void setToken({required String value}) {
    token = value;
    notifyListeners();
  }

  void setUsername({required String value}) {
    username = value;
    notifyListeners();
  }

  void setId({required String value}) {
    id = value;
    notifyListeners();
  }

  void setEmail({required String value}) {
    email = value;
    notifyListeners();
  }

  void setPicture({required String value}) {
    picture = value;
    notifyListeners();
  }

  void setRoles({required List<dynamic> value}) {
    roles = value;
    notifyListeners();
  }

  void setFcmToken({required String value}) {
    fcmUserToken = value;
    print("Key");
    print(value);
    notifyListeners();
  }

  storeInHive({required User user}) async {
    await _hiveService.addOnBoxViaKey<User>(_boxUser, "user", user);
    updateAllState(user: user);
  }

  updateAllState({required User user}) {
    setUsername(value: user.name);
    setId(value: user.id);
    setEmail(value: user.email);
    setPicture(value: user.imageProfile);
    setRoles(value: user.roles);
    setToken(value: user.token);
  }

  initialState() {
    var otherData = _boxOtherData.get("otherData") ?? OtherData();
    var user = _boxUser.get("user") ?? emptyUser;

    setIsFirstDownload(value: otherData.isFirstDownload);
    updateAllState(user: user);
  }

  void getUserFcmToken() async {
    FirebaseMessaging.instance.getToken().then((value) => setFcmToken(
          value: value ?? "",
        ));
  }
}
