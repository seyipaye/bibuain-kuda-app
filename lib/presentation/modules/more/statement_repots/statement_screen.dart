import 'package:bibuain_pay/core/extentions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:bibuain_pay/presentation/utils/colors.dart';
import 'package:bibuain_pay/presentation/utils/constants.dart';
import '../../../widgets/app_text_form_field.dart';
import 'statement_controller.dart';

class StatementScreen extends GetView<StatementController> {
  StatementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('NGN Statement'),
            Gap(5),
            Image.asset(
              'assets/images/nigeria-flag.jpeg',
              width: 20,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose how many transactions you \nwant to show in it'),
            Gap(10),
            Obx(
              () => AppTextFormField2(
                key: Key(controller.range.value ?? 'key'),
                label: 'Range',
                hintText: 'Select a Range',
                initialValue: controller.range.value,
                readOnly: true,
                suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
                onTap: controller.onRangePressed,
              ),
            ),
            Expanded(child: SizedBox()),
            GetX<StatementController>(
              initState: (_) {},
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: kDefaultPadding),
                  child: ElevatedButton(
                    child: Text('Get'),
                    onPressed: controller.range.value == null
                        ? null
                        : controller.getStatement,
                  ).center,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
