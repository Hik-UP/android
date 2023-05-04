import 'package:flutter/material.dart';
import 'Components/map.dart';
import 'package:hikup/widget/header.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/model/comment.dart';

class MapBoxScreen extends StatefulWidget {
  const MapBoxScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MapBoxScreen> createState() => _MapBoxScreenState();
}

class _MapBoxScreenState extends State<MapBoxScreen> {
  PanelController _pc = new PanelController();
  int id = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Header(),
      body: SlidingUpPanel(
        controller: _pc,
        renderPanelSheet: false,
        panel: _floatingPanel(),
        collapsed: _floatingCollapsed(),
        minHeight: 140,
        body: MapBox(
          panelController: _pc
        ),
      )
    );
  }

  Widget _floatingCollapsed(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 75.0),
      child: Center(
        child: Text(
          "NONE",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _floatingPanel(){
    return Container(
      decoration: BoxDecoration(
        color:BlackPrimary,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(15.0),
      child: Center(
        child: Text(
          "NONE",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
