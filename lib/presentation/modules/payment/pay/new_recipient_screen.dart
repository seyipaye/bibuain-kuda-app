import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:bibuain_pay/presentation/modules/home/home_page.dart';
import 'package:bibuain_pay/presentation/modules/payment/pay/scan_controller.dart';
import 'package:bibuain_pay/presentation/widgets/column_pro.dart';

import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/validators.dart';
import '../../../utils/values.dart';
import '../../../widgets/app_text_form_field.dart';
import '../../../widgets/bank_selection/bank_selection_controller.dart';
import '../../../widgets/bank_selection/bank_selection_sheet.dart';

class NewRecipientScreen extends GetView<NewRecipientController> {
  NewRecipientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('New NGN Recipient'),
            Gap(5),
            Image.asset(
              'assets/images/nigeria-flag.jpeg',
              width: 20,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: FlexibleScrollViewColumn(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  // alignment: Alignment.center,
                  padding: EdgeInsets.all(AppPadding.p24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextFormField2(
                        label: 'Account Number',
                        hintText: 'Enter Account Number',
                        textInputType: TextInputType.number,
                        maxLength: 10,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: Validator.isAccountNumber,
                        onChanged: controller.onAccountNumberChanged,
                      ),
                      spacer(),
                      Obx(
                        () => AppTextFormField2(
                          key: Key(controller.bank.value?.name ?? 'key'),
                          label: 'Bank',
                          hintText: 'Select Bank',
                          initialValue: controller.bank.value?.name,
                          readOnly: true,
                          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
                          prefixIcon: controller.bank.value == null
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: BankLogo(bank: controller.bank.value!),
                                ),
                          onTap: controller.onBankPressed,
                        ),
                      ),
                      Obx(() {
                        final accountName = controller.accountName.value;
                        return accountName != null && accountName != ''
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: AppColors.green,
                                  ),
                                  Gap(10),
                                  Text(
                                    accountName,
                                    style: TextStyle(
                                        color: AppColors.green,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            : SizedBox.shrink();
                      }),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: ElevatedButton(
                  child: Text('Next'),
                  onPressed:
                      controller.onNextPressed, //controller.onLoginPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
