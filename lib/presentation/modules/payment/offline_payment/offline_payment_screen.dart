import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'offline_payment_controller.dart.dart';

class OfflinePaymentScreen extends GetView<OfflinePaymentController> {
  OfflinePaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Payment'),
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
              onPressed: controller.generateCode,
              child: Text('Generate code'),
            )
          ],
        ),
      ),
    );
  }
}
