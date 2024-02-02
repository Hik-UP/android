import 'package:dio/dio.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:hikup/utils/validation.dart';

class ResetPageModel extends BaseModel {
  final _dioService = locator<DioService>();
  final _navigationService = locator<CustomNavigationService>();
  final TextEditingController emailCtrl = TextEditingController();
  final verifyController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordControllerConfirm = TextEditingController();
  final mailFormKey = GlobalKey<FormFieldState>();
  final tokenFormKey = GlobalKey<FormFieldState>();
  final passwordFormKey = GlobalKey<FormFieldState>();
  final passwordConfirmFormKey = GlobalKey<FormFieldState>();
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

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Mot de passe obligatoire";
    } else if (!Validation.passwordValidator(password)) {
      return AppMessages.atLeastHeightChar;
    } else if (passwordControllerConfirm.text.isNotEmpty &&
        password != passwordControllerConfirm.text) {
      return "Doivent être identiques";
    }
    return null;
  }

  String? validatePasswordConfirm(String? password) {
    if (password == null || password.isEmpty) {
      return "Confirmation obligatoire";
    } else if (passwordController.text.isNotEmpty &&
        password != passwordController.text) {
      return "Doivent être identiques";
    }
    return null;
  }

  request(
      {required AppState appState,
      required String email,
      required Function() onVerify}) async {
    try {
      setState(ViewState.busy);

      await _dioService.put(
        path: resetPasswordPath,
        body: {
          "user": {"email": email},
        },
      );
      setState(ViewState.retrieved);
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
          content: "Cette adresse email n'existe pas",
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
          "user": {"email": email},
          "token": {"type": 2}
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

  verify(
      {required AppState appState,
      required String email,
      required String token,
      required Function() onVerify}) async {
    try {
      setState(ViewState.busy);

      await _dioService.put(
        path: resetPasswordPath,
        body: {
          "user": {"email": email},
          "verify": {"token": token}
        },
      );
      setState(ViewState.retrieved);
    } catch (e) {
      if (e is DioException && e.response!.statusCode == 403) {
        if (timer != null) {
          timer?.cancel();
          delay = 0;
        }
        onVerify();
        _navigationService.showSnackBack(
          content: "Veuillez changer votre mot de passe",
          isError: false,
        );
        setState(ViewState.retrieved);
      } else {
        _navigationService.showSnackBack(
          content: "Code de vérification incorrect",
          isError: true,
        );
        setState(ViewState.retrieved);
      }
    }
  }

  changePassword({
    required AppState appState,
    required String email,
    required String token,
    required String password,
  }) async {
    try {
      setState(ViewState.busy);

      await _dioService.put(
        path: resetPasswordPath,
        body: {
          "user": {"email": email, "password": password},
          "verify": {"token": token}
        },
      );
      _navigationService.showSnackBack(
        content: "Votre mot de passe a été changé",
        isError: false,
      );
      setState(ViewState.retrieved);
      _navigationService.goBack();
    } catch (e) {
      _navigationService.showSnackBack(
        content: "Une erreur est survenue",
        isError: true,
      );
      setState(ViewState.retrieved);
    }
  }
}
