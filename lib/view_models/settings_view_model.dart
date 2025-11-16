import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../exceptions/needs_settings.dart';
import '../services/api/auth_interceptor.dart';
import '../services/service_locator.dart';
import 'base_view_model.dart';

part 'settings_view_model.g.dart';

class SettingsViewModel extends _SettingsViewModel with _$SettingsViewModel {}

abstract class _SettingsViewModel extends BaseViewModel with Store {
  @override
  String get viewModelName => 'SettingsViewModel';

  final _sharedPreferences = serviceLocator<SharedPreferences>();

  @observable
  String apiKey = '';

  @observable
  String accountId = '';

  @observable
  String extraTables = '';

  @observable
  String extraFields = '';

  bool dataLoaded = false;

  List<String> get extraTableList {
    final result = extraTables.split(',');
    result.removeWhere((element) => element.isEmpty);
    return result;
  }

  List<String> get extraFieldList {
    final result = extraFields.split(',');
    result.removeWhere((element) => element.isEmpty);
    return result;
  }

  @action
  @override
  Future<void> init() async {
    _loadData();
    reaction((_) => apiKey, (value) {
      ApiKeyInterceptor.apiKey = value;
      _sharedPreferences.setString('apiKey', value);
    });
    reaction((_) => accountId, (value) {
      _sharedPreferences.setString('accountId', value);
    });
    reaction((_) => extraTables, (value) {
      _sharedPreferences.setString('extraTables', value);
    });
    reaction((_) => extraFields, (value) {
      _sharedPreferences.setString('extraFields', value);
    });
  }

  void _loadData() {
    if (dataLoaded) return;
    apiKey = _sharedPreferences.getString('apiKey') ?? '';
    ApiKeyInterceptor.apiKey = apiKey;
    accountId = _sharedPreferences.getString('accountId') ?? '';
    extraTables = _sharedPreferences.getString('extraTables') ?? '';
    extraFields = _sharedPreferences.getString('extraFields') ?? '';
    dataLoaded = true;
  }

  void checkSettings() {
    _loadData();
    if (apiKey.isEmpty || accountId.isEmpty) {
      throw NeedsSettings();
    }
  }
}
