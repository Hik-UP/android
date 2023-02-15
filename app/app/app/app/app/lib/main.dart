import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/other_data.dart';
import 'package:hikup/model/user.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/auth/login_page.dart';
import 'package:hikup/screen/auth/register_page.dart';
import 'package:hikup/screen/main/home/notification.dart';
import 'package:hikup/screen/main/main_screen.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/local_notification.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:hikup/screen/onboarding_screen.dart';
import 'package:hikup/theme.dart';
import 'firebase_options.dart';
import 'screen/main/setting/update_profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(OtherDataAdapter());
  await Hive.openBox<User>("userBox");
  await Hive.openBox<OtherData>("otherData");
  await LocalNotification().init();

  setupLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppState()..initialState(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  String getTheRightInitialRoute({required BuildContext context}) {
    String userToken = context.read<AppState>().token;

    if (context.read<AppState>().isFirstDownload) {
      return OnboardingScreen.routeName;
    }
    if (userToken.isNotEmpty) {
      return MainScreen.routeName;
    }
    return LoginPage.routeName;
  }

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
      initialRoute: MainScreen.routeName,///getTheRightInitialRoute(context: context),
      routes: {
        LoginPage.routeName: (_) => const LoginPage(),
        NotificationView.routeName: (_) => const NotificationView(),
        RegisterPage.routeName: (_) => const RegisterPage(),
        OnboardingScreen.routeName: (_) => const OnboardingScreen(),
        MainScreen.routeName: (_) => const MainScreen(),
        UpdateProfile.routeName: (_) => const UpdateProfile()
      },
    );
  }
}
