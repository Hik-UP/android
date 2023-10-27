import 'package:flutter/material.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/viewmodel/logout_model.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseView<LogoutModel>();
  }
}
