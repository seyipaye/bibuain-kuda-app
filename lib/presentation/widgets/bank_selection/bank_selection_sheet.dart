import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../../../data/bank/bank.dart';
import '../../modules/home/home_page.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../../utils/values.dart';
import '../app_text_form_field.dart';
import 'bank_selection_controller.dart';

class BankSelectionSheet extends GetView<BankSelectionController> {
  final Function(Bank bank) onItemSelected;

  BankSelectionSheet({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<BankSelectionController>(
      builder: (_) => Container(
        color: Colors.white,
        child: _.isLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: kDefaultPadding, left: 8, right: 8, bottom: 8),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.close,
                            size: 28,
                            color: AppColors.primary,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Choose Bank',
                                style: Get.theme.appBarTheme.titleTextStyle,
                              ),
                              Gap(5),
                              Image.asset(
                                'assets/images/nigeria-flag.jpeg',
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 28,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      kDefaultPadding,
                      0,
                      kDefaultPadding,
                      0,
                    ),
                    child: AppTextFormField(
                      textEditingController: controller.filter,
                      decoration: InputDecoration(
                        hintText: 'Search for a bank',
                        fillColor: AppColors.input_bg,
                        filled: true,
                        prefixIcon: GetX<BankSelectionController>(
                          builder: (_) {
                            return _.searchText.value.isEmpty
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 12, 0),
                                    child: Icon(Icons.search),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      _.filter.clear();
                                    },
                                    icon: Icon(Icons.close));
                          },
                        ),
                        focusedBorder: kGetInputBorder(AppColors.input_bg),
                        enabledBorder: kGetInputBorder(AppColors.input_bg),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      child: GetX<BankSelectionController>(
                          builder: (_) => _buildList(_.filteredBanks.value)),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  ListView _buildList(List<Bank> banks) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 10),
      itemCount: banks.length,
      itemBuilder: (context, index) {
        final bank = banks[index];

        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 25),
          title: Text(bank.name),
          leading: BankLogo(
            bank: bank,
            improve: true,
          ),
          onTap: () async {
            await kAnimationDelay;

            Get.close(1);

            onItemSelected(bank);
          },
        );
      },
    );
  }
}
