import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/newrelic_api_client.dart';
import 'newrelic_service.dart';

GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  serviceLocator.registerSingleton(NewrelicApiClient().dio);
  serviceLocator.registerLazySingleton(NewrelicService.new);
  final prefs = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton(prefs);
}
