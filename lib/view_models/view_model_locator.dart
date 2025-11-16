import 'package:get_it/get_it.dart';

import 'search_view_model.dart';
import 'settings_view_model.dart';

GetIt viewModelLocator = GetIt.instance;

Future<void> setupViewModelLocator() async {
  viewModelLocator
      .registerLazySingleton<SettingsViewModel>(SettingsViewModel.new);
  viewModelLocator.registerLazySingleton<SearchViewModel>(SearchViewModel.new);
}
