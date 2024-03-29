import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/providers/app_state.dart';

import 'package:hikup/service/geolocation.dart';
import 'package:hikup/service/local_notification.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/widget/custom_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../utils/constant.dart';

class MainScreen extends StatefulWidget {
  static String routeName = "/main-screen";
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Geolocation.getMyPosition();
    context.read<AppState>().getUserFcmToken();
    // context.read<SoundState>().playAudio(
    //     soundSource:
    //         'sounds/music.mp3'); //Un exemple de comment jouer une music

    // audioPlayer.play(AssetSource('sounds/BackgroundMusic1.mp3'));
    // audioPlayer.setVolume(0.5);
    // audioPlayer.setReleaseMode(ReleaseMode.loop);
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
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Non',
                  style: GoogleFonts.poppins(
                    color: BlackPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Oui',
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
