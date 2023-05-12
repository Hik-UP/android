import 'package:flutter/material.dart';
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
        backgroundColor: BlackPrimary,
        body: Stack(
          children: [
            screens[_currentIndex],
            Positioned(
              left: 15,
              right: 15,
              bottom: 15,
              child: CustomBottomNavBar(
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
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Quitter'),
            content: const Text('Souhaitez-vous quitter ?'),
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


