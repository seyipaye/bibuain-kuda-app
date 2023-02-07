import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:swift_pay_mobile/presentation/utils/strings.dart';

import '../../../utils/colors.dart';
import 'receive_controller.dart';

class ReceiveScreen extends GetView<ReceiveController> {
  ReceiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receive Payment'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gap(50),
          Container(
            margin: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Obx(
              () => QrImage(
                data: controller.wallet.value?.id ?? 'processing...',
                size: 230,
                // You can include embeddedImageStyle Property if you
                //wanna embed an image from your Asset folder
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: const Size(
                    100,
                    100,
                  ),
                ),
              ),
            ),
          ),
          Gap(0),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Username'),
                    ),
                    Text(controller.user.value.username ?? '')
                  ],
                ),
                Gap(10),
                Row(
                  children: [
                    Expanded(
                      child: Text('Wallet ID:'),
                    ),
                  ],
                ),
                Obx(() => Text(controller.wallet.value?.id ?? '')),
                Gap(70),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Get.textTheme.labelLarge!.copyWith(
                      letterSpacing: 0.75,
                    ),
                    text: "Recieving an offline payment?\n",
                    children: [
                      TextSpan(
                        text: 'Click here to scan',
                        style: TextStyle(color: AppColors.primary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = controller.offlinePayment,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
