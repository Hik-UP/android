import 'package:flutter/material.dart';
import 'Components/map.dart';
import 'Service/geolocation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'HikUp Alpha',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, double> geolocation = {'x': 45.94, 'y': 9.128}; // Argegno

  late MapBox _map;

  @override
  void initState() {
    _map = MapBox(geolocation: geolocation);

    super.initState();
  }

  void _addDefined(double lat, double lon) {
    Icon child = const Icon(
      Icons.fiber_manual_record_rounded,
      color: Color.fromARGB(255, 0, 255, 0),
      size: 24.0,
      semanticLabel: 'Text to announce in accessibility modes',
    );
    Map<String, double> props = {
      'x': lat,
      'y': lon,
      'width': 80.0,
      'height': 80.0,
    };
    _map.addMarker(props, child);
//    _map.move({'x': lat, 'y': lon});

    // setState(() {
    //   geolocation = {'x': lat, 'y': lon};
    //   _map.setGeolocation(geolocation);
    //   _map.move(geolocation);
    // });
  }

  void _goTodefined(double lat, double lon) {
    setState(() {
      geolocation = {'x': lat, 'y': lon};
      _map.setGeolocation(geolocation);
      _map.move(geolocation);
    });
  }

  void _goTomyposition() async {
    Icon child = const Icon(
      Icons.fiber_manual_record_rounded,
      color: Color.fromARGB(255, 255, 0, 0),
      size: 24.0,
      semanticLabel: 'Text to announce in accessibility modes',
    );
    final coord = await Geolocation.getMyPosition();
    Map<String, double> props = {
      'x': coord.latitude,
      'y': coord.longitude,
      'width': 80.0,
      'height': 80.0,
    };
    _map.addMarker(props, child);
    _map.move({'x': coord.latitude, 'y': coord.longitude});
  }

  double _lat = 0.0;
  double _lon = 0.0;

  @override
  Widget build(BuildContext context) {
    final latCon = TextEditingController();
    final lonCon = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: _map,
      persistentFooterButtons: [
        SizedBox(
          width: 100.0,
          child: TextField(
            controller: latCon,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Latitude',
            ),
          ),
        ),
        SizedBox(
          width: 100.0,
          child: TextField(
            controller: lonCon,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Longitude',
            ),
          ),
        ),
        FloatingActionButton(
          // go to defined position
          onPressed: () => {
            setState(() {
              if (latCon.text != '' && lonCon.text != '') {
                _lat = double.parse(latCon.text);
                _lon = double.parse(lonCon.text);
                _goTodefined(_lat, _lon);
              } else {
                print("Uno dei due campi è vuoto");
                // TODO gestire meglio, magari con un popup
              }
            })
          },
          child: const Icon(Icons.line_axis_rounded),
          backgroundColor: Color.fromARGB(255, 0, 144, 255),
        ),
        FloatingActionButton(
          // add defined position
          onPressed: () => {
            setState(() {
              if (latCon.text != '' && lonCon.text != '') {
                _lat = double.parse(latCon.text);
                _lon = double.parse(lonCon.text);
                _addDefined(_lat, _lon);
              } else {
                print("Uno dei due campi è vuoto");
                // TODO gestire meglio, magari con un popup
              }
            })
          },
          child: const Icon(Icons.lightbulb_circle),
          backgroundColor: Color.fromARGB(255, 0, 255, 0),
        ),
        FloatingActionButton(
          // go to my position
          onPressed: _goTomyposition,
          child: const Icon(Icons.navigation),
          backgroundColor: Colors.red,
        ),
      ],
    );
  }
}
