// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankResponse _$BankResponseFromJson(Map<String, dynamic> json) => BankResponse(
      json['success'] as bool,
      json['message'] as String,
      (json['data'] as List<dynamic>)
          .map((e) => Bank.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BankResponseToJson(BankResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.banks,
    };
