import 'package:pedometer/pedometer.dart';

class pedometer {
  Future listen() async {
    Stream<PedestrianStatus> _pedestrianStatusStream;

    void onPedestrianStatusChanged(PedestrianStatus event) {
      String status = event.status;

      print(status);
    }

    void onPedestrianStatusError(error) {
      print("Pedestrian Status Error");
    }

    _pedestrianStatusStream = await Pedometer.pedestrianStatusStream;

    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
  }
}
