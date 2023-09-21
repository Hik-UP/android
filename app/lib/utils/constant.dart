import 'package:flutter/widgets.dart';
import 'package:hikup/model/achievement.dart';
import 'package:hikup/model/sensible_user_data.dart';
import 'package:hikup/model/skin.dart';
import 'package:flutter/material.dart';
import 'package:hikup/screen/main/setting/settings_screen.dart';
import 'package:hikup/screen/shop/shop_view.dart';
import 'package:hikup/theme.dart';
import 'package:geolocator/geolocator.dart';
import '../model/user.dart';
import '../screen/main/search/search_screen.dart';
import '../screen/main/mapbox/mapbox_screen.dart';

enum ViewState { idle, busy, retrieved }

enum TypeOfHike { organized, guest, attendee }

enum TypeOfInput { text, password }

const env = "DEV";

const baseUrl =
    env == "PROD" ? baseProdApiUrl : baseDevApiUrl; //La base_url de l'api

const baseSocketUrl = env == "PROD"
    ? baseProdSocketUrl
    : baseDevSocketUrl; //La base_url des sockets

const urlTemplateMapBoxDay =
    "https://api.mapbox.com/styles/v1/hikupapp/cle0lx80a00j701qqki8kcxqd/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaGlrdXBhcHAiLCJhIjoiY2w4Mm5lM2l4MDMxbjN1a3A4MXVvNG0wZCJ9.BxVDSc16oILvNK7X5gWF5w";
const urlTemplateMapBoxNight =
    "https://api.mapbox.com/styles/v1/hikupapp/cle6pe8m0005101qmp8irwrda/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaGlrdXBhcHAiLCJhIjoiY2w4Mm5lM2l4MDMxbjN1a3A4MXVvNG0wZCJ9.BxVDSc16oILvNK7X5gWF5w";
const urlTemplateMapBoxCrepu =
    "https://api.mapbox.com/styles/v1/hikupapp/cle6pea5c002z01q92yuxzzw0/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaGlrdXBhcHAiLCJhIjoiY2w4Mm5lM2l4MDMxbjN1a3A4MXVvNG0wZCJ9.BxVDSc16oILvNK7X5gWF5w";

const accessTokenMapBox =
    'pk.eyJ1IjoiaGlrdXBhcHAiLCJhIjoiY2w4Mm5lM2l4MDMxbjN1a3A4MXVvNG0wZCJ9.BxVDSc16oILvNK7X5gWF5w';
const idMapBox = 'mapbox.mapbox-streets-v8';
const logoBlackNoBg = "assets/images/logoBlackNoBg.png";
const logoWhiteNoBg = "assets/images/logoWhiteNoBg.png";
const homeBackgroundDay = 'assets/images/BackgroundForestHome.jpg';
const msg =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

const baseProdApiUrl = "https://pro-hikup.westeurope.cloudapp.azure.com/api";
const baseDevApiUrl = "https://dev-hikup.westeurope.cloudapp.azure.com/api";
const baseProdSocketUrl = "https://pro-hikup.westeurope.cloudapp.azure.com";
const baseDevSocketUrl = "https://dev-hikup.westeurope.cloudapp.azure.com";
const loginPath = "/auth/login";
const getTrailsPath = "/trail/retrieve";
const getProfilePath = "/user/profile";
const updateProfilePath = "/user/profile/update";
const getDetailsPath = "/trail/details";
const createHikePath = "/user/hike/create";
const getHikePath = "/user/hike/retrieve";
const acceptInvitePath = "/user/hike/guest/accept";
const declineInvitePath = "/user/hike/guest/refuse";
const leaveHikePath = "/user/hike/attendee/leave";
const createCommentPath = "/trail/comment/create";
const retrieveNotificationPath = "/user/notification/retrieve";
const notifUpdatePath = "/user/notification/update";
const organzierUpdatePath = "/user/hike/organizer/update";
const getSkinPath = "/skin/retrieve";
const updateCurrentSkinPath = "/skin/update-current-skin";
const skinUnlockPath = "/skin/unlock";
const eventCreatePath = "/event/create";

const pinIcon = "assets/icons/pin.png";
const idHikeIcon = "assets/icons/information.png";
const calendarIcon = "assets/icons/appointment.png";

const stripeSecret =
    "sk_test_51NrvZiAitfOvvPVLJfL8jxdCYnFjdo0J6dUHLCsYwLodGd7WYyQVTEMvcE44iRizSV5GECh4zoLCQt4dIW6SgN5d000XPeZR2S";
const stripePublic =
    "pk_test_51NrvZiAitfOvvPVLHjNCe1YchJk6zqtItsHUul1QuahkHNhF4QpFkNAF8niXZu8uRFO0Zw0lKyHJ9Lmb1Pk2dFax000fY2X14L";

const filledIconNavBar = [
  "assets/icons/HomeFull.png",
  "assets/icons/search.png",
  "assets/icons/settings_fill.png",
  "assets/icons/accessibility_fill.png"
];
const unFilledIconNavBar = [
  "assets/icons/Home.png",
  "assets/icons/search.png",
  "assets/icons/settings_outlined.png",
  "assets/icons/accessibility_outlined.png"
];
const labelNavBar = ["Accueil", "Recherche", "Réglages", "Boutique"];

const iconUserRunning = "assets/icons/achievements/iconUserRunning.png";
const iconUserShoes = "assets/icons/achievements/iconUserShoes.png";
const iconWindBlowing = 'assets/icons/achievements/iconWindBlowing.png';
const customArrowIcon = 'assets/icons/achievements/customArrowIcon.png';

const achievementSampleData = [
  Achievement(
    icon: iconUserRunning,
    title: '1000 KM pour 1000 sourires',
    description: 'A l’aide de vos jambes, marcher 1000 km en souriant',
    smallDescription: '( 1000km / 1000km )',
    progress: 100,
    state: 'FINISH',
  ),
  Achievement(
    icon: iconUserShoes,
    title: 'Quelle belle chaussure !',
    description: 'Utilisez 1 an la même chaussure',
    smallDescription: '( 365j / 365j )',
    progress: 100,
    state: 'FINISH',
  ),
  Achievement(
    icon: iconWindBlowing,
    title: 'Le souffle du vent',
    description: 'Parler avec 4 arbres',
    smallDescription: '( 1 / 4 )',
    progress: 50,
    state: 'IN_PROGRESS',
  ),
];

User emptyUser = User(
  id: "",
  name: "",
  email: "",
  accountType: "",
  imageProfile: "",
  roles: [],
  token: "",
);

Skin emptySkin = const Skin(
  id: "",
  name: "",
  description: "",
  pictures: [],
  model: "",
);

SensibleUserData emptySensibleUserData = SensibleUserData(
  age: 0,
  sex: "",
  weight: 0,
  tall: 0,
);

dynamic loginButtonColor = const LinearGradient(colors: [
  GreenPrimary,
  GreenSecondary,
]);

dynamic deleteButtonColor = const LinearGradient(colors: [
  Color.fromARGB(255, 255, 38, 23),
  Color.fromARGB(255, 248, 5, 5),
]);

dynamic logoutButtonColor = const LinearGradient(colors: [
  Color.fromARGB(255, 5, 201, 240),
  Color.fromARGB(153, 13, 164, 229),
]);

final screens = [
  const MapBoxScreen(),
  const SearchScreen(),
  const SettingsScreen(),
  const ShopView(),
];

enum TypeInput { text, password }

const profilePlaceHoder = "assets/images/user_profile_example.png";
const githubLink = "assets/icons/github.png";
const githubName = "Github";
const stopWatchIcon = "assets/icons/stopwatchIcon.svg";
const targetSkin = "assets/images/target_skin.png";
const coinIcon = "assets/icons/coin.png";

const LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 1,
);
