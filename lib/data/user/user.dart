import 'package:freezed_annotation/freezed_annotation.dart';

//part 'user.freezed.dart';
// part 'user.g.dart';

enum UserType { customer, vendor, guest }

@JsonSerializable()
class User {
  @JsonKey(name: 'userType')
  UserType type;
  // Neccesary info
  String? email;
  String? phone;
  String? token;
  String? customerId;
  String? vendorId;
  // For inconsistences in responses
  @JsonKey(name: '_id')
  String? userId;
  String? deviceToken;
  String? accountStatus;
  String? refreshToken;
  // Optional info
  String? password;
  // Profile info
  // CustomerProfile? customerProfile;
  // VendorProfile? vendorProfile;
  // UnverifiedVendorProfile? unverifiedVendorProfile;

  User(
      {this.type = UserType.customer,
      this.email,
      this.phone,
      this.password,
      this.token,
      this.customerId,
      this.vendorId,
      this.deviceToken,
      this.refreshToken,
      // this.customerProfile,
      // this.vendorProfile,
      // this.unverifiedVendorProfile,
      this.userId,
      this.accountStatus});

  // factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  // Map<String, dynamic> toJson() => _$UserToJson(this);

  // // For irregular response on signup endpoint
  // factory User.fromJsonWithType(Map<String, Object?> json,
  //     {required UserType type}) {
  //   json.putIfAbsent("userType", () => type.name);
  //   return _$UserFromJson(json);
  // }

  String? get id {
    if (userId != null) {
      return userId;
    } else if (this.type == UserType.vendor) {
      return this.vendorId;
    }

    return 'this.customerId';
  }

  // String? get sureEmail {
  //   if (email != null) {
  //     return email;
  //   } else if (this.type == UserType.vendor) {
  //     return this.vendorProfile?.vendors?[0].email;
  //   }

  //   return this.customerProfile?.email;
  // }

  User copyWith({
    UserType? type,
    String? email,
    String? phone,
    String? token,
    String? customerId,
    String? vendorId,
    String? userId,
    String? deviceToken,
    String? refreshToken,
    String? password,
    String? accountStatus,
    // CustomerProfile? customerProfile,
    // VendorProfile? vendorProfile,
    // UnverifiedVendorProfile? unverifiedVendorProfile,
  }) {
    return User(
      type: type ?? this.type,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      token: token ?? this.token,
      customerId: customerId ?? this.customerId,
      vendorId: vendorId ?? this.vendorId,
      userId: userId ?? this.userId,
      deviceToken: deviceToken ?? this.deviceToken,
      refreshToken: refreshToken ?? this.refreshToken,
      accountStatus: accountStatus ?? this.accountStatus,
      password: password ?? this.password,
      // customerProfile: customerProfile ?? this.customerProfile,
      // vendorProfile: vendorProfile ?? this.vendorProfile,
      // unverifiedVendorProfile:
      //     unverifiedVendorProfile ?? this.unverifiedVendorProfile,
    );
  }
}

/* @freezed
class User with _$User {
  const User._();
  const factory User(
    @JsonKey(name: 'userType') UserType type, {
    //String? id,
    String? name,
    String? email,
    String? phone,
    String? password,
    String? photo,
    String? token,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);

  // for shared prefs
  factory User.fromJsonWithType(Map<String, Object?> json,
      {required UserType type}) {
    json.putIfAbsent("userType", () => type.name);
    return _$UserFromJson(json);
  }

  String? get id {
    if (this.type == UserType.vendor) {
      return this.vendorId;
    } else {
      return this.customerId;
    }
  }
}
 */
