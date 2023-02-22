import 'package:flutter/material.dart';
import 'Components/map.dart';
import 'package:hikup/widget/header.dart';

class MapBoxScreen extends StatefulWidget {
  const MapBoxScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MapBoxScreen> createState() => _MapBoxScreenState();
}

class _MapBoxScreenState extends State<MapBoxScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Header(),
      body: MapBox(),
    );
  }
}
