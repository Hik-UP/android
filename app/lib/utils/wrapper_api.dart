import 'package:dio/dio.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/constant.dart';

class WrapperApi {
  final _dioService = locator<DioService>();

  Future<Response<dynamic>> getProfile({
    required String id,
    required List<dynamic> roles,
    required String token,
  }) async {
    return await _dioService.post(
      path: getProfilePath,
      token: "Bearer $token",
      body: {
        "user": {"id": id, "roles": roles},
      },
    );
  }

  Future<Response<dynamic>> getTrail({
    required String id,
    required List<dynamic> roles,
    required String token,
  }) async {
    return await _dioService.post(
      path: getTrailsPath,
      token: "Bearer $token",
      body: {
        "user": {"id": id, "roles": roles},
      },
    );
  }
}
