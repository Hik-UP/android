import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/comment.dart';
import 'package:hikup/model/other_data.dart';
import 'package:hikup/model/sensible_user_data.dart';
import 'package:hikup/model/settings.dart';
import 'package:hikup/model/skin.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/model/user.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/providers/sound_state.dart';
import 'package:hikup/screen/achievement/achievement_view.dart';
import 'package:hikup/screen/auth/login_page.dart';
import 'package:hikup/screen/auth/register_page.dart';
import 'package:hikup/screen/event/all_event_view.dart';
import 'package:hikup/screen/event/create_event_view.dart';
import 'package:hikup/screen/inventory/inventory_view.dart';
import 'package:hikup/screen/main/community/community_history_screen.dart';
import 'package:hikup/screen/main/hike/hikes_create.dart';
import 'package:hikup/screen/main/search/notification.dart';
import 'package:hikup/screen/main/main_screen.dart';
import 'package:hikup/screen/main/setting/complete_profile.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/local_notification.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:hikup/screen/onboarding_screen.dart';
import 'package:hikup/theme.dart';
import 'firebase_options.dart';
import 'screen/main/setting/update_profile.dart';
import 'screen/main/setting/settings_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/screen/auth/reset_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  await MixpanelManager.initMixpanel();

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(OtherDataAdapter());
  Hive.registerAdapter(SkinAdapter());
  Hive.registerAdapter(SensibleUserDataAdapter());
  Hive.registerAdapter(TrailFieldsAdapter());
  Hive.registerAdapter(TrailListAdapter());
  Hive.registerAdapter(CommentAdapter());
  Hive.registerAdapter(AuthorAdapter());
  Hive.registerAdapter(SettingsAdapter());

  await Hive.openBox<User>("userBox");
  await Hive.openBox<OtherData>("otherData");
  await Hive.openBox<SensibleUserData>("sensibleUserDataBox");
  await Hive.openBox<String>("trailId");
  await Hive.openBox<TrailList>("trails");
  await Hive.openBox<Skin>("skinBox");
  await Hive.openBox<Settings>("settings");

  await LocalNotification().init();

  if (!kIsWeb) {
    Stripe.publishableKey = stripePublic;
  }
  setupLocator();

  locator<DioService>().addInterceptors();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppState()..initialState(),
        ),
        ChangeNotifierProvider(
          create: (_) => SoundState(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String getTheRightInitialRoute({required BuildContext context}) {
    String userToken = context.read<AppState>().token;
    context
        .read<SoundState>()
        .setVolume(volume: context.read<AppState>().settings.volume ?? 1);

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
      ],
      debugShowCheckedModeBanner: false,
      navigatorKey: locator<CustomNavigationService>().navigatorKey,
      theme: ThemeData(
        primarySwatch: createMaterialColor(Colors.white),
        scaffoldBackgroundColor: BlackSecondary,
      ),
      initialRoute: getTheRightInitialRoute(context: context),
      routes: {
        LoginPage.routeName: (_) => const LoginPage(),
        ResetPage.routeName: (_) => const ResetPage(),
        NotificationView.routeName: (_) => const NotificationView(),
        RegisterPage.routeName: (_) => const RegisterPage(),
        OnboardingScreen.routeName: (_) => const OnboardingScreen(),
        MainScreen.routeName: (_) => const MainScreen(),
        UpdateProfile.routeName: (_) => const UpdateProfile(),
        SettingsScreen.routeName: (_) => const SettingsScreen(),
        CompleteProfile.routeName: (_) => const CompleteProfile(),
        HikesCreate.routeName: (_) => const HikesCreate(),
        CommunityHistoryScreen.routeName: (_) => const CommunityHistoryScreen(),
        AllEventView.routeName: (_) => const AllEventView(),
        CreateEventView.routeName: (_) => const CreateEventView(),
        AchievementView.routeName: (_) => const AchievementView(),
        InventoryView.routeName: (_) => const InventoryView()
      },
    );
  }
}
