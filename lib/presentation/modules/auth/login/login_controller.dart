/* import 'package:flutter/material.dart';
import '../core/app_routes.dart';
import '../core/extentions.dart';
import '../data/user/user.dart';
import '../domain/repositories/app_repo.dart';
import '../domain/repositories/auth_repo.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final hidePassword = true.obs;

  void hidePasswordPressed() => hidePassword.value = !hidePassword.value;

  // String email = 'seyipaye+22@outlook.com';
  // String password = ' Seyi1234';

  String email = 'olaifaolawale43@yahoo.com';
  String password = 'wahlly';

  TextEditingController emailText = TextEditingController();
  TextEditingController passText = TextEditingController();

  void onSignupTap() => Get.toNamed(Routes.signup);

  void onForgetPasswordPressed() {
    // This prevents forgeting password as a guest
    if (AppRepository.userIsGuest)
      AuthRepository.instance.userType = UserType.customer;

    Get.toNamed(Routes.resetPassword);
  }

  void onLoginPressed() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();

      showLoadingState;
      // This prevents logging in as a guest
      if (AppRepository.userIsGuest)
        AuthRepository.instance.userType = UserType.customer;
      try {
        final resp = await AuthRepository.instance.login(email, password);

        if (resp != null) {
          Get.back();
          showMessage(resp);

          if (AuthRepository.instance.user.value.type == UserType.customer) {
            Get.offAllNamed(Routes.home);
          } else {
            Get.offAllNamed(Routes.dashboard);
          }
        }
      } catch (err) {
        Get.closeAllSnackbars();
        Get.back();
        if (err.toString().contains('Email is yet to be verified')) {
          Get.toNamed(Routes.otp, arguments: [email]);
        } else {
          // Error

          if (err is String) showError(err.toString());
        }
      }
    }

    /*AuthRepository.instance.login(email, password).then((msg) {
        // Success
        Get.back();
        showMessage(msg);

        if (AuthRepository.instance.user.value.type == UserType.customer) {
          Get.offAllNamed(Routes.home);
        } else {
          Get.offAllNamed(Routes.dashboard);
        }
      }).catchError((err, stackTrace) {
        Get.back();

        if(err.toString().contains('Email is yet to be verified')){

          Get.toNamed(Routes.otp, arguments: [email]);
          return;
        }
        // Error

        if(err is String)
        showError(err.toString());
      });
    }*/
  }
}
 */