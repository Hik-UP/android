import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  Future<dynamic> login(String email, String password) async {
    var dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    /*final response = await dio.post("TODO",
        options: Options(headers: {
          "authToken": '',
          'Content-Type': 'application/json',
        }),
        data: {'email': email, 'password': password});*/
    prefs.setString('authToken', '101010101010');
    //return response;
  }

  Future<dynamic> register(
      String username, String email, String password) async {
    var dio = Dio();
    final response = await dio.post("TODO",
        options: Options(headers: {
          "authToken": '',
          'Content-Type': 'application/json',
        }),
        data: {'username': username, 'email': email, 'password': password});
    return response;
  }
}

class Permissions {
  Future<Position> location() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
