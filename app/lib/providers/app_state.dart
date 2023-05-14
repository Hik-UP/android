import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/other_data.dart';
import 'package:hikup/model/sensible_user_data.dart';
import 'package:hikup/model/skin.dart';
import 'package:hikup/model/user.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hive_flutter/hive_flutter.dart';

final Box<User> boxUser = Hive.box("userBox");
final Box<Skin> skinUserBox = Hive.box("skinBox");
final Box<SensibleUserData> sensibleUserDataBox =
    Hive.box("sensibleUserDataBox");
final Box<String> boxtrailId = Hive.box('trailId');

class AppState extends ChangeNotifier {
  final Box<OtherData> _boxOtherData = Hive.box("otherData");

  final _hiveService = locator<HiveService>();
  bool isFirstDownload = true;
  String token = "";
  String username = "";
  String id = "";
  String email = "";
  String picture = "";
  String fcmUserToken = "";
  List<dynamic> roles = [];
  Skin skin = emptySkin;
  SensibleUserData sensibleUserData = emptySensibleUserData;

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

    print("Tpken");
    print(value);
    WrapperApi().sendFcmToken(
      id: id,
      roles: roles,
      token: token,
      tokenFcm: value,
    );

    notifyListeners();
  }

  void updateSkinState({required Skin value}) {
    skin = value;
    notifyListeners();
  }

  void updateSensibleDataState({required SensibleUserData value}) {
    sensibleUserData = value;
    notifyListeners();
  }

  storeInHive({required User user}) async {
    await _hiveService.addOnBoxViaKey<User>(boxUser, "user", user);
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
    var user = boxUser.get("user") ?? emptyUser;
    var skin = skinUserBox.get("skin") ?? emptySkin;
    var sensibleUserData =
        sensibleUserDataBox.get("sensibleUserData") ?? emptySensibleUserData;
    setIsFirstDownload(value: otherData.isFirstDownload);
    updateAllState(user: user);
    updateSkinState(value: skin);
    updateSensibleDataState(value: sensibleUserData);
  }

  void getUserFcmToken() async {
    FirebaseMessaging.instance.getToken().then((value) => setFcmToken(
          value: value!,
        ));
  }
}
