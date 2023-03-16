import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinController extends GetxController {
  final pinController = TextEditingController();
  final pin = ''.obs;
  bool isFresh = true;

  @override
  void onInit() {
    super.onInit();

    print('Listen');

    pinController.addListener(() {
      pin.value = pinController.text;
      if (pinController.text.length >= 4 && isFresh) {
        pinController.clear();
        Get.back(result: pinController.text);
      }
    });
  }
}
