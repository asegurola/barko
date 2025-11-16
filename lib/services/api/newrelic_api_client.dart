import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:flutter/foundation.dart';

import '../../utils/constants.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';

String get _buildBaseUrl {
  if (kIsWeb) {
    return kWebBaseOrigin;
  } else {
    return kNewrelicApiBaseUrl;
  }
}

class NewrelicApiClient {
  static BaseOptions opts = BaseOptions(
    baseUrl: _buildBaseUrl,
    headers: {
      'Content-Type': 'application/json',
    },
  );

  final Dio _dio = _createDio(opts);

  Dio get dio => _dio;

  static Dio _createDio(BaseOptions opts) {
    final dio = Dio(opts);

    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 20);

    dio.interceptors.add(ApiKeyInterceptor());

    if (kDebugMode) {
      dio.interceptors.add(DioLoggingInterceptor(
        level: Level.body,
        compact: false,
      ));
    }

    dio.interceptors.add(ErrorInterceptor(
      isOverwriteUnauthorizedError:
          false, // set to false since AuthInterceptor will handle 401s with a custom exception
    ));

    return dio;
  }
}
