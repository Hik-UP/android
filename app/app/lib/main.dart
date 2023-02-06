import 'package:flutter/material.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/auth/login_page.dart';
import 'package:hikup/screen/auth/register_page.dart';
import 'package:hikup/screen/main/home/notification.dart';
import 'package:hikup/screen/main/main_screen.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:hikup/screen/onboarding_screen.dart';
import 'package:hikup/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppState(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      initialRoute: OnboardingScreen.routeName,
      routes: {
        LoginPage.routeName: (_) => const LoginPage(),
        NotificationView.routeName: (_) => const NotificationView(),
        RegisterPage.routeName: (_) => const RegisterPage(),
        OnboardingScreen.routeName: (_) => const OnboardingScreen(),
        MainScreen.routeName: (_) => const MainScreen()
      },
    );
  }
}
