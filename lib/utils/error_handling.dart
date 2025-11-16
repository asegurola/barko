import 'package:flutter/material.dart';

import '../main.dart';

void recordHandledException(String message, StackTrace? stackTrace) {
  debugPrint(message);
  debugPrintStack(stackTrace: stackTrace);
}

void reportErrorDetails(FlutterErrorDetails flutterErrorDetails) {
  const errors = <String>[
    'rendering library',
    'widgets library',
  ];

  if (flutterErrorDetails.silent) {
    recordHandledException('Silent: ${flutterErrorDetails.exceptionAsString()}',
        flutterErrorDetails.stack);
  } else if (errors.contains(flutterErrorDetails.library)) {
    recordHandledException(
        'Library ${flutterErrorDetails.library}: ${flutterErrorDetails.exceptionAsString()}',
        flutterErrorDetails.stack);
  } else {
    reportError(flutterErrorDetails.exception, flutterErrorDetails.stack);
  }
}

void reportError(Object error, StackTrace? stackTrace) {
  final context = navigationKey.currentContext;
  final errorText = error.toString();
  recordHandledException(errorText, stackTrace);
  if (context != null && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(errorText),
      duration: const Duration(seconds: 4),
    ));
  }
}
