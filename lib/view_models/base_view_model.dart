import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:mobx/mobx.dart';

import '../exceptions/invalid_token_exception.dart';
import '../utils/error_handling.dart';

part 'base_view_model.g.dart';

abstract class BaseViewModel extends _BaseViewModel with _$BaseViewModel {}

abstract class _BaseViewModel with Store {
  static const potentialInternetConnectionErrors = {
    DioExceptionType.connectionTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.unknown,
  };

  String get viewModelName;

  final _refreshStreamController = StreamController<void>.broadcast();

  Stream<void> get refreshStream => _refreshStreamController.stream;

  @observable
  var initialized = false;

  @readonly
  var _loading = 0;

  var _isDirty = false;

  @action
  @protected
  void incrementLoading() => _loading++;

  @action
  @protected
  void decrementLoading() {
    if (_loading > 0) {
      _loading--;
    } else {
      recordHandledException(
          'Unbalance loading calls: $runtimeType', StackTrace.current);
    }
  }

  @computed
  bool get isLoading => _loading > 0;

  @observable
  var initFailed = false;

  @computed
  bool get maxRetriesReached => initRetryCounter > 10;

  @observable
  var initRetryCounter = 0;

  @computed
  bool get allowInitRetry => !maxRetriesReached;

  @observable
  String? customInitErrorMessage;

  @action
  @nonVirtual
  Future<void> runInit() async {
    try {
      customInitErrorMessage = null;
      initFailed = false;
      await init();
      initialized = true;
      initRetryCounter = 0;
      _isDirty = false;
    } on DioException catch (e, stackTrace) {
      initFailed = true;
      initRetryCounter++;
      if (e.error is InvalidTokenException) {
        // This needs to be rethrown so that the user is redirected to the log-in screen.
        rethrow;
      }

      if (potentialInternetConnectionErrors.contains(e.type)) {
        customInitErrorMessage =
            'Oops we couldn\'t load some data we need.\nCheck your internet connection.';
      } else if (e.type == DioExceptionType.badResponse &&
          e.response?.statusCode == HttpStatus.forbidden) {
        customInitErrorMessage =
            'Oops we couldn\'t load some data we need.\nIf you are using a VPN try disconnecting from it.';
      } else if (e.type == DioExceptionType.badResponse &&
          e.response?.statusCode == HttpStatus.tooManyRequests) {
        customInitErrorMessage = 'Too many attempts. Wait a bit and try again.';
      }

      recordHandledException(
          'Error initilializing viewModel $viewModelName dio error: $e}',
          stackTrace);
    } catch (e, stackTrace) {
      recordHandledException(
          'Error initilializing viewModel $viewModelName: $e}', stackTrace);
      initFailed = true;
      initRetryCounter++;
    }
  }

  @action
  @protected
  Future<void> init() async {}

  @action
  Future<void> refresh() async {}

  @action
  void fireContentRefreshed() => _refreshStreamController.sink.add(null);

  void dispose() {}

  void markAsDirty() {
    _isDirty = true;
  }

  @action
  Future<void> onScreen() async {
    if (_isDirty) {
      _isDirty = false;
      await refresh();
    }
  }

  @action
  Future<void> onExitApp() async {
    await FlutterExitApp.exitApp(iosForceExit: true);
  }
}
