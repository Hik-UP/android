import 'package:hikup/utils/app_messages.dart';

class Validation {
  static dynamic emailValidator(String email) {
    return (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email));
  }

  static bool passwordValidator(String password) {
    if (password.length < 8 || password.length > 128) {
      return (false);
    }
    return (true);
  }

  static dynamic usernameValidator(String username) {
    return (RegExp(
            r"^(?=.{8,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$")
        .hasMatch(username));
  }

  static String? validEmail(String? email) {
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

  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return AppMessages.usernameRequired;
    } else if (username.length < 8 || username.length > 24) {
      return "Doit avoir entre 8 et 24 caractères";
    }
    return null;
  }
}
