import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:bibuain_pay/core/extentions.dart';

import '../../../../core/app_routes.dart';
import '../../../../data/user/user.dart';
import '../../../../domain/repositories/auth_repo.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../widgets/app_text_form_field.dart';

class StatementController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final range = Rxn<String>();

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

  void onRangePressed() {
    Get.bottomSheet(
      RangeSelectionSheet(
        onItemSelected: (range) {
          this.range.value = range;
        },
      ),
    );
  }

  void getStatement() {
    Get.toNamed(Routes.transactions, arguments: range.value);
  }
}

class RangeSelectionSheet extends GetView<StatementController> {
  final Function(String range) onItemSelected;

  RangeSelectionSheet({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
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
                          'Range',
                          style: Get.theme.appBarTheme.titleTextStyle,
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
            // Body
            _buildList(),
          ],
        ),
      ),
    );
  }

  ListView _buildList() {
    final values = ['5', '10', 'All'];

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(0, 24, 0, 10),
      itemCount: values.length,
      itemBuilder: (context, index) {
        final value = values[index];

        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 25),
          title: Text(value),
          onTap: () async {
            await kAnimationDelay;

            Get.close(1);

            onItemSelected(value);
          },
        );
      },
    );
  }
}
