import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'services/service_locator.dart';
import 'utils/error_handling.dart';
import 'view_models/view_model_locator.dart';
import 'views/user_events/main_app_view.dart';

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        reportErrorDetails(details);
      };

      await setupServiceLocator();
      await setupViewModelLocator();

      if (kIsWeb) {
        usePathUrlStrategy();
      }

      runApp(const MyApp());
    },
    (error, stackTrace) {
      debugPrint('Unhandled Error: $error StackTrace: $stackTrace');
      reportError(error, stackTrace);
    },
  );
}

final navigationKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            name: 'root',
            builder: (context, state) {
              final params = state.uri.queryParameters;

              final userId = params['userId'];
              final deviceUuid = params['deviceUuid'];
              final appBuild = params['appBuild'];
              final filter = params['filter'];
              final search = params['search'];
              final limitText = params['limit'];
              final daysText = params['days'];

              final limit = int.tryParse(limitText ?? '');
              final days = int.tryParse(daysText ?? '');

              return MainAppView(
                key: navigationKey,
                userId: userId,
                deviceUuid: deviceUuid,
                appBuild: appBuild,
                limit: limit,
                days: days,
                filter: filter,
                search: search,
              );
            },
          ),
        ],
      ),
      title: 'Barko',
      // navigatorKey: navigationKey,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.light,
    );
  }
}
