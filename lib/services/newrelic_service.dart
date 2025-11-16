import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../exceptions/user_exception.dart';
import '../models/generic_event_entry.dart';
import '../utils/constants.dart';
import 'service_locator.dart';

String get _buildBasePath {
  if (kIsWeb) {
    return '/newrelic/graphql';
  } else {
    return '/graphql';
  }
}

class NewrelicService {
  final Dio _apiClient = serviceLocator<Dio>();

  List<String> buildQueryFields({List<String> extraFields = const []}) {
    var fields =
        'category,appName,appVersion,deviceUuid,appBuild,timestamp,appName,userId,deviceUuid,device,appVersion,responseTime,crashLocation,crashMessage,deviceModel,deviceManufacturer,name,exceptionMessage,stackTrace,flutterStackTrace,requestMethod,statusCode,platform,platformVersion,architecture,responseBody,errorType,networkError,networkErrorCode,requestUrl,occurrenceTimestamp';
    for (final extraField in extraFields) {
      fields += ',$extraField';
    }
    return fields.split(',');
  }

  String buildQuery({
    required String accountId,
    required String userId,
    required String deviceUuid,
    required String? appBuild,
    int? days = 2,
    int? limit = 100,
    List<String> extraTables = const [],
    List<String> extraFields = const [],
  }) {
    final fields = buildQueryFields(extraFields: extraFields).join(',');

    var tables =
        'MobileRequest,MobileRequestError,MobileBreadcrumb,MobileHandledException,MobileCrash,MobileCustomEvent,MobileNetworkEvent';
    for (final extraTable in extraTables) {
      tables += ',$extraTable';
    }

    var where = '(userId = \'$userId\' or deviceUuid = \'$deviceUuid\') ';

    if (appBuild != null && appBuild.isNotEmpty) {
      where += ' and appBuild = \'$appBuild\' ';
    }

    where +=
        ' and ($kFieldOccurrenceTimestamp is null or ($kFieldOccurrenceTimestamp is not null and dateOf($kFieldOccurrenceTimestamp) = dateOf(timestamp))) ';

    return 'SELECT $fields FROM $tables WHERE $where since $days days ago limit $limit';
  }

  Future<List<GenericEventEntry>> getEventsForUser({
    required String accountId,
    required String nrql,
  }) async {
    final queryBody =
        '''
{
   actor {
      account(id: $accountId) {
         nrql(query: "$nrql" ) {
            results
         }
      }
   }
}''';

    final response = await _apiClient.post(
      _buildBasePath,
      data: {'query': queryBody},
    );

    final errors = response.data['errors'];
    if (errors != null) {
      throw UserException('Error: $errors');
    }

    final results =
        response.data['data']['actor']['account']['nrql']['results'] as List;
    debugPrint('Result count: ${results.length}');
    // ignore: unnecessary_lambdas
    return results.map((e) => GenericEventEntry.fromJson(e)).toList();
  }

  Future<List<GenericEventEntry>> loadEventsFromCsv(
    String csvFilePath,
    List<String> extraFields,
  ) async {
    final input = File(csvFilePath).openRead();
    var results = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter(eol: '\n'))
        .toList();

    final fields = buildQueryFields(extraFields: extraFields);

    results = results.skip(1).toList();

    return results
        .map(
          (row) => {for (int i = 0; i < fields.length; i++) fields[i]: row[i]},
        )
        .map(GenericEventEntry.fromJson)
        .toList();
  }
}
