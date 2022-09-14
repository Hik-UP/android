import 'package:dio/dio.dart';
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
