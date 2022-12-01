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
    imageProfile: "assets/images/user_profile_example.png");

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

var _wifi = FieldFacility(name: "WiFi", imageAsset: "assets/icons/wifi.png");
var _toilet =
    FieldFacility(name: "Toilet", imageAsset: "assets/icons/toilet.png");
var _changingRoom = FieldFacility(
    name: "Changing Room", imageAsset: "assets/icons/changing_room.png");
var _canteen =
    FieldFacility(name: "Canteen", imageAsset: "assets/icons/canteen.png");
var _locker =
    FieldFacility(name: "Lockers", imageAsset: "assets/icons/lockers.png");
var _chargingArea = FieldFacility(
    name: "Charging Area", imageAsset: "assets/icons/charging.png");

RandoField montagneRionov = RandoField(
  id: "01",
  name: "montagne2",
  address: "adresse",
  category: _montagne,
  facilities: [],
  phoneNumber: "",
  openDay: "Tous les jours",
  openTime: "08.00",
  closeTime: "16.00",
  imageAsset: "assets/images/montagne.jpg",
  price: 1,
  author: "Daniel larionov",
  authorUrl: "",
  imageUrl: "",
);

RandoField foretVio = RandoField(
    id: "02",
    name: "foret1",
    address: "adresse",
    category: _foret,
    facilities: [],
    price: 1,
    author: "",
    authorUrl: "",
    imageUrl: "",
    phoneNumber: "9",
    openDay: "Tous les jours",
    openTime: "08.00",
    closeTime: "16.00",
    imageAsset: "assets/images/foret.jpg");
RandoField parcTanjung = RandoField(
    id: "03",
    name: "parc",
    address: "adresse",
    category: _parc,
    facilities: [],
    price: 1,
    author: "",
    authorUrl: "",
    imageUrl: "",
    phoneNumber: "",
    openDay: "Tous les jours",
    openTime: "08.00",
    closeTime: "16.00",
    imageAsset: "assets/images/parc.jpg");

RandoField foretKali = RandoField(
    id: "05",
    name: "foret2",
    address: "adresse",
    category: _foret,
    facilities: [],
    price: 1,
    author: "",
    authorUrl: "",
    imageUrl: "",
    phoneNumber: "",
    openDay: "Tous les jours",
    openTime: "08.00",
    closeTime: "16.00",
    imageAsset: "assets/images/forest.jpg");




RandoField montagneJaya = RandoField(
    id: "09",
    name: "montagne",
    address: "adresse",
    category: _montagne,
    facilities: [],
    price: 1,
    author: "",
    authorUrl: "",
    imageUrl: "",
    phoneNumber: "",
    openDay: "Tous les jours",
    openTime: "08.00",
    closeTime: "16.00",
    imageAsset: "assets/images/montagnes.jpg");



List<RandoField> sportFieldList = [
  montagneRionov,
  foretVio,
  parcTanjung,
  foretKali,
  montagneJaya,
];

List<RandoField> recommendedSportField = [
  foretVio,
  parcTanjung,
  montagneRionov
];

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
