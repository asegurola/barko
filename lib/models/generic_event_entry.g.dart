// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_event_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericEventEntry _$GenericEventEntryFromJson(Map<String, dynamic> json) =>
    GenericEventEntry(
      timestamp: DateTime.parse(json['timestamp'] as String),
      appName: json['appName'] as String,
      appVersion: json['appVersion'] as String,
      appBuild: json['appBuild'] as String,
      userId: json['userId'] as String?,
      deviceUuid: json['deviceUuid'] as String?,
      fields:
          json['fields'] as Map<String, dynamic>? ?? const <String, dynamic>{},
    );

Map<String, dynamic> _$GenericEventEntryToJson(GenericEventEntry instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'appName': instance.appName,
      'userId': instance.userId,
      'deviceUuid': instance.deviceUuid,
      'appVersion': instance.appVersion,
      'appBuild': instance.appBuild,
      'fields': instance.fields,
    };
