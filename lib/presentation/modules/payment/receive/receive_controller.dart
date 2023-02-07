import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:swift_pay_mobile/core/extentions.dart';

import '../../../../core/app_routes.dart';
import '../../../../data/user/user.dart';
import '../../../../domain/repositories/auth_repo.dart';

class ReceiveController extends GetxController {
  final balance = 0.0.obs;
  final wallet = Rxn<Wallet>();
  Rx<User> get user => AuthRepository.instance.user;

  @override
  void onInit() {
    _fetchBalance();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void refresh() => _fetchBalance();

  void onDetect(barcode, args) {
    if (barcode.rawValue == null) {
      debugPrint('Failed to scan Barcode');
      showError('Failed to scan Barcode');
    } else {
      final String code = barcode.rawValue!;

      debugPrint('Barcode found! $code');
      _validateCode(code);
    }
  }

  void _validateCode(String code) {
    // Validate the QRcode lenght and pattern
    // Fetch account details for code
    // username or merchant name
    // avater

    // for now just send the code to the next screen
    Get.toNamed(Routes.makePayment, arguments: code);
  }

  void _fetchBalance() {
    AuthRepository.instance.fetchWallet().then((freshWallet) {
      // Success
      balance.value = freshWallet.balance;
      wallet.value = freshWallet;
    }).catchError((err, stackTrace) {
      if (err is! String) {
        err = err.toString();
      }
      // Error
      showError(err);
    });
  }

  void offlinePayment() => Get.toNamed(Routes.offlineScan);
}
