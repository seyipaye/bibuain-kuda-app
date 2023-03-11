import 'package:json_annotation/json_annotation.dart';

part 'bank_account.g.dart';

@JsonSerializable()
class BankAccount {
  String accountName;
  String accountNumber;
  String bankName;
  String? vendorId;
  String? bankCode;

  BankAccount(this.accountName, this.accountNumber, this.bankName,
      {this.vendorId, this.bankCode});

  factory BankAccount.fromJson(Map<String, dynamic> json) =>
      _$BankAccountFromJson(json);

  Map<String, dynamic> toJson() => _$BankAccountToJson(this);
}
