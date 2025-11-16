// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SearchViewModel on _SearchViewModel, Store {
  late final _$userIdAtom =
      Atom(name: '_SearchViewModel.userId', context: context);

  @override
  String get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(String value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  late final _$deviceUuidAtom =
      Atom(name: '_SearchViewModel.deviceUuid', context: context);

  @override
  String get deviceUuid {
    _$deviceUuidAtom.reportRead();
    return super.deviceUuid;
  }

  @override
  set deviceUuid(String value) {
    _$deviceUuidAtom.reportWrite(value, super.deviceUuid, () {
      super.deviceUuid = value;
    });
  }

  late final _$appBuildAtom =
      Atom(name: '_SearchViewModel.appBuild', context: context);

  @override
  String get appBuild {
    _$appBuildAtom.reportRead();
    return super.appBuild;
  }

  @override
  set appBuild(String value) {
    _$appBuildAtom.reportWrite(value, super.appBuild, () {
      super.appBuild = value;
    });
  }

  late final _$daysAtom = Atom(name: '_SearchViewModel.days', context: context);

  @override
  int? get days {
    _$daysAtom.reportRead();
    return super.days;
  }

  @override
  set days(int? value) {
    _$daysAtom.reportWrite(value, super.days, () {
      super.days = value;
    });
  }

  late final _$limitAtom =
      Atom(name: '_SearchViewModel.limit', context: context);

  @override
  int? get limit {
    _$limitAtom.reportRead();
    return super.limit;
  }

  @override
  set limit(int? value) {
    _$limitAtom.reportWrite(value, super.limit, () {
      super.limit = value;
    });
  }

  late final _$showTimestampAtom =
      Atom(name: '_SearchViewModel.showTimestamp', context: context);

  @override
  bool get showTimestamp {
    _$showTimestampAtom.reportRead();
    return super.showTimestamp;
  }

  @override
  set showTimestamp(bool value) {
    _$showTimestampAtom.reportWrite(value, super.showTimestamp, () {
      super.showTimestamp = value;
    });
  }

  late final _$showAppNameAtom =
      Atom(name: '_SearchViewModel.showAppName', context: context);

  @override
  bool get showAppName {
    _$showAppNameAtom.reportRead();
    return super.showAppName;
  }

  @override
  set showAppName(bool value) {
    _$showAppNameAtom.reportWrite(value, super.showAppName, () {
      super.showAppName = value;
    });
  }

  late final _$showUserIdAtom =
      Atom(name: '_SearchViewModel.showUserId', context: context);

  @override
  bool get showUserId {
    _$showUserIdAtom.reportRead();
    return super.showUserId;
  }

  @override
  set showUserId(bool value) {
    _$showUserIdAtom.reportWrite(value, super.showUserId, () {
      super.showUserId = value;
    });
  }

  late final _$showDeviceUuidAtom =
      Atom(name: '_SearchViewModel.showDeviceUuid', context: context);

  @override
  bool get showDeviceUuid {
    _$showDeviceUuidAtom.reportRead();
    return super.showDeviceUuid;
  }

  @override
  set showDeviceUuid(bool value) {
    _$showDeviceUuidAtom.reportWrite(value, super.showDeviceUuid, () {
      super.showDeviceUuid = value;
    });
  }

  late final _$showAppVersionAtom =
      Atom(name: '_SearchViewModel.showAppVersion', context: context);

  @override
  bool get showAppVersion {
    _$showAppVersionAtom.reportRead();
    return super.showAppVersion;
  }

  @override
  set showAppVersion(bool value) {
    _$showAppVersionAtom.reportWrite(value, super.showAppVersion, () {
      super.showAppVersion = value;
    });
  }

  late final _$showAppBuildAtom =
      Atom(name: '_SearchViewModel.showAppBuild', context: context);

  @override
  bool get showAppBuild {
    _$showAppBuildAtom.reportRead();
    return super.showAppBuild;
  }

  @override
  set showAppBuild(bool value) {
    _$showAppBuildAtom.reportWrite(value, super.showAppBuild, () {
      super.showAppBuild = value;
    });
  }

  late final _$isExpandedAtom =
      Atom(name: '_SearchViewModel.isExpanded', context: context);

  @override
  bool get isExpanded {
    _$isExpandedAtom.reportRead();
    return super.isExpanded;
  }

  @override
  set isExpanded(bool value) {
    _$isExpandedAtom.reportWrite(value, super.isExpanded, () {
      super.isExpanded = value;
    });
  }

  late final _$filterAtom =
      Atom(name: '_SearchViewModel.filter', context: context);

  @override
  String get filter {
    _$filterAtom.reportRead();
    return super.filter;
  }

  @override
  set filter(String value) {
    _$filterAtom.reportWrite(value, super.filter, () {
      super.filter = value;
    });
  }

  late final _$searchAtom =
      Atom(name: '_SearchViewModel.search', context: context);

  @override
  String get search {
    _$searchAtom.reportRead();
    return super.search;
  }

  @override
  set search(String value) {
    _$searchAtom.reportWrite(value, super.search, () {
      super.search = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_SearchViewModel.init', context: context);

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$_SearchViewModelActionController =
      ActionController(name: '_SearchViewModel', context: context);

  @override
  void onToggleExpanded() {
    final _$actionInfo = _$_SearchViewModelActionController.startAction(
        name: '_SearchViewModel.onToggleExpanded');
    try {
      return super.onToggleExpanded();
    } finally {
      _$_SearchViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
userId: ${userId},
deviceUuid: ${deviceUuid},
appBuild: ${appBuild},
days: ${days},
limit: ${limit},
showTimestamp: ${showTimestamp},
showAppName: ${showAppName},
showUserId: ${showUserId},
showDeviceUuid: ${showDeviceUuid},
showAppVersion: ${showAppVersion},
showAppBuild: ${showAppBuild},
isExpanded: ${isExpanded},
filter: ${filter},
search: ${search}
    ''';
  }
}
