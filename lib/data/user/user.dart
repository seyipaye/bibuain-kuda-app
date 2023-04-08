// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:freezed_annotation/freezed_annotation.dart';
//part 'user.freezed.dart';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String? email;
  String? phone;
  String? username;
  String? id;
  // Optional info
  String? password;
  Token? token;
  String? balance;
  User({
    this.email,
    this.phone,
    this.username,
    this.id,
    this.password,
    this.token,
    this.balance,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // For irregular response on signup endpoint
  factory User.fromJsonWithToken(
      Map<String, Object?> user, Map<String, Object?> token) {
    user.putIfAbsent('token', () => token);
    return _$UserFromJson(user);
  }

  /*  String? get sureEmail {
    if (email != null) {
      return email;
    } else if (this.type == UserType.vendor) {
      return this.vendorProfile?.vendors?[0].email;
    }

    return this.customerProfile?.email;
  } */

  User copyWith({
    String? email,
    String? phone,
    String? username,
    String? id,
    String? password,
    Token? token,
    String? balance,
  }) {
    return User(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      username: username ?? this.username,
      id: id ?? this.id,
      password: password ?? this.password,
      token: token ?? this.token,
      balance: balance ?? this.balance,
    );
  }
}

@JsonSerializable()
class Token {
  String access_token;
  String token_type;

  Token(
    this.access_token,
    this.token_type,
  );

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);
}

@JsonSerializable()
class Wallet {
  String id;
  double balance;
  String user_id;
  bool active;
  Wallet({
    required this.id,
    required this.balance,
    required this.user_id,
    required this.active,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
  Map<String, dynamic> toJson() => _$WalletToJson(this);
}
