import 'package:dio/dio.dart';
import 'package:hikup/utils/constant.dart';

class DioService {
  final _dio = Dio();

  Future<Response> post({
    required String path,
    required Map<String, dynamic> body,
    String token = "",
  }) async {
    try {
      var result = await _dio.post(
        "$baseUrl$path",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token,
            // "Authorization": token,
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
    try {
      var result = await _dio.get("$baseUrl$path");

      return result;
    } on DioError catch (e) {
      return e.response!;
    }
  }
}
