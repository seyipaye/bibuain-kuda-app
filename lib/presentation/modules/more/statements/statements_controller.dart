import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bibuain_pay/core/extentions.dart';

import '../../../../core/app_routes.dart';
import '../../../../data/chat/chat_message_model.dart';
import '../../../../domain/repositories/auth_repo.dart';

class StatementsController extends GetxController {
  final formKey = GlobalKey<FormState>();
  late String range;
  final statements = Rxn<Statements>();

  @override
  void onInit() {
    super.onInit();
    range = Get.arguments;
    _fetchTransactions();
  }

  void _fetchTransactions() {
    AuthRepository.instance
        .fetchTransactions(
      range: range,
    )
        .then((statements) {
      // Success,
      this.statements.value = statements;
    }).catchError((err, stackTrace) {
      if (err is! String) {
        err = err.toString();
      }
      // Error
      showError(err);
    });
  }
}
