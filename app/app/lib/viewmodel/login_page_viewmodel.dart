
import 'package:flutter/widgets.dart';

import 'base_model.dart';

class LoginPageViewModel extends BaseModel {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
}