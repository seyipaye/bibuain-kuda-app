// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankAccount _$BankAccountFromJson(Map<String, dynamic> json) => BankAccount(
      json['accountName'] as String,
      json['accountNumber'] as String,
      json['bankName'] as String,
      vendorId: json['vendorId'] as String?,
      bankCode: json['bankCode'] as String?,
    );

Map<String, dynamic> _$BankAccountToJson(BankAccount instance) {
  final val = <String, dynamic>{
    'accountName': instance.accountName,
    'accountNumber': instance.accountNumber,
    'bankName': instance.bankName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('vendorId', instance.vendorId);
  writeNotNull('bankCode', instance.bankCode);
  return val;
}
