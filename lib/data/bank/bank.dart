import 'package:json_annotation/json_annotation.dart';

part 'bank.g.dart';

@JsonSerializable()
class Bank {
  final String name;
  final String code;
  final int? id;
  final String? slug;
  final String? logo;

  const Bank(this.name, this.code, this.slug, this.logo, this.id);

  factory Bank.fromJson(Map<String, dynamic> json) => _$BankFromJson(json);
  Map<String, dynamic> toJson() => _$BankToJson(this);
}
