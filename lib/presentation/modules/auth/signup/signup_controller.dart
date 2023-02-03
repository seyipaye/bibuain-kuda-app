/* import 'package:flutter/material.dart';
import '../core/app_routes.dart';
import '../core/extentions.dart';
import '../data/user/user.dart';
import '../domain/repositories/app_repo.dart';
import '../domain/repositories/auth_repo.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final agreedToTerms = false.obs;

  final hidePassword = true.obs;
  void hidePasswordPressed() => hidePassword.value = !hidePassword.value;

  late String name;
  late String email;
  late String branchEmail;
  late String phone;
  // late String referrerCode;
  late String password;
  String? userName;
  late String referrerCode;

  void onCheckboxChanged(bool? value) {
    agreedToTerms.value = value!;
  }

  Future<void> onContinuePressed() async {
    AuthRepository.instance.userType = UserType.guest;
    final successful = await Get.toNamed(Routes.newAddress);

    if (successful) Get.toNamed(Routes.home);
  }

  void createAccount() {
    FocusManager.instance.primaryFocus?.unfocus();

    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();

      if (agreedToTerms.isFalse) {
        showError('Please read and accept the terms & condition');
        return;
      }

      showLoadingState;

      // This prevents signing up as a guest
      if (AppRepository.userIsGuest)
        AuthRepository.instance.userType = UserType.customer;

      if (AppRepository.userIsCustomer) {
        AuthRepository.instance
            .signup(
                email: email,
                password: password,
                phone: phone,
                name: name,
                referrer: referrerCode
                // username: userName,
                // invitecode: inviteCode
                )
            .then((msg) {
          // Success
          Get.back();
          showMessage(msg);
          Get.toNamed(Routes.otp);
        }).catchError((err, stackTrace) {
          if (err is! String) {
            err = err.toString();
          }
          // Error
          Get.back();
          showError(err);
        });
      } else {
        if (branchEmail.isEmpty) {
          branchEmail = email;
        }
        AuthRepository.instance
            .vendorSignUp(
                email: email,
                password: password,
                phone: phone,
                name: name,
                referrer: referrerCode,
                branchEmail: branchEmail
                // username: userName,
                // invitecode: inviteCode
                )
            .then((msg) {
          // Success
          Get.back();
          showMessage(msg);
          Get.toNamed(Routes.otp);
        }).catchError((err, stackTrace) {
          /*if(err.toString().contains('Email is yet to be verified')){
            Get.back();
            Get.toNamed(Routes.otp);
            return;
          }*/

          if (err is! String) {
            err = err.toString();
          }
          // Error
          Get.back();
          showError(err);
        });
      }
    }
  }
}
 */