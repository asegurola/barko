import 'dart:io';

import 'package:dio/dio.dart';
import '../../exceptions/invalid_token_exception.dart';

class ApiKeyInterceptor extends Interceptor {
  static String? apiKey;

  bool needAuthorization(String path) {
    return true;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (needAuthorization(options.path)) {
      if (apiKey != null) {
        options.headers['API-Key'] = apiKey;
      }
    }
    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    if (needAuthorization(err.requestOptions.path) &&
        err.type == DioExceptionType.badResponse &&
        err.response?.statusCode == HttpStatus.unauthorized) {
      err = DioException(
          requestOptions: err.requestOptions,
          message: err.message,
          error: InvalidTokenException(),
          response: err.response,
          stackTrace: err.stackTrace,
          type: err.type);
    }

    handler.next(err);
  }
}
