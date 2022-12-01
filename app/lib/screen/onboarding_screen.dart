import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hikup/screen/main/main_screen.dart';
import 'package:hikup/theme.dart';

class OnboardingScreen extends StatelessWidget {
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
            minimumSize: Size(100, 50),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(borderRadiusSize))
          ),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool("skipOnBoarding", true);
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return MainScreen(
                currentScreen: 0,
              );
            }));
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
            content: const Text(
                ''),
          );
        });
  }
}
