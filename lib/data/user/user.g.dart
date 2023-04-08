// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      username: json['username'] as String?,
      id: json['id'] as String?,
      password: json['password'] as String?,
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      balance: json['balance'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'username': instance.username,
      'id': instance.id,
      'password': instance.password,
      'transactions': instance.transactions,
      'balance': instance.balance,
    };

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
      json['access_token'] as String,
      json['token_type'] as String,
    );

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'access_token': instance.access_token,
      'token_type': instance.token_type,
    };

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
      id: json['id'] as String,
      balance: (json['balance'] as num).toDouble(),
      user_id: json['user_id'] as String,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      'id': instance.id,
      'balance': instance.balance,
      'user_id': instance.user_id,
      'active': instance.active,
    };
