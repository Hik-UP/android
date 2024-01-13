import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/event.dart';
import 'package:hikup/model/other_data.dart';
import 'package:hikup/model/sensible_user_data.dart';
import 'package:hikup/model/settings.dart';
import 'package:hikup/model/skin.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/model/user.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hive_flutter/hive_flutter.dart';

final Box<User> boxUser = Hive.box("userBox");
final Box<Skin> skinUserBox = Hive.box("skinBox");
final Box<SensibleUserData> sensibleUserDataBox =
    Hive.box("sensibleUserDataBox");
final Box<Settings> settingsBox = Hive.box("settings");
final Box<String> boxtrailId = Hive.box('trailId');
final Box<TrailList> boxTrails = Hive.box("trails");

class AppState extends ChangeNotifier {
  final Box<OtherData> _boxOtherData = Hive.box("otherData");

  String comment = "";

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
  Settings settings = emptySettings;
  List<EventModel> events = [];

  void addNewEvent(EventModel event) {
    events.add(event);
    notifyListeners();
  }

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

  void updateIfSkinHasChanged() async {
    var response = await WrapperApi().getProfile(
      id: id,
      roles: roles,
      token: token,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      Skin newSkin = Skin.fromMap(data: response.data['user']['skin']);
      if (newSkin.id != skin.id) {
        updateSkinState(value: newSkin);
        Skin.addSkinOnHive(skin: newSkin, skinBox: skinUserBox);
      }
    }
  }

  void updateSensibleDataState({required SensibleUserData value}) {
    sensibleUserData = value;
    notifyListeners();
  }

  void updateSettingsState({required Settings value}) {
    settings = value;
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
    var settings = settingsBox.get("settings") ?? emptySettings;
    setIsFirstDownload(value: otherData.isFirstDownload);
    updateAllState(user: user);
    updateSkinState(value: skin);
    updateSensibleDataState(value: sensibleUserData);
    updateSettingsState(value: settings);
  }

  void getUserFcmToken() async {
    FirebaseMessaging.instance.getToken().then((value) => setFcmToken(
          value: value!,
        ));
  }
}
