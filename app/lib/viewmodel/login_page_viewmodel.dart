import 'package:flutter/widgets.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/skin.dart';
import 'package:hikup/model/user.dart';
//import 'package:hikup/model/trail.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/main/main_screen.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/validation.dart';
import 'package:hikup/utils/wrapper_api.dart';

import 'base_model.dart';

class LoginPageViewModel extends BaseModel {
  final _dioService = locator<DioService>();
  final _navigationService = locator<CustomNavigationService>();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? validEmail(String? email) {
    if (email != null &&
        email.isNotEmpty &&
        Validation.emailValidator(email) == true) {
      return null;
    }
    if (email == null || email.isEmpty) {
      return AppMessages.requiredField;
    }
    if (!Validation.emailValidator(email)) {
      return AppMessages.wrongEmail;
    }
    return null;
  }

  String? validPassword(String? password) {
    if (password != null && password.length > 7) {
      return null;
    }
    if (password == null || password.isEmpty) {
      return AppMessages.passwordRequired;
    }
    return AppMessages.atLeastHeightChar;
  }

  login({
    required String email,
    required password,
    required AppState appState,
  }) async {
    try {
      setState(ViewState.busy);
      var result = await _dioService.post(
        path: loginPath,
        body: {
          "user": {
            "email": email,
            "password": password,
          }
        },
      );
      setState(ViewState.retrieved);
      Map<String, dynamic> data = result.data as Map<String, dynamic>;

      if (result.statusCode == 401 &&
          data.keys.contains("error") &&
          data["error"] == "Unauthorized") {
        _navigationService.showSnackBack(
          content: AppMessages.loginError,
          isError: true,
        );
        return;
      }
      if (result.statusCode == 200 || result.statusCode == 201) {
        //Passer de user JSON à user model
        User user = User.fromMap(data: data["user"]);

        var userProfile = await WrapperApi().getProfile(
          id: user.id,
          roles: user.roles,
          token: user.token,
        );

        if (userProfile.statusCode == 200 || userProfile.statusCode == 201) {
          var profileData = userProfile.data as Map<String, dynamic>;

          appState.setToken(value: user.token);
          User newUser = User(
            id: user.id,
            name: profileData["user"]["username"],
            email: profileData["user"]["email"],
            accountType: "",
            imageProfile: profileData["user"]["picture"] ?? "",
            roles: user.roles,
            token: user.token,
          );
          Skin skin = Skin.fromMap(data: profileData["user"]["skin"]);
          Skin.addSkinOnHive(skin: skin, skinBox: skinUserBox);
          appState.updateSkinState(value: skin);
          await appState.storeInHive(user: newUser);

          _navigationService.navigateTo(MainScreen.routeName);
          return;
        } else {
          _navigationService.showSnackBack(
            content: AppMessages.anErrorOcur,
            isError: true,
          );
          return;
        }
        //Stocker l'utilisateur dans le local storage d'une téléphone et ensuite dans le state de l'application
      }
    } catch (e) {
      setState(ViewState.retrieved);
    }
  }
  // print(result);

}
