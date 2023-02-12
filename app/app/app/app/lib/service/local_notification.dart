import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/screen/main/home/notification.dart';
import 'package:hikup/service/custom_navigation.dart';

class LocalNotification {
  static final LocalNotification _localNotification =
      LocalNotification._internal();

  factory LocalNotification() {
    return _localNotification;
  }

  LocalNotification._internal();

  init() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings("app_icon");

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification:
          (int index, String? value1, String? value2, String? value3) {},
    );
// app_icon
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: null,
    );

    await FlutterLocalNotificationsPlugin().initialize(
      initializationSettings,
      onSelectNotification: (String? value) {
        locator<CustomNavigationService>().navigateTo(
          NotificationView.routeName,
        );
      },
    );
  }

  showNotification(RemoteNotification? notification) async {
    await FlutterLocalNotificationsPlugin().show(
      notification.hashCode,
      notification!.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '1',
          'channel name',
          playSound: true,
          priority: Priority.high,
          importance: Importance.high,
          styleInformation: BigTextStyleInformation(''),
        ),
      ),
    );
  }

  static foregroundNotif() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        LocalNotification().showNotification(notification);
      }
    });
  }

  static onMessageApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      if (message!.notification != null &&
          message.notification!.android != null) {
        locator<CustomNavigationService>().navigateTo(
          NotificationView.routeName,
        );
      }
    });
  }

  static getInitialMessage() async {
    RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (remoteMessage != null) {
      locator<CustomNavigationService>().navigateTo(
        NotificationView.routeName,
      );
    }
  }
}
