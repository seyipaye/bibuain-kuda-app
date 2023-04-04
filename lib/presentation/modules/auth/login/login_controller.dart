import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bibuain_pay/core/extentions.dart';
import 'package:bibuain_pay/presentation/utils/constants.dart';

import '../../../../core/app_routes.dart';
import '../../../../domain/repositories/app_repo.dart';
import '../../../../domain/repositories/auth_repo.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final hidePassword = true.obs;

  void hidePasswordPressed() => hidePassword.value = !hidePassword.value;

  // String email = 'seyipaye+22@outlook.com';
  // String password = ' Seyi1234';

  late String username;
  late String password;

  TextEditingController emailText = TextEditingController();
  TextEditingController passText = TextEditingController();

  void onSignupTap() => Get.toNamed(Routes.signup);

  void onForgetPasswordPressed() {
    // This prevents forgeting password as a guest
    // if (AppRepository.userIsGuest)
    //   AuthRepository.instance.userType = UserType.customer;

    Get.toNamed(Routes.resetPassword);
  }

  void onLoginPressed() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();

      showLoadingState;

      await kAnimationDelay;

      AuthRepository.instance.username = username;

      showMessage('Successful', clear: true);
      Get.offAllNamed(Routes.home);
    }
  }
}
