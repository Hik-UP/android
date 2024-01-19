import 'package:dio/dio.dart';
import 'package:hikup/service/app_interceptors.dart';
import 'package:hikup/utils/constant.dart';

class DioService {
  final _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  addInterceptors() {
    _dio.interceptors.add(AppInterceptors());
  }

  Future<Response> post({
    required String path,
    required Map<String, dynamic> body,
    String token = "",
  }) async {
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

    return result;
  }

  Future<Response> delete({
    required String path,
    required Map<String, dynamic> body,
    String token = "",
  }) async {
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
  }

  Future<Response> put({
    required String path,
    required Map<String, dynamic> body,
    String token = "",
  }) async {
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
  }

  Future<Response> get({required String path}) async {
    var result = await _dio.get("$baseUrl$path");

    return result;
  }
}
