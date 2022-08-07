import 'package:dio/dio.dart';

class API {
  Future<dynamic> login() async {
    var dio = Dio();
    final response = await dio.post("TODO",
      options: Options(headers: {
      "authToken": '',
      'Content-Type': 'application/json',
      }),
      data: {'email': '', 'password': ''}
    );
    return response;
  }

  Future<dynamic> register() async {
    var dio = Dio();
    final response = await dio.post("TODO",
      options: Options(headers: {
      "authToken": '',
      'Content-Type': 'application/json',
      }),
      data: {'username': '', 'email': '', 'password': '', 'name': '', 'lstName': ''}
    );
    return response;
  }
}
