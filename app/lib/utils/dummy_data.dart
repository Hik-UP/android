import 'package:hikup/model/field_facility.dart';
import 'package:hikup/model/field_order.dart';
import 'package:hikup/model/rando_category.dart';
import 'package:hikup/model/rando_field.dart';
import 'package:hikup/model/user.dart';

var sampleUser = User(
    id: "user01",
    name: "User",
    email: "sample@mail.com",
    accountType: "",
    imageProfile: "assets/images/user_profile_example.png",
    roles: [],
    token: "");

var _foret = RandoCategory(
  name: "Foret",
  image: "assets/icons/nature.png",
);
var _montagne = RandoCategory(
  name: "Montagne",
  image: "assets/icons/mountain.png",
);
var _parc = RandoCategory(
  name: "Parc",
  image: "assets/icons/tree-2.png",
);

List<RandoCategory> sportCategories = [
  _foret,
  _parc,
  _montagne,
];

final wifi = FieldFacility(name: "WiFi", imageAsset: "assets/icons/wifi.png");
final toilet =
    FieldFacility(name: "Toilet", imageAsset: "assets/icons/toilet.png");
final changingRoom = FieldFacility(
    name: "Changing Room", imageAsset: "assets/icons/changing_room.png");
final canteen =
    FieldFacility(name: "Canteen", imageAsset: "assets/icons/canteen.png");
final locker =
    FieldFacility(name: "Lockers", imageAsset: "assets/icons/lockers.png");
final chargingArea = FieldFacility(
    name: "Charging Area", imageAsset: "assets/icons/charging.png");

List<FieldOrder> dummyUserOrderList = [];

List<String> timeToBook = [
  "06.00",
  "07.00",
  "08.00",
  "09.00",
  "10.00",
  "11.00",
  "12.00",
  "13.00",
  "14.00",
  "15.00",
  "16.00",
  "17.00",
  "18.00",
  "19.00",
  "20.00",
  "21.00",
  "22.00",
  "23.00"
];
