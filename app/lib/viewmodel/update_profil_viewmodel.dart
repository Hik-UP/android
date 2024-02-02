import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/user.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/service/firebase_storage.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hikup/utils/validation.dart';

class UpdateProfilModel extends BaseModel {
  XFile? userImage;
  final _firebaseStorage = locator<FirebaseStorageService>();
  final _dioService = locator<DioService>();
  final _navigationService = locator<CustomNavigationService>();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final verifyController = TextEditingController();
  final nameFormKey = GlobalKey<FormFieldState>();
  final mailFormKey = GlobalKey<FormFieldState>();
  final tokenFormKey = GlobalKey<FormFieldState>();
  String verifyEmail = '';
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

  String? validateToken(String? token) {
    if (token == null || token.isEmpty) {
      return "Code obligatoire";
    } else if (!Validation.tokenValidator(token)) {
      return "6 caractères alphanumériques";
    }
    return null;
  }

  setUserImage({XFile? value}) {
    userImage = value;
    notifyListeners();
  }

  cancelEmailVerify(
      {required AppState appState, required Function() onSuccess}) async {
    try {
      Map<String, dynamic> user = {
        "id": appState.id,
        "roles": appState.roles,
      };

      user["email"] = appState.email;
      setState(ViewState.deletion);
      var result = await _dioService.put(
        path: updateProfilePath,
        token: "Bearer ${appState.token}",
        body: {
          "user": user,
        },
      );
      if (result.statusCode == 200 || result.statusCode == 201) {
        var userNewProfile = await WrapperApi().getProfile(
          id: appState.id,
          roles: appState.roles,
          token: appState.token,
        );
        setState(ViewState.retrieved);
        if (userNewProfile.statusCode == 200 ||
            userNewProfile.statusCode == 201) {
          Map<String, dynamic> userData =
              userNewProfile.data as Map<String, dynamic>;
          User user = User.fromMap(data: userData["user"]);
          appState.storeInHive(
              user: User(
            id: appState.id,
            name: user.name,
            email: user.email,
            verifyEmail: null,
            accountType: user.accountType,
            imageProfile: user.imageProfile,
            roles: appState.roles,
            token: appState.token,
          ));
          if (timer != null) {
            timer?.cancel();
            delay = 0;
          }
          _navigationService.showSnackBack(
            content: "Modification d'adresse email annulée",
            isError: false,
          );
          onSuccess();
          return;
        }
      }
    } catch (e) {
      _navigationService.showSnackBack(
        content: "Une erreur est survenue",
        isError: false,
      );
      setState(ViewState.retrieved);
    }
  }

  resend({required String email, required Function(int delay) onDelay}) async {
    try {
      setState(ViewState.resend);

      final response = await _dioService.post(
        path: resendTokenPath,
        body: {
          "user": {"email": email},
          "token": {"type": 1}
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

  updateProfile({
    required AppState appState,
    required String username,
    required String email,
    required Function() onVerify,
  }) async {
    try {
      String urlImage = "";
      Map<String, dynamic> user = {
        "id": appState.id,
        "roles": appState.roles,
      };

      //Check if userImage is not null
      //Then user want to update his profile
      if (userImage != null) {
        setState(ViewState.busy);
        urlImage = await _firebaseStorage.uploadProfile(
          file: File(userImage!.path),
          userId: appState.id,
        );
        if (urlImage is bool) {
          setState(ViewState.retrieved);
          return;
        }
        user["picture"] = urlImage;
      }
      //Update the username only if the new username
      //Is different from the past username
      //Same for the email
      if (userImage == null &&
          username == appState.username &&
          email == appState.email) {
        setState(ViewState.retrieved);
        _navigationService.showSnackBack(
          content: AppMessages.nothingChange,
        );
        return;
      }
      if (email != appState.email) {
        user["email"] = email;
      }
      if (username != appState.username) {
        user["username"] = username;
      }
      setState(ViewState.busy);
      var result = await _dioService.put(
        path: updateProfilePath,
        token: "Bearer ${appState.token}",
        body: {
          "user": user,
        },
      );
      if (result.statusCode == 200 || result.statusCode == 201) {
        var userNewProfile = await WrapperApi().getProfile(
          id: appState.id,
          roles: appState.roles,
          token: appState.token,
        );
        setState(ViewState.retrieved);
        if (userNewProfile.statusCode == 200 ||
            userNewProfile.statusCode == 201) {
          Map<String, dynamic> userData =
              userNewProfile.data as Map<String, dynamic>;
          User user = User.fromMap(data: userData["user"]);
          appState.storeInHive(
              user: User(
            id: appState.id,
            name: user.name,
            email: user.email,
            verifyEmail: appState.verifyEmail,
            accountType: user.accountType,
            imageProfile: user.imageProfile,
            roles: appState.roles,
            token: appState.token,
          ));
          _navigationService.goBack();
          return;
        }
      }
      setState(ViewState.retrieved);
      _navigationService.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    } catch (e) {
      if (e is DioException && e.response!.statusCode == 403) {
        var userNewProfile = await WrapperApi().getProfile(
          id: appState.id,
          roles: appState.roles,
          token: appState.token,
        );
        if (userNewProfile.statusCode == 200 ||
            userNewProfile.statusCode == 201) {
          Map<String, dynamic> userData =
              userNewProfile.data as Map<String, dynamic>;
          User user = User.fromMap(data: userData["user"]);
          appState.storeInHive(
              user: User(
            id: appState.id,
            name: user.name,
            email: user.email,
            accountType: user.accountType,
            imageProfile: user.imageProfile,
            verifyEmail: verifyEmail,
            roles: appState.roles,
            token: appState.token,
          ));
          onVerify();
          _navigationService.showSnackBack(
            content: "Veuillez vérifier votre adresse Email",
            isError: false,
          );
          setState(ViewState.retrieved);
        } else {
          _navigationService.showSnackBack(
            content: "Une erreur est survenue",
            isError: false,
          );
          setState(ViewState.retrieved);
        }
      } else if (e is DioException &&
          e.response!.statusCode == 409 &&
          e.response!.data['error'] == 'Email') {
        _navigationService.showSnackBack(
          content: "Cette adresse email a déjà été utilisée",
          isError: true,
        );
        setState(ViewState.retrieved);
      } else if (e is DioException &&
          e.response!.statusCode == 409 &&
          e.response!.data['error'] == 'Username') {
        _navigationService.showSnackBack(
          content: "Ce nom d'utilisateur a déjà été utilisé",
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

  updateProfileVerify(
      {required AppState appState,
      required String email,
      required String token,
      required Function() onSuccess}) async {
    try {
      Map<String, dynamic> user = {
        "id": appState.id,
        "roles": appState.roles,
      };

      if (email != appState.email) {
        user["email"] = email;
      }
      setState(ViewState.update);
      var result = await _dioService.put(
        path: updateProfilePath,
        token: "Bearer ${appState.token}",
        body: {
          "user": user,
          "verify": {"token": token}
        },
      );
      if (result.statusCode == 200 || result.statusCode == 201) {
        var userNewProfile = await WrapperApi().getProfile(
          id: appState.id,
          roles: appState.roles,
          token: appState.token,
        );
        setState(ViewState.retrieved);
        if (userNewProfile.statusCode == 200 ||
            userNewProfile.statusCode == 201) {
          Map<String, dynamic> userData =
              userNewProfile.data as Map<String, dynamic>;
          User user = User.fromMap(data: userData["user"]);
          appState.storeInHive(
              user: User(
            id: appState.id,
            name: user.name,
            email: user.email,
            verifyEmail: null,
            accountType: user.accountType,
            imageProfile: user.imageProfile,
            roles: appState.roles,
            token: appState.token,
          ));
          if (timer != null) {
            timer?.cancel();
            delay = 0;
          }
          verifyEmail = '';
          _navigationService.showSnackBack(
            content: "Votre adresse email a été changée",
            isError: false,
          );
          onSuccess();
          return;
        }
      }
      _navigationService.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
      setState(ViewState.retrieved);
    } catch (e) {
      _navigationService.showSnackBack(
        content: "Code de vérification incorrect",
        isError: true,
      );
      setState(ViewState.retrieved);
    }
  }
}
