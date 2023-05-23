import 'dart:async';

import '../../data/bank/bank.dart';
import '../../data/user/user.dart';
import 'package:get/get.dart';

import '../../main.dart';
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

  set username(String username) {
    user.value = user.value.copyWith(username: username);
  }

  // UserType get userType => user.value.type;

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

  Future<List<Bank>> fetchBanks(String name) =>
      AuthProvider.value.fetchLogoBanks(name);

  Future<String?> fetchAccountName({required accountNumber, required bank}) =>
      AuthProvider.value
          .fetchAccountName(accountNumber: accountNumber, bank: bank);

  Future<String?> makePayment({
    required String number,
    required String bank,
    required String account_name,
    required String amount,
    required String narration,
  }) async {
    final result = await AuthProvider.value.makePayment(
      number: number,
      bank: bank,
      account_name: account_name,
      amount: amount,
      narration: narration,
    );

    user.value = user.value.copyWith(balance: result);

    return result;
  }

  Future<String?> setPassword(
          {required String otp, required String password}) =>
      AuthProvider.value.setPassword(user.value.email!, password, otp);

  Future<String?> resetPassword(
          {required String otp,
          required String email,
          required String newPassword}) =>
      AuthProvider.value.resetPassword(user.value.email!, newPassword, otp);

  Future<String?> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) =>
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

  Future<String?> login({email, password}) async {
    if (email.contains('@foodelo.africa')) {
      appDebugMode.value = true;
    }

    final User response = await AuthProvider.value.login(
      email: email,
      password: password,
    );

    user.value = response;

    return Future.value('Success');
  }

  Future<String?> signup({email, password, username}) async {
    if (email.contains('@foodelo.africa')) {
      appDebugMode.value = true;
    }

    final User response = await AuthProvider.value.signup(
      email: email,
      password: password,
      username: username,
    );

    user.value = response;

    return Future.value('Success');
  }

  Future<String> fetchBalance() async {
    final balance = await AuthProvider.value.fetchBalance();
    user.value = user.value.copyWith(balance: balance);
    return balance;
  }

  Future<dynamic> uploadToken(String token) async {
    return AuthProvider.value.uploadToken(token);
  }

  Future<String?> payMoney({required String id, required num amount}) async {
    final result = await AuthProvider.value.payMoney(id: id, amount: amount);
    await fetchBalance();
    return result;
  }

  Future<String?> charge({required String id, required num amount}) async {
    final result = await AuthProvider.value.charge(id: id, amount: amount);
    await fetchBalance();
    return result;
  }

  Future<String?> topUp({required num amount}) async {
    final result = await AuthProvider.value.topUp(amount: amount);
    await fetchBalance();
    return result;
  }

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
