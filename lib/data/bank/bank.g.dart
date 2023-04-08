// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bank _$BankFromJson(Map<String, dynamic> json) => Bank(
      json['name'] as String,
      json['code'] as String,
      json['slug'] as String?,
      json['logo'] as String?,
      json['id'] as int?,
    );

Map<String, dynamic> _$BankToJson(Bank instance) => <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'id': instance.id,
      'slug': instance.slug,
      'logo': instance.logo,
    };
