// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BaseViewModel on _BaseViewModel, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading,
              name: '_BaseViewModel.isLoading'))
          .value;
  Computed<bool>? _$maxRetriesReachedComputed;

  @override
  bool get maxRetriesReached => (_$maxRetriesReachedComputed ??= Computed<bool>(
          () => super.maxRetriesReached,
          name: '_BaseViewModel.maxRetriesReached'))
      .value;
  Computed<bool>? _$allowInitRetryComputed;

  @override
  bool get allowInitRetry =>
      (_$allowInitRetryComputed ??= Computed<bool>(() => super.allowInitRetry,
              name: '_BaseViewModel.allowInitRetry'))
          .value;

  late final _$initializedAtom =
      Atom(name: '_BaseViewModel.initialized', context: context);

  @override
  bool get initialized {
    _$initializedAtom.reportRead();
    return super.initialized;
  }

  @override
  set initialized(bool value) {
    _$initializedAtom.reportWrite(value, super.initialized, () {
      super.initialized = value;
    });
  }

  late final _$_loadingAtom =
      Atom(name: '_BaseViewModel._loading', context: context);

  int get loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  int get _loading => loading;

  @override
  set _loading(int value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  late final _$initFailedAtom =
      Atom(name: '_BaseViewModel.initFailed', context: context);

  @override
  bool get initFailed {
    _$initFailedAtom.reportRead();
    return super.initFailed;
  }

  @override
  set initFailed(bool value) {
    _$initFailedAtom.reportWrite(value, super.initFailed, () {
      super.initFailed = value;
    });
  }

  late final _$initRetryCounterAtom =
      Atom(name: '_BaseViewModel.initRetryCounter', context: context);

  @override
  int get initRetryCounter {
    _$initRetryCounterAtom.reportRead();
    return super.initRetryCounter;
  }

  @override
  set initRetryCounter(int value) {
    _$initRetryCounterAtom.reportWrite(value, super.initRetryCounter, () {
      super.initRetryCounter = value;
    });
  }

  late final _$customInitErrorMessageAtom =
      Atom(name: '_BaseViewModel.customInitErrorMessage', context: context);

  @override
  String? get customInitErrorMessage {
    _$customInitErrorMessageAtom.reportRead();
    return super.customInitErrorMessage;
  }

  @override
  set customInitErrorMessage(String? value) {
    _$customInitErrorMessageAtom
        .reportWrite(value, super.customInitErrorMessage, () {
      super.customInitErrorMessage = value;
    });
  }

  late final _$runInitAsyncAction =
      AsyncAction('_BaseViewModel.runInit', context: context);

  @override
  Future<void> runInit() {
    return _$runInitAsyncAction.run(() => super.runInit());
  }

  late final _$initAsyncAction =
      AsyncAction('_BaseViewModel.init', context: context);

  @override
  @protected
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$refreshAsyncAction =
      AsyncAction('_BaseViewModel.refresh', context: context);

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  late final _$onScreenAsyncAction =
      AsyncAction('_BaseViewModel.onScreen', context: context);

  @override
  Future<void> onScreen() {
    return _$onScreenAsyncAction.run(() => super.onScreen());
  }

  late final _$onExitAppAsyncAction =
      AsyncAction('_BaseViewModel.onExitApp', context: context);

  @override
  Future<void> onExitApp() {
    return _$onExitAppAsyncAction.run(() => super.onExitApp());
  }

  late final _$_BaseViewModelActionController =
      ActionController(name: '_BaseViewModel', context: context);

  @override
  @protected
  void incrementLoading() {
    final _$actionInfo = _$_BaseViewModelActionController.startAction(
        name: '_BaseViewModel.incrementLoading');
    try {
      return super.incrementLoading();
    } finally {
      _$_BaseViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  @protected
  void decrementLoading() {
    final _$actionInfo = _$_BaseViewModelActionController.startAction(
        name: '_BaseViewModel.decrementLoading');
    try {
      return super.decrementLoading();
    } finally {
      _$_BaseViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void fireContentRefreshed() {
    final _$actionInfo = _$_BaseViewModelActionController.startAction(
        name: '_BaseViewModel.fireContentRefreshed');
    try {
      return super.fireContentRefreshed();
    } finally {
      _$_BaseViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
initialized: ${initialized},
initFailed: ${initFailed},
initRetryCounter: ${initRetryCounter},
customInitErrorMessage: ${customInitErrorMessage},
isLoading: ${isLoading},
maxRetriesReached: ${maxRetriesReached},
allowInitRetry: ${allowInitRetry}
    ''';
  }
}
