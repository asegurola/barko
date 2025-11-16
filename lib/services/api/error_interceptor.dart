import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import 'dio_error_message.dart';

class ErrorInterceptor extends Interceptor {
  bool isOverwriteUnauthorizedError;

  ErrorInterceptor({this.isOverwriteUnauthorizedError = true});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_isResponseWithError(response)) {
      final dioError = DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: _getErrorMessage(response),
      );
      handler.reject(dioError, true);
    } else {
      super.onResponse(response, handler);
    }
  }

  bool _isResponseWithError(Response response) {
    return response.data != null &&
        response.data is Map &&
        response.data['header'] != null &&
        response.data['header']['status'] != null &&
        response.data['header']['status'] is String &&
        'Success'.toLowerCase() !=
            response.data['header']['status'].toString().toLowerCase();
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    Object? error;
    switch (err.type) {
      case DioExceptionType.cancel:
        error = DioErrorMessage(message: 'Request to API server was cancelled');
        break;
      case DioExceptionType.connectionTimeout:
        error = DioErrorMessage(message: 'Connection to API server timed out');
        break;
      case DioExceptionType.connectionError:
        error = DioErrorMessage(message: 'Connection to API server failed');
        break;
      case DioExceptionType.receiveTimeout:
        error = DioErrorMessage(
            message: 'Receive timeout in connection with API server');
        break;
      case DioExceptionType.sendTimeout:
        error = DioErrorMessage(
            message: 'Send timeout in connection with API server');
        break;
      case DioExceptionType.badResponse:
        final response = err.response;
        if (response == null) {
          error = DioErrorMessage(message: 'Invalid response');
          break;
        }

        if (response.statusCode == HttpStatus.unauthorized) {
          if (isOverwriteUnauthorizedError) {
            error = DioErrorMessage(message: 'Unauthorized');
          }
        } else if (response.statusCode == HttpStatus.forbidden) {
          error = DioErrorMessage(message: 'Forbidden');
        } else if (response.statusCode == HttpStatus.notFound) {
          error = DioErrorMessage(
              message: '${response.statusCode} Page not found.');
        } else if (response.data is String) {
          error = DioErrorMessage(
              message: '${response.statusCode}: ${response.data}');
        } else {
          error = DioErrorMessage(
              showMessage: true,
              message:
                  'Received status code: ${response.statusCode} body:${response.data}');
        }

        break;
      case DioExceptionType.badCertificate:
        error = DioErrorMessage(message: 'Bad certificate');
        break;
      case DioExceptionType.unknown:
        error = DioErrorMessage(message: 'Unknown connectivity error');
        break;
    }
    log(
      'Dio Error: $error Message: ${err.message} Response: ${jsonEncode(err.response?.data)}',
      stackTrace: err.stackTrace,
    );

    err = DioException(
      requestOptions: err.requestOptions,
      message: err.message,
      error: error,
      response: err.response,
      stackTrace: err.stackTrace,
      type: err.type,
    );

    handler.next(err);
  }

  dynamic _getErrorMessage(Response response) {
    if (response.data == null || response.data['header'] == null) {
      return DioErrorMessage(message: null);
    }
    if (response.data['header']['displayMessage'] != null) {
      return DioErrorMessage(
          showMessage: true,
          message: response.data['header']['displayMessage']);
    }
    if (response.data['header']['message'] != null) {
      return DioErrorMessage(message: response.data['header']['message']);
    }
    if (response.data['message'] != null) {
      return DioErrorMessage(message: response.data['message']);
    }
    return null;
  }
}
