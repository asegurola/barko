import 'dart:async';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:mobx/mobx.dart';

import '../exceptions/user_exception.dart';
import '../models/generic_event_entry.dart';
import '../models/rich_event_entry.dart';
import '../models/search_match.dart';
import '../services/newrelic_service.dart';
import '../services/service_locator.dart';
import 'base_view_model.dart';
import 'search_view_model.dart';
import 'settings_view_model.dart';
import 'view_model_locator.dart';

part 'user_events_view_model.g.dart';

class UserEventsViewModel extends _UserEventsViewModel
    with _$UserEventsViewModel {}

abstract class _UserEventsViewModel extends BaseViewModel with Store {
  @override
  String get viewModelName => 'UserEventsViewModel';

  final _newrelicService = serviceLocator<NewrelicService>();
  final _settingsViewModel = viewModelLocator<SettingsViewModel>();
  final _searchViewModel = viewModelLocator<SearchViewModel>();

  final ObservableList<GenericEventEntry> _events = ObservableList();

  ObservableList<RichEventEntry> filteredEvents = ObservableList();

  @observable
  bool isShowQuery = false;

  @computed
  String get nrquery => _newrelicService.buildQuery(
    accountId: _settingsViewModel.accountId,
    userId: _searchViewModel.userId,
    deviceUuid: _searchViewModel.deviceUuid,
    appBuild: _searchViewModel.appBuild,
    days: _searchViewModel.days,
    limit: _searchViewModel.limit,
    extraFields: _settingsViewModel.extraFieldList,
    extraTables: _settingsViewModel.extraTableList,
  );

  Timer? _debounceSearch;

  @action
  @override
  Future<void> init() async {
    reaction((_) => _searchViewModel.search + _searchViewModel.filter, (_) {
      if (_debounceSearch?.isActive ?? false) _debounceSearch?.cancel();
      _debounceSearch = Timer(
        const Duration(milliseconds: 300),
        doFilteringAndSearch,
      );
    });
  }

  void checkFields() {
    if (_searchViewModel.deviceUuid.isEmpty &&
        _searchViewModel.userId.isEmpty) {
      throw UserException('Either userId or deviceUuid has to be non-empty.');
    }

    if (_searchViewModel.daysError != null ||
        _searchViewModel.limitError != null) {
      throw UserException('Check search fields.');
    }
  }

  @action
  Future<void> fetchUserEvents() async {
    _settingsViewModel.checkSettings();
    try {
      incrementLoading();
      checkFields();
      _events.clear();

      _events.addAll(
        await _newrelicService.getEventsForUser(
          accountId: _settingsViewModel.accountId,
          nrql: nrquery,
        ),
      );
      doFilteringAndSearch();
    } finally {
      decrementLoading();
    }
  }

  @action
  void doFilteringAndSearch() {
    final searchRegExp = RegExp(_searchViewModel.search);
    final filterRegExp = _searchViewModel.filter.isEmpty
        ? null
        : RegExp(_searchViewModel.filter);
    filteredEvents.clear();
    for (final entry in _events) {
      final perFieldMatches = <String, Iterable<RegExpMatch>>{};
      var hasMatches = false;
      var passesFilter = filterRegExp == null ? true : false;
      for (final field in entry.fields.entries) {
        final fieldValueAsString = field.value.toString();
        final matches = searchRegExp.allMatches(fieldValueAsString);
        if (matches.isNotEmpty) {
          perFieldMatches[field.key] = matches;
          hasMatches = true;
        }

        if (filterRegExp != null && !passesFilter) {
          final filterMatch = filterRegExp.firstMatch(fieldValueAsString);
          passesFilter = filterMatch != null;
        }
      }
      if (passesFilter) {
        filteredEvents.add(
          RichEventEntry(
            entry: entry,
            searchMatch: hasMatches ? SearchMatch(perFieldMatches) : null,
          ),
        );
      }
    }
  }

  @action
  Future<void> onDragAndDrop(DropDoneDetails dropDetails) async {
    _settingsViewModel.checkSettings();
    try {
      incrementLoading();
      checkFields();
      _events.clear();

      _events.addAll(
        await _newrelicService.loadEventsFromCsv(
          dropDetails.files.first.path,
          _settingsViewModel.extraFieldList,
        ),
      );
      doFilteringAndSearch();
    } finally {
      decrementLoading();
    }
  }
}
