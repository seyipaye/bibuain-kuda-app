// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse _$ApiResponseFromJson(Map<String, dynamic> json) => ApiResponse(
      json['error'] as bool?,
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'],
      statusCode: json['statusCode'] as int?,
    );

Map<String, dynamic> _$ApiResponseToJson(ApiResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('success', instance.success);
  writeNotNull('error', instance.error);
  writeNotNull('message', instance.message);
  writeNotNull('data', instance.data);
  writeNotNull('statusCode', instance.statusCode);
  return val;
}
