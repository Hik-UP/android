import 'package:flutter/widgets.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/auth/login_page.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/validation.dart';
import 'base_model.dart';

class RegisterPageViewModel extends BaseModel {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordControllerConfirm = TextEditingController();
  final _customNavigationService = locator<CustomNavigationService>();
  final _dioService = locator<DioService>();

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
        MixpanelManager.track('signup');

        _customNavigationService.showSnackBack(
          content: "Votre compte a été créé",
          isError: false,
        );
        _customNavigationService.navigateTo(LoginPage.routeName);
      } else {
        _customNavigationService.showSnackBack(
          content: AppMessages.anErrorOcur,
          isError: true,
        );
      }
      setState(ViewState.retrieved);
    } catch (e) {
      _customNavigationService.showSnackBack(
        content: "Cet utilisateur existe déjà",
        isError: true,
      );
      setState(ViewState.retrieved);
    }
  }
}
