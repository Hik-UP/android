import 'package:flutter/material.dart';
import 'package:hik_up/tools/location.dart';
import 'package:hik_up/tools/pedometer.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);
  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    pedometer().listen();
    Location().get().then((value) {
      print("latitude: " + value.latitude.toString());
      print("longitude: " + value.longitude.toString());
      print("altitude: " + value.altitude.toString());
    });
    return const Scaffold(
      body: Text("MapPage"),
    );
  }
}
