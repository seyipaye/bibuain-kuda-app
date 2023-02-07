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
    // Extract wallet_id and ammount and charge the wallet

    Get.back(result: code);
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

  Future<void> offlinePayment() async {
    final url = await Get.toNamed(Routes.offlineScan);
    if (url != null) {
      final uri = Uri.parse(url as String);

      final wallet_id = uri.pathSegments.last;
      final amount = uri.queryParameters['amount'];

      print('$wallet_id $amount');

      // proccess charge here

      showLoadingState;

      AuthRepository.instance
          .charge(
        id: wallet_id,
        amount: num.parse(amount ?? '0'),
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
