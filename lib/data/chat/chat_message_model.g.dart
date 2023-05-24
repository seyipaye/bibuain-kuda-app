// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      amount: (json['amount'] as num).toDouble(),
      recipientName: json['recipientName'] as String,
      senderName: json['senderName'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      bank: Bank.fromJson(json['bank'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'recipientName': instance.recipientName,
      'senderName': instance.senderName,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'bank': instance.bank,
    };

Statement _$StatementFromJson(Map<String, dynamic> json) => Statement(
      amount_paid: json['amount_paid'] as String,
      amount_received: json['amount_received'] as String,
      balance: json['balance'] as String,
      date: json['date'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$StatementToJson(Statement instance) => <String, dynamic>{
      'amount_paid': instance.amount_paid,
      'amount_received': instance.amount_received,
      'balance': instance.balance,
      'date': instance.date,
      'description': instance.description,
    };
