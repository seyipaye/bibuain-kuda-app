import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:bibuain_pay/core/extentions.dart';

import '../../../data/bank/bank.dart';
import '../../../domain/repositories/auth_repo.dart';

class BankSelectionController extends GetxController {
  final isLoading = true.obs;
  final banks = Rx<List<Bank>?>(null);

  // Controls the text label we use as a search bar
  final TextEditingController filter = TextEditingController();
  final searchText = ''.obs;
  final filteredBanks = Rx<List<Bank>>([]);

  @override
  void onInit() {
    super.onInit();
    _fetchData();
  }

  @override
  void onReady() {
    super.onReady();
    filter.addListener(() {
      searchText.value = filter.text;
      print(filter.text);
      if (filter.text.isEmpty) {
        filteredBanks.value = banks.value!;
      } else {
        filteredBanks.value = banks.value!
            .where((element) =>
                element.name.toLowerCase().trim().contains(
                      searchText.value.toLowerCase(),
                    ) ||
                (element.slug ?? '').toLowerCase().contains(
                      searchText.value.toLowerCase(),
                    ))
            .toList(growable: false);
      }
    });
  }

  void _fetchData() {
    AuthRepository.instance.fetchBanks().then((data) {
      // Important filtering. Not all items have bank codes e.g Abbey Mortage Bank
      data.removeWhere((element) => element.code == '');
      banks.value = data;
      filteredBanks.value = banks.value!;
      isLoading.value = false;
    }).catchError((error) {
      print(error.toString());
      Get.back();
      showError(error.toString());
    });
  }
}
