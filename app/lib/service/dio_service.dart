import 'package:dio/dio.dart';
import 'package:hikup/utils/constant.dart';

class DioService {
  final _dio = Dio();

  Future<Response> post(
      {required String routeName, required Map<String, dynamic> body}) async {
    try {
      var result = await _dio.post("$baseUrl$routeName");

      return result;
    } on DioError catch (e) {
      print(e);
      return e.response!;
    }
  }
}