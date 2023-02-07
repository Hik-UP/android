import 'package:flutter/widgets.dart';

import 'base_model.dart';

class RegisterPageViewModel extends BaseModel {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
}
