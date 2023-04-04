import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bibuain_pay/core/extentions.dart';
import 'package:bibuain_pay/presentation/utils/constants.dart';

import '../../../../core/app_routes.dart';
import '../../../../data/bank/bank.dart';
import '../../../../data/user/user.dart';
import '../../../../domain/repositories/auth_repo.dart';
import '../../../widgets/bank_selection/bank_selection_controller.dart';
import '../../../widgets/bank_selection/bank_selection_sheet.dart';

class NewRecipientController extends GetxController {
  Rx<User> get user => AuthRepository.instance.user;
  final formKey = GlobalKey<FormState>();

  final bank = Rx<Bank?>(null);
  String? accountNumber;
  final accountName = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void refresh() => _fetchBalance();

  onBankItemSelected(Bank bank) {
    this.bank.value = bank;
    _fetchAccountName();
  }

  void onAccountNumberChanged(String value) {
    accountNumber = value;
    _fetchAccountName();
  }

  void _fetchAccountName() async {
    if (accountNumber?.length == 10 && bank.value != null) {
      /// set [accountName] to LOADING;
      accountName.value = '';
      FocusManager.instance.primaryFocus?.unfocus();
      showLoadingState;

      AuthRepository.instance
          .fetchAccountName(
              accountNumber: accountNumber, bank: bank.value!.name)
          .then((data) {
        accountName.value = data;
        Get.close(1);
      }).catchError((error) {
        print(error.toString());
        showError(error.toString(), clear: true);
        accountName.value = null;
      });
    } else {
      accountName.value = null;
    }
  }

  void _fetchBalance() {
    AuthRepository.instance.fetchWallet().then((freshWallet) {
      // Success
      // balance.value = freshWallet.balance;
      // wallet.value = freshWallet;
    }).catchError((err, stackTrace) {
      if (err is! String) {
        err = err.toString();
      }
      // Error
      showError(err);
    });
  }

  void onBankPressed() {
    FocusManager.instance.primaryFocus?.unfocus();
    final form = formKey.currentState!;

    if (!form.validate()) {
      showError('Account number is required');
    } else {
      Get.put(BankSelectionController(accountNumber!));
      Get.bottomSheet(
        BankSelectionSheet(
          onItemSelected: onBankItemSelected,
        ),
      );
    }
  }

  void onNextPressed() {
    FocusManager.instance.primaryFocus?.unfocus();
    final form = formKey.currentState!;

    if (bank.value == null) showError('Please select a bank');

    if (!form.validate()) {
    } else if (accountName.value == null || accountName.value!.isEmpty) {
      showError('Account name is required');
    } else {
      form.save();

      Get.toNamed(
        Routes.transferChat,
        arguments: {
          'bank': bank.value,
          'accountName': accountName.value,
        },
      );
    }
  }
}
