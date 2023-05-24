import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bibuain_pay/core/extentions.dart';

import '../../../../core/app_routes.dart';
import '../../../../data/user/user.dart';
import '../../../../domain/repositories/auth_repo.dart';

class PaymentController extends GetxController {
  final formKey = GlobalKey<FormState>();

  Rx<User> get user => AuthRepository.instance.user;
  final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'en_NG', decimalDigits: 0, symbol: '₦');
  late String wallet_id;

  @override
  void onInit() {
    // _fetchBalance();
    super.onInit();
    // wallet_id = Get.arguments;
  }

  void sendMoney() {
    final amount = formatter.getUnformattedValue();

    FocusManager.instance.primaryFocus?.unfocus();

    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();

      showLoadingState;

      AuthRepository.instance
          .payMoney(
        id: wallet_id,
        amount: amount,
      )
          .then((msg) {
        // Success, Go Back back
        showMessage(msg, clear: true);
        Get.until((route) => Get.currentRoute == Routes.home);
      }).catchError((err, stackTrace) {
        if (err is! String) {
          err = err.toString();
        }
        // Error
        showError(err, clear: true);
      });
    }
  }
}
