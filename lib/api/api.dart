import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

const serverUrl = 'http://dev-hikup.westeurope.cloudapp.azure.com:8080';

class API {
  Future<dynamic> login(String email, String password) async {
    var dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await dio.post(serverUrl + '/api/v2/authenticate',
          options: Options(headers: {
            "authToken": '',
            'Content-Type': 'application/json',
          }),
          data: {'email': email, 'password': password});
      if (response.statusCode == 200) {
        prefs.setString('authToken', response.data['token']);
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
    var dio = Dio();
    try {
      final response = await dio.post(serverUrl + '/api/v2/register',
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
