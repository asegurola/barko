import 'package:barko/models/generic_event_entry.dart';
import 'package:barko/services/service_locator.dart';
import 'package:barko/view_models/search_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    await serviceLocator.reset();
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    serviceLocator.registerSingleton<SharedPreferences>(preferences);
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  test('all event types are shown by default', () async {
    final viewModel = SearchViewModel();

    await viewModel.runInit();

    expect(EntryType.values.every(viewModel.isEventTypeVisible), isTrue);
  });

  test('hidden event types persist and show all resets them', () async {
    final viewModel = SearchViewModel();
    await viewModel.runInit();

    viewModel.setEventTypeVisible(EntryType.requestError, isVisible: false);
    await Future<void>.delayed(Duration.zero);

    expect(viewModel.isEventTypeVisible(EntryType.requestError), isFalse);
    expect(
      serviceLocator<SharedPreferences>().getStringList(hiddenEventTypesKey),
      [EntryType.requestError.name],
    );

    final restoredViewModel = SearchViewModel();
    await restoredViewModel.runInit();
    expect(
      restoredViewModel.isEventTypeVisible(EntryType.requestError),
      isFalse,
    );
    expect(restoredViewModel.isEventTypeVisible(EntryType.request), isTrue);

    restoredViewModel.showAllEventTypes();
    await Future<void>.delayed(Duration.zero);

    expect(
      EntryType.values.every(restoredViewModel.isEventTypeVisible),
      isTrue,
    );
    expect(
      serviceLocator<SharedPreferences>().getStringList(hiddenEventTypesKey),
      isEmpty,
    );
  });

  test('hide all hides every event type and persists the selection', () async {
    final viewModel = SearchViewModel();
    await viewModel.runInit();

    viewModel.hideAllEventTypes();
    await Future<void>.delayed(Duration.zero);

    expect(
      EntryType.values.every(
        (entryType) => !viewModel.isEventTypeVisible(entryType),
      ),
      isTrue,
    );
    expect(
      serviceLocator<SharedPreferences>()
          .getStringList(hiddenEventTypesKey)
          ?.toSet(),
      EntryType.values.map((entryType) => entryType.name).toSet(),
    );
  });

  test('legacy unknown network errors are classified as network events', () {
    final entry = GenericEventEntry(
      timestamp: DateTime(2026),
      appName: 'test',
      appVersion: '1.0.0',
      appBuild: '1',
      userId: null,
      deviceUuid: null,
      fields: const {
        'name': 'UnknownNetworkError',
        'errorMessage': 'Connection failed',
      },
    );

    expect(entry.entryType, EntryType.networkEvent);
  });
}
