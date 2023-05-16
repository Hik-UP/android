import 'package:dio/dio.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/service/app_interceptors.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';

class DioService {
  final _dio = Dio();
  final _navigator = locator<CustomNavigationService>();

  addInterceptors() {
    _dio.interceptors.add(AppInterceptors());
  }

  Future<Response> post({
    required String path,
    required Map<String, dynamic> body,
    String token = "",
  }) async {
    print(path);
    try {
      var result = await _dio.post(
        "$baseUrl$path",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token,
          },
        ),
        data: body,
      );
      print(result.statusCode);
      return result;
    } on DioError catch (e) {
      if (e.response == null) {
        _navigator.showSnackBack(
          content: AppMessages.anErrorOcur,
          isError: true,
        );
      }
      return e.response!;
    }
  }

  Future<Response> delete({
    required String path,
    required Map<String, dynamic> body,
    String token = "",
  }) async {
    print("$baseUrl$path");
    try {
      var result = await _dio.delete(
        "$baseUrl$path",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token,
          },
        ),
        data: body,
      );

      return result;
    } on DioError catch (e) {
      print(e);
      if (e.response == null) {
        _navigator.showSnackBack(
          content: AppMessages.anErrorOcur,
          isError: true,
        );
      }
      return e.response!;
    }
  }

  Future<Response> put({
    required String path,
    required Map<String, dynamic> body,
    String token = "",
  }) async {
    addInterceptors();

    try {
      var result = await _dio.put(
        "$baseUrl$path",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token,
           
          },
        ),
        data: body,
      );

      return result;
    } on DioError catch (e) {
      return e.response!;
    }
  }

  Future<Response> get({required String path}) async {
    addInterceptors();
    try {
      var result = await _dio.get("$baseUrl$path");

      return result;
    } on DioError catch (e) {
      return e.response!;
    }
  }
}
