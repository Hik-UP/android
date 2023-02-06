import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hikup/screen/auth/login_page.dart';
import 'package:hikup/theme.dart';

class OnboardingScreen extends StatelessWidget {
  static String routeName = "/onBoarding";
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Future.delayed(Duration.zero, () => showWelcomeDialog(context));
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: backgroundColor,
            statusBarIconBrightness: Brightness.dark),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadiusSize))),
          onPressed: () async {
            Navigator.of(context).pushNamed(LoginPage.routeName);
          },
          child: Text(
            "Explorer",
            style: buttonTextStyle,
          ),
        ),
      ),
    );
  }

  showWelcomeDialog(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
            title: const Text(""),
            content: const Text(''),
          );
        });
  }
}
