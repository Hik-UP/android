import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hikup/widget/Header/header.dart';
import 'package:hikup/utils/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class PedometerPage extends StatefulWidget {
  static String routeName = "/pedometer";
  @override
  PedometerPageState createState() => PedometerPageState();
}

class PedometerPageState extends State<PedometerPage> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  Future<void> initPlatformState() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _pedestrianStatusStream
          .listen(onPedestrianStatusChanged)
          .onError(onPedestrianStatusError);
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
    } else {}
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: const Header(),
        body: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(56.0)),
            Text(
              'Steps taken:',
              style: TextStyle(fontSize: 30),
            ),
            Text(
              _steps,
              style: TextStyle(fontSize: 60),
            ),
            Divider(
              height: 60,
              thickness: 0,
              color: Colors.white,
            ),
            Text(
              '',
              style: TextStyle(fontSize: 30),
            ),
            Center(
              child: _status == 'walking'
                  ? Image.asset("assets/icons/step1.png")
                  : _status == 'stopped'
                      ? Image.asset("assets/icons/pedometer_stopped.png")
                      : Image.asset("assets/icons/pedometer_stopped.png"),
            ),
            const Padding(padding: EdgeInsets.all(26.0)),
            Center(
              child: Text(
                _status,
                style: _status == 'walking' || _status == 'stopped'
                    ? const TextStyle(fontSize: 30)
                    : const TextStyle(fontSize: 0),
              ),
            )
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
