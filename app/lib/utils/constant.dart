import 'package:flutter/widgets.dart';

import '../model/user.dart';

import '../screen/main/search/search_screen.dart';
import '../screen/main/mapbox/mapbox_screen.dart';

enum ViewState { idle, busy, retrieved }

const env = "PROD";

const baseUrl =
    env == "PROD" ? baseProdApiUrl : baseDevApiUrl; //La base_url de l'api

const logoBlackNoBg = "assets/images/logoBlackNoBg.png";
const msg =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

const baseProdApiUrl = "https://pro-hikup.westeurope.cloudapp.azure.com/api";
const baseDevApiUrl = "https://dev-hikup.westeurope.cloudapp.azure.com/api";
const loginPath = "/auth/login";
const getTrailsPath = "/trail/retrieve";
const getProfilePath = "/user/profile";
const updateProfilePath = "/user/profile/update";

User emptyUser = User(
  id: "",
  name: "",
  email: "",
  accountType: "",
  imageProfile: "",
  roles: [],
  token: "",
);

dynamic loginButtonColor = const LinearGradient(colors: [
  Color.fromARGB(255, 143, 251, 208),
  Color.fromARGB(153, 21, 174, 123),
]);

final screens = [const MapBoxScreen(), const SearchScreen()];

enum TypeInput { text, password }
