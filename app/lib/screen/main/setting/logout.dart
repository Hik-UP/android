import 'package:flutter/material.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/viewmodel/logout_model.dart';

class Logout extends StatelessWidget {
  const Logout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseView<LogoutModel>();
  }
}
