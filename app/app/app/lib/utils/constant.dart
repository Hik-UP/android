import 'package:flutter/widgets.dart';

import '../screen/main/community/community_history_screen.dart';
import '../screen/main/home/home_screen.dart';
import '../screen/main/navigation/main.dart';
import '../screen/main/setting/settings_screen.dart';

enum ViewState { idle, busy, retrieved }

const baseUrl = ""; //La base_url de l'api

const logoBlackNoBg = "assets/images/logoBlackNoBg.png";
const msg =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

const baseApiUrl = "https://pro-hikup.westeurope.cloudapp.azure.com/api";
const loginPath = "/auth/login";

dynamic loginButtonColor = const LinearGradient(colors: [
  Color.fromARGB(255, 143, 251, 208),
  Color.fromARGB(153, 21, 174, 123),
]);

final screens = [
  const HomeScreen(),
  const CommunityHistoryScreen(),
  const SettingsScreen(),
  const MyHomePage(),
];

enum TypeInput { text, password }
