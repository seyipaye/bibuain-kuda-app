import 'dart:async';

import '../../data/user/user.dart';
import 'package:get/get.dart';

import '../app_shared_prefs.dart';
import '../providers/auth_api_provider.dart';

class AuthRepository {
  final user = User().obs;

  AuthRepository() {
    user.value = AppSharedPrefs.instance.user ?? User();

    // Attach listener to store user in DB
    ever<User>(user, (freshUser) {
      // print("New User: ${freshUser.toJson()}");
      AppSharedPrefs.instance.setUser(freshUser);
    });
  }

  static AuthRepository get instance => Get.find<AuthRepository>();

  set userType(UserType userType) {
    user.value = user.value.copyWith(type: userType);
  }

  UserType get userType => user.value.type;

  // static Address? get guestAddress =>
  //     instance.user.value.customerProfile?.address;

  // set email(String email) {
  //   user.value = user.value.copyWith(email: email);
  // }

  // User Data

  // Authentication data

  // Future<String?> uploadImage(String path) =>
  //     AppProvider.value.uploadImage(path);

  // Future<String?> updateRestaurantProfile(String path) =>
  //     AuthProvider.value.updateRestaurantProfile(path);

  // Future<String?> fetchAccountName(
  //         {required accountNumber, required bankCode}) =>
  //     AuthProvider.value
  //         .fetchAccountName(accountNumber: accountNumber, bankCode: bankCode);
  //New Fetch Account Details


  Future<String?> setPassword(
          {required String otp, required String password}) =>
      AuthProvider.value.setPassword(user.value.email!, password, otp);

  Future<String?> resetPassword(
          {required String otp,
          required String email,
          required String newPassword}) =>
      AuthProvider.value.resetPassword(user.value.email!, newPassword, otp);

  Future<String?> changePassword(
          {required String userId,
          required String oldPassword,
          required String newPassword}) =>
      AuthProvider.value.changePassword(userId, oldPassword, newPassword);
/* 
  Future<String?> forgetPassword({String? email}) async {
    final String response;
    if (email?.contains('@foodelo.africa') ?? false) appDebugMode.value = true;

    if (email != null) {
      response = await AuthProvider.value.forgotPassword(email);

      this.email = email;
    } else {
      response = await AuthProvider.value.forgotPassword(user.value.email!);
    }

    return response;
  }
 */
  Future<String?> submitPinOtp(String otp) =>
      AuthProvider.value.submitPinOtp(otp);

  Future<String?> sendPinOtp() => AuthProvider.value.sendPinOtp();

  // Future<String?> resendOtp({String? email}) async {
  //   final String response;

  //   if (email != null) {
  //     response = await AuthProvider.value.resendOtp(email);
  //     this.email = email;
  //   } else {
  //     response = await AuthProvider.value.resendOtp(user.value.email!);
  //   }
  //   return response;
  // }

/* 
  Future<String?> login(String email, password) async {
    if (email.contains('@foodelo.africa')) {
      appDebugMode.value = true;
    }
    final User response = await AuthProvider.value.login(email, password);

    user.value = response.copyWith(password: password);

    User userr = response.copyWith(password: password);
    //user.value.copyWith() = userr;

    await fetchProfile();

    return Future.value('Success');
  }
 */

/*   Future<String?> signup({name, email, phone, password, referrer}) async {
    if (email.contains('@foodelo.africa')) {
      appDebugMode.value = true;
    }
    final User response = await AuthProvider.value.signup(
      email: email,
      password: password,
      phone: phone,
      name: name,
      referrer: referrer,
      type: user.value.type,
    );
    user.value = response.copyWith(password: password);

    // Don't fetch profile here
    return Future.value('Success');
  }
 */

  // Future<String?> verifyEmail(String otp, String email) {
  //   return AuthProvider.value.verifyEmail(otp: otp, email: email).then(
  //     (value) async {
  //       await login(user.value.email!, user.value.password);

  //       return value;
  //     },
  //   );
  // }

  // Future<String?> sendMailOtp() =>
  //     AuthProvider.value.sendMailOtp(user.value.email!);

  // Future<String?> updateRestaurantDetails({
  //   required String name,
  //   required Address address,
  //   required String avatar,
  //   required String restuarant,
  //   required String coverPhoto,
  //   required String description,
  //   required String openingTime,
  //   required String closingTime,
  // }) {
  //   return AuthProvider.value
  //       .updateRestaurantDetails(
  //           name: name,
  //           address: address,
  //           avatar: avatar,
  //           restuarant: restuarant,
  //           coverPhoto: coverPhoto,
  //           description: description,
  //           openingTime: openingTime,
  //           closingTime: closingTime)
  //       .then((response) {
  //     // TODO: Refetch user if nessecary
  //     //user.value = User.fromJson(response.data!);
  //     return response.message;
  //   });
  // }

  // New upload restaurant profile (working)
/*   Future<String?> updateDetails(
      {required Address address,
      required String restuarantName,
      required String coverPhoto,
      required String description,
      String? regNum,
      required OperatingHours operatingHours,
      String? vendorId}) async {
    // Upload Image
    coverPhoto = await uploadImage(coverPhoto) ?? '';

    return AuthProvider.value
        .updateDetails(
            address: address,
            restuarantName: restuarantName,
            coverPhoto: coverPhoto,
            description: description,
            regNum: regNum,
            operatingHours: operatingHours,
            vendorId: vendorId)
        .then((response) {
      // TODO: Refetch user if nessecary
      //user.value = User.fromJson(response.data!);
      return response.message;
    });
  } */
}
