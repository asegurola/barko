// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_error_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DioErrorMessage _$DioErrorMessageFromJson(Map<String, dynamic> json) =>
    DioErrorMessage(
      showMessage: json['showMessage'] as bool? ?? false,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$DioErrorMessageToJson(DioErrorMessage instance) =>
    <String, dynamic>{
      'showMessage': instance.showMessage,
      'message': instance.message,
    };
