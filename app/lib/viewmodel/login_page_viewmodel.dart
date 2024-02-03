import 'package:dio/dio.dart';
import 'dart:async';
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
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/utils/validation.dart';
import 'base_model.dart';

class LoginPageViewModel extends BaseModel {
  final _dioService = locator<DioService>();
  final _navigationService = locator<CustomNavigationService>();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final verifyController = TextEditingController();
  Timer? timer;
  int delay = 0;

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email obligatoire";
    } else if (email.length > 256) {
      return "Ne peut avoir plus de 256 caractères";
    } else if (!Validation.emailValidator(email)) {
      return AppMessages.wrongEmail;
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Mot de passe obligatoire";
    } else if (!Validation.passwordValidator(password)) {
      return AppMessages.atLeastHeightChar;
    }
    return null;
  }

  String? validateToken(String? token) {
    if (token == null || token.isEmpty) {
      return "Code obligatoire";
    } else if (!Validation.tokenValidator(token)) {
      return "6 caractères alphanumériques";
    }
    return null;
  }

  login({
    required String email,
    required password,
    required Function() onVerify,
    required AppState appState,
  }) async {
    try {
      setState(ViewState.busy);

      var result = await _dioService.post(
        path: loginPath,
        body: {
          "user": {
            "email": email.toLowerCase(),
            "password": password,
          }
        },
      );
      setState(ViewState.retrieved);
      Map<String, dynamic> data = result.data as Map<String, dynamic>;

      if (result.statusCode == 400) {
        _navigationService.showSnackBack(
          content: AppMessages.inexistantUser,
          isError: true,
        );
        return;
      }

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

          MixpanelManager.track('login', properties: {'id': user.id});

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
      if (e is DioException && e.response!.statusCode == 403) {
        onVerify();
        _navigationService.showSnackBack(
          content: "Veuillez vérifier votre adresse Email",
          isError: false,
        );
        setState(ViewState.retrieved);
      } else {
        _navigationService.showSnackBack(
          content: AppMessages.loginError,
          isError: true,
        );
        setState(ViewState.retrieved);
      }
    }
  }

  resend({required String email, required Function(int delay) onDelay}) async {
    try {
      setState(ViewState.resend);

      final response = await _dioService.post(
        path: resendTokenPath,
        body: {
          "user": {"email": email.toLowerCase()},
          "token": {"type": 0}
        },
      );

      onDelay(response.data['delay']);
      _navigationService.showSnackBack(
        content: "Un nouveau code vous a été envoyé par email",
        isError: false,
      );
      setState(ViewState.retrieved);
    } catch (e) {
      if (e is DioException && e.response!.statusCode == 403) {
        onDelay(e.response!.data['delay'].round());
        _navigationService.showSnackBack(
          content:
              "Veuillez patienter ${e.response!.data['delay'].round()} secondes",
          isError: true,
        );
        setState(ViewState.retrieved);
      } else {
        _navigationService.showSnackBack(
          content: "Une erreur est survenue",
          isError: true,
        );
        setState(ViewState.retrieved);
      }
    }
  }

  verify({
    required String email,
    required password,
    required String token,
    required AppState appState,
  }) async {
    try {
      setState(ViewState.busy);

      var result = await _dioService.post(
        path: loginPath,
        body: {
          "user": {
            "email": email.toLowerCase(),
            "password": password,
          },
          "verify": {"token": token}
        },
      );
      setState(ViewState.retrieved);
      Map<String, dynamic> data = result.data as Map<String, dynamic>;

      if (result.statusCode == 400) {
        _navigationService.showSnackBack(
          content: AppMessages.inexistantUser,
          isError: true,
        );
        return;
      }

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

          if (timer != null) {
            timer?.cancel();
            delay = 0;
          }

          MixpanelManager.track('login', properties: {'id': user.id});

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
      _navigationService.showSnackBack(
        content: "Code de vérification incorrect",
        isError: true,
      );
      setState(ViewState.retrieved);
    }
  }
}
