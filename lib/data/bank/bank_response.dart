import 'package:json_annotation/json_annotation.dart';

import 'bank.dart';

part 'bank_response.g.dart';

@JsonSerializable()
class BankResponse {
  bool success;
  String message;

  @JsonKey(name: 'data')
  List<Bank> banks;

  BankResponse(this.success, this.message, this.banks);

  factory BankResponse.fromJson(Map<String, dynamic> json) =>
      _$BankResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BankResponseToJson(this);
}
