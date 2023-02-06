import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:swift_pay_mobile/presentation/utils/colors.dart';
import '../../../widgets/column_pro.dart';
import 'payment_controller.dart';

class PaymentScreen extends GetView<PaymentController> {
  PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Payment'),
      ),
      body: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Gap(50),
            Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text('Enter Amount'),
                  Gap(10),
                  TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: GoogleFonts.getFont(
                      'Roboto',
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                    initialValue: controller.formatter.format('0'),
                    inputFormatters: <TextInputFormatter>[controller.formatter],
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            Gap(20),
            ElevatedButton(
                onPressed: controller.sendMoney, child: Text('Send Money'))
          ],
        ),
      ),
    );
  }
}
