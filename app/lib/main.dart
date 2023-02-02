import 'package:flutter/material.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/main/home/notification.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hikup/screen/main/main_screen.dart';
import 'package:hikup/screen/onboarding_screen.dart';
import 'package:hikup/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  final prefs = await SharedPreferences.getInstance();
  final skipOnBoarding = prefs.getBool("skipOnBoarding") ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppState(),
        )
      ],
      child: MyApp(
        skipOnBoarding: skipOnBoarding,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool skipOnBoarding;

  const MyApp({Key? key, required this.skipOnBoarding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hikup',
      debugShowCheckedModeBanner: false,
      navigatorKey: locator<CustomNavigationService>().navigatorKey,
      theme: ThemeData(
        primarySwatch: createMaterialColor(primaryColor500),
        canvasColor: colorWhite,
      ),
      home: skipOnBoarding ? MainScreen(currentScreen: 0) : OnboardingScreen(),
      routes: {
        NotificationView.routeName: (_) => const NotificationView(),
      },
    );
  }
}
