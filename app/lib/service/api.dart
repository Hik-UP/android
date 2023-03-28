import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

class API {
  Future<String> getServerUrl() async {
    await dotenv.load(fileName: ".env");

    return dotenv.get('SERVER_URL');
  }

  Future<dynamic> login(String email, String password) async {
    String serverUrl = await getServerUrl();
    var dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await dio.post("$serverUrl/api/v2/authenticate",
          options: Options(headers: {
            "authToken": '',
            'Content-Type': 'application/json',
          }),
          data: {'email': email, 'password': password});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("ici ! : " + data);
        prefs.setString('authToken', data['user']['token']);
        prefs.setString('id', data['user']['id']);
        prefs.setString('roles', data['user']['roles'][0]);
      }
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        return e.response;
      } else {
        return null;
      }
    }
  }

  Future<dynamic> register(
      String username, String email, String password) async {
    String serverUrl = await getServerUrl();
    var dio = Dio();
    try {
      final response = await dio.post("$serverUrl/api/v2/register",
          options: Options(headers: {
            "authToken": '',
            'Content-Type': 'application/json',
          }),
          data: {'username': username, 'email': email, 'password': password});
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        return e.response;
      } else {
        return null;
      }
    }
  }
}
