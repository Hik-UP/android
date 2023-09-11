import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikup/widget/snack_bar.dart';

class CustomNavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  BuildContext get currentContext => navigatorKey.currentState!.context;

  void goBack({dynamic value}) {
    return navigatorKey.currentState!.pop(value);
  }

  Future<dynamic> navigateToAndRemoveUntil(String routeName,
      {dynamic arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  showSnackBack({required String content, bool isError = false}) {
    CustomSnackBar(
      content: content,
      context: navigatorKey.currentState!.context,
      isError: isError,
    ).showSnackBar();
  }

  showDialogue({required Widget content}) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        elevation: 8.0,
        child: content,
      ),
    );
  }
}
