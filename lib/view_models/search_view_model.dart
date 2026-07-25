import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/generic_event_entry.dart';
import '../services/service_locator.dart';
import '../utils/constants.dart';
import 'base_view_model.dart';

part 'search_view_model.g.dart';

const hiddenEventTypesKey = 'hiddenEventTypes';

class SearchViewModel extends _SearchViewModel with _$SearchViewModel {}

abstract class _SearchViewModel extends BaseViewModel with Store {
  @override
  String get viewModelName => 'SearchViewModel';

  final _sharedPreferences = serviceLocator<SharedPreferences>();

  static const userIdKey = 'userId';
  static const deviceUuidKey = 'deviceUuid';
  static const appBuildKey = 'appBuild';
  static const daysKey = 'days';
  static const limitKey = 'limit';
  @observable
  String userId = '';

  @observable
  String deviceUuid = '';

  @observable
  String appBuild = '';

  @observable
  int? days = kDefaultDays;

  @observable
  int? limit = kDefaultLimit;

  @observable
  bool showTimestamp = true;

  @observable
  bool showAppName = true;

  @observable
  bool showUserId = false;

  @observable
  bool showDeviceUuid = false;

  @observable
  bool showAppVersion = false;

  @observable
  bool showAppBuild = false;

  @observable
  bool isExpanded = false;

  @observable
  String filter = '';

  @observable
  String search = '';

  final ObservableSet<EntryType> hiddenEventTypes = ObservableSet();

  bool isEventTypeVisible(EntryType entryType) =>
      !hiddenEventTypes.contains(entryType);

  set daysAsString(String value) {
    days = int.tryParse(value);
  }

  set limitAsString(String value) {
    limit = int.tryParse(value);
  }

  String? get daysError {
    if (days == null) {
      return 'Days can\'t be empty';
    }
    return null;
  }

  String? get limitError {
    if (limit == null) {
      return 'Limit can\'t be empty';
    }
    return null;
  }

  @action
  @override
  Future<void> init() async {
    if (userId == '') {
      userId = _sharedPreferences.getString(userIdKey) ?? '';
    }
    if (deviceUuid == '') {
      deviceUuid = _sharedPreferences.getString(deviceUuidKey) ?? '';
    }
    if (appBuild == '') {
      appBuild = _sharedPreferences.getString(appBuildKey) ?? '';
    }

    days = _sharedPreferences.getInt(daysKey) ?? kDefaultDays;
    limit = _sharedPreferences.getInt(limitKey) ?? kDefaultLimit;
    final savedHiddenEventTypes = _sharedPreferences.getStringList(
      hiddenEventTypesKey,
    );
    if (savedHiddenEventTypes != null) {
      hiddenEventTypes
        ..clear()
        ..addAll(
          EntryType.values.where(
            (entryType) => savedHiddenEventTypes.contains(entryType.name),
          ),
        );
    }

    reaction((_) => userId, (value) {
      _sharedPreferences.setString(userIdKey, value);
    });
    reaction((_) => deviceUuid, (value) {
      _sharedPreferences.setString(deviceUuidKey, value);
    });
    reaction((_) => appBuild, (value) {
      _sharedPreferences.setString(appBuildKey, value);
    });
    reaction((_) => days, (value) {
      saveIntReaction(value, daysKey);
    });
    reaction((_) => limit, (value) {
      saveIntReaction(value, limitKey);
    });
    reaction((_) => hiddenEventTypes.toList(), (_) {
      _sharedPreferences.setStringList(
        hiddenEventTypesKey,
        hiddenEventTypes.map((entryType) => entryType.name).toList(),
      );
    });
  }

  void saveIntReaction(int? intValue, String intKey) {
    if (intValue != null) {
      _sharedPreferences.setInt(intKey, intValue);
    } else {
      _sharedPreferences.remove(intKey);
    }
  }

  @action
  void onToggleExpanded() {
    isExpanded = !isExpanded;
  }

  @action
  void setEventTypeVisible(EntryType entryType, {required bool isVisible}) {
    if (isVisible) {
      hiddenEventTypes.remove(entryType);
    } else {
      hiddenEventTypes.add(entryType);
    }
  }

  @action
  void showAllEventTypes() {
    hiddenEventTypes.clear();
  }

  @action
  void hideAllEventTypes() {
    hiddenEventTypes.addAll(EntryType.values);
  }
}
