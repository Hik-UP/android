import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/local_notification.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/widget/custom_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../utils/constant.dart';

class MainScreen extends StatefulWidget {
  static String routeName = "/main-screen";
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<AppState>().getUserFcmToken();

    LocalNotification.foregroundNotif();
    LocalNotification.onMessageApp();
    LocalNotification.getInitialMessage();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _onBackPressed(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: backgroundColor,
              statusBarIconBrightness: Brightness.dark),
        ),
        backgroundColor: backgroundColor,
        body: screens[_currentIndex],
        bottomNavigationBar: CustomBottomNavBar(
          defaultSelectedIndex: _currentIndex,
          selectedItemIcon: filledIconNavBar,
          unselectedItemIcon: unFilledIconNavBar,
          label: labelNavBar,
          onChange: (val) {
            setState(() {
              _currentIndex = val;
            });
          },
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit the App'),
            content: const Text('Voulez vous quitter?'),
            actions: <Widget>[
              // const SizedBox(height: 16),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Non')),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Oui'),
              ),
            ],
          ),
        ) ??
        false;
  }
}


