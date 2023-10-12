import 'package:flutter/widgets.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/skin.dart';
import 'package:hikup/model/user.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/main/main_screen.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/validation.dart';
import 'package:hikup/utils/wrapper_api.dart';

import 'base_model.dart';

class RegisterPageViewModel extends BaseModel {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _customNavigationService = locator<CustomNavigationService>();
  final _dioService = locator<DioService>();

  String? validateEmail(String? email) {
    if (email == null) {
      return AppMessages.requiredField;
    }
    if (!Validation.emailValidator(email)) {
      return AppMessages.wrongEmail;
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null) {
      return AppMessages.requiredField;
    }
    if (!Validation.passwordValidator(password)) {
      return AppMessages.atLeastHeightChar;
    }
    return null;
  }

  void register({
    required String username,
    required String email,
    required String password,
    required AppState appState,
  }) async {
    try {
      setState(ViewState.busy);
      var response = await _dioService.post(path: '/auth/signup', body: {
        "user": {
          "username": username,
          "email": email,
          "password": password,
        }
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseLogin = await _dioService.post(path: '/auth/login', body: {
          "user": {
            "email": email,
            "password": password,
          }
        });
        if (responseLogin.statusCode == 200 ||
            responseLogin.statusCode == 201) {
          var dataLogin = responseLogin.data as Map<String, dynamic>;
          User user = User.fromMap(data: dataLogin["user"]);
          Skin skin = Skin.fromMap(data: dataLogin["user"]["skin"] ?? {});
          var responseGetProfile = await WrapperApi().getProfile(
            id: user.id,
            roles: user.roles,
            token: user.token,
          );

          if (responseGetProfile.statusCode == 200 ||
              responseGetProfile.statusCode == 201) {
            var responseDataProfile =
                responseGetProfile.data as Map<String, dynamic>;

            appState.setToken(value: user.token);
            User newUser = User(
              id: user.id,
              name: responseDataProfile["user"]["username"],
              email: responseDataProfile["user"]["email"],
              accountType: "",
              imageProfile: responseDataProfile["user"]["picture"] ?? "",
              roles: user.roles,
              token: user.token,
            );
            await Skin.addSkinOnHive(skin: skin, skinBox: skinUserBox);
            await appState.storeInHive(user: newUser);
            appState.updateSkinState(value: skin);
            setState(ViewState.retrieved);

            _customNavigationService.navigateTo(MainScreen.routeName);
          } else {
            _customNavigationService.showSnackBack(
              content: AppMessages.anErrorOcur,
              isError: true,
            );
          }
        } else {
          _customNavigationService.showSnackBack(
            content: AppMessages.anErrorOcur,
            isError: true,
          );
        }
      } else {
        _customNavigationService.showSnackBack(
          content: AppMessages.anErrorOcur,
          isError: true,
        );
      }
      setState(ViewState.retrieved);
    } catch (e) {
      print(e);
      setState(ViewState.retrieved);
    }
  }
}
