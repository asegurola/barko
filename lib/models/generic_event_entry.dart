import 'package:json_annotation/json_annotation.dart';

import '../utils/constants.dart';

part 'generic_event_entry.g.dart';

enum EntryType {
  request,
  requestError,
  handledException,
  breadcrumb,
  crash,
  customEvent,
  networkEvent,
  other,
}

extension EntryTypeDisplayName on EntryType {
  String get displayName {
    switch (this) {
      case EntryType.request:
        return 'Request';
      case EntryType.requestError:
        return 'Request error';
      case EntryType.handledException:
        return 'Handled exception';
      case EntryType.breadcrumb:
        return 'Breadcrumb';
      case EntryType.crash:
        return 'Crash';
      case EntryType.customEvent:
        return 'Custom event';
      case EntryType.networkEvent:
        return 'Network event';
      case EntryType.other:
        return 'Other';
    }
  }
}

DateTime _parseDateTime(dynamic timestamp) {
  if (timestamp is int) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  } else if (timestamp is String) {
    return DateTime.parse(timestamp);
  } else {
    throw UnimplementedError('Unknown datetime value $timestamp');
  }
}

@JsonSerializable()
class GenericEventEntry {
  DateTime timestamp;

  String appName;

  String? userId;

  String? deviceUuid;

  String appVersion;

  String appBuild;

  @JsonKey()
  Map<String, dynamic> fields;

  GenericEventEntry({
    required this.timestamp,
    required this.appName,
    required this.appVersion,
    required this.appBuild,
    required this.userId,
    required this.deviceUuid,
    this.fields = const <String, dynamic>{},
  });

  factory GenericEventEntry.fromJson(Map<String, dynamic> json) {
    _cleanOcurranceTimestamp(json);
    _cleanFlutterStackTrace(json);

    return GenericEventEntry(
      timestamp: _parseDateTime(json['timestamp']),
      appName: json['appName'],
      userId: json['userId'],
      deviceUuid: json['deviceUuid'],
      appVersion: json['appVersion'],
      appBuild: json['appBuild'].toString(),
      fields: json,
    );
  }

  Map<String, dynamic> toJson() => _$GenericEventEntryToJson(this);

  EntryType get entryType {
    if (_has('category', 'Custom')) {
      return EntryType.customEvent;
    } else if (_has('category', 'NetworkRequest')) {
      return EntryType.request;
    } else if (_has('category', 'RequestError')) {
      return EntryType.requestError;
    } else if (_has('category', 'Breadcrumb')) {
      return EntryType.breadcrumb;
    }

    if (_containsAndNotNull('requestUrl')) {
      if (_containsAndNotNull('errorType')) {
        return EntryType.requestError;
      } else {
        return EntryType.request;
      }
    } else if (_containsAndNotNull('exceptionMessage') ||
        _containsAndNotNull('flutterStackTrace')) {
      return EntryType.handledException;
    } else if (_containsAndNotNull('crashMessage')) {
      return EntryType.crash;
    } else if (_containsAndNotNull('eventName')) {
      return EntryType.customEvent;
    } else if (_containsAndNotNull('errorMessage') &&
        _has('name', 'UnknownNetworkError')) {
      return EntryType.networkEvent;
    } else if (_containsAndNotNull('name')) {
      return EntryType.breadcrumb;
    } else {
      return EntryType.other;
    }
  }

  bool _containsAndNotNull(String key) {
    final value = fields[key];
    return value != null && value is String && value.isNotEmpty;
  }

  bool _has(String key, String expectedValue) {
    final value = fields[key];
    return value != null && value is String && value == expectedValue;
  }

  List<String> get fieldsForType {
    switch (entryType) {
      case EntryType.request:
        return ['statusCode', 'requestMethod', 'requestUrl', 'responseTime'];
      case EntryType.requestError:
        return [
          'statusCode',
          'requestMethod',
          'requestUrl',
          'responseTime',
          'errorType',
          'networkError',
          'responseBody',
        ];
      case EntryType.handledException:
        return [
          'exceptionMessage',
          'occurrenceTimestamp',
          'stackTrace',
          kFieldFlutterStackTrace,
        ];
      case EntryType.crash:
        return [
          'crashMessage',
          'crashLocation',
          kFieldOccurrenceTimestamp,
          'stackTrace',
          kFieldFlutterStackTrace,
        ];
      case EntryType.breadcrumb:
        return ['name'];
      case EntryType.customEvent:
        return [
          'name',
          'eventName',
          'productName',
          'itemName',
          'items',
          'storeId',
          'categoryName',
          'preparationType',
          'searchTerm',
          'screenName',
          'isVisitor',
        ];
      case EntryType.other:
        return fields.keys.toList();
      case EntryType.networkEvent:
        return ['errorMessage'];
    }
  }

  static void _cleanOcurranceTimestamp(Map<String, dynamic> json) {
    final occurrenceTimestamp = json[kFieldOccurrenceTimestamp];

    if (occurrenceTimestamp != null) {
      int? occurrenceTimestampIntValue;
      if (occurrenceTimestamp is double) {
        occurrenceTimestampIntValue = occurrenceTimestamp.toInt();
      } else if (occurrenceTimestamp is int) {
        occurrenceTimestampIntValue = occurrenceTimestamp;
      }

      if (occurrenceTimestampIntValue != null) {
        json[kFieldOccurrenceTimestamp] = DateTime.fromMillisecondsSinceEpoch(
          occurrenceTimestampIntValue,
        );
      }
    }
  }

  static void _cleanFlutterStackTrace(Map<String, dynamic> json) {
    json[kFieldFlutterStackTrace] = json[kFieldFlutterStackTrace]?.replaceAll(
      '\\n',
      '\n',
    );
  }
}
