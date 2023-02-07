
class Validation {
  static dynamic emailValidator(String email) {
      return (RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email));
    }

    static bool  passwordValidator(String password) {
      
      if (password.length < 8) {
        return (false);
      }
      return (true);
    }
  static dynamic usernameValidator(String username) {
      return (RegExp(
              r"^(?=.{8,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$")
          .hasMatch(username));
    }

}