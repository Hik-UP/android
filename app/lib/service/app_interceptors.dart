import 'dart:async';

import 'package:dio/dio.dart';
import 'package:hikup/utils/wrapper_api.dart';

class AppInterceptors extends Interceptor {
  @override
  FutureOr<dynamic> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response != null &&
        err.response!.statusCode == 401 &&
        err.response!.data["error"] != 'Unauthorized') {
      //When we execute a request, a 401 is for UnAuthorised (Token is expired), using Interceptor we verify if the status code of the reponse
      // Of the request is equal to 401
      // If is equal to 401, then we will code or call the function logout user inside this brackets

      await WrapperApi().logout(isLogout: false);
    }

    handler.next(err);
  }
}
