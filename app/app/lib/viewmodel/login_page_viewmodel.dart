import 'package:flutter/widgets.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/validation.dart';

import 'base_model.dart';

class LoginPageViewModel extends BaseModel {
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
}
