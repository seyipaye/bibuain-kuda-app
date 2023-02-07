import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:swift_pay_mobile/presentation/modules/payment/pay/scan_controller.dart';

import '../receive/receive_controller.dart';

class ScanScreen extends GetView<ScanController> {
  ScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Payment'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(50),
          Container(
            margin: EdgeInsets.all(20),
            height: 400,
            alignment: Alignment.center,
            child: MobileScanner(
              allowDuplicates: false,
              controller: controller.cameraController,
              onDetect: controller.onDetect,
            ),
          ),
          Gap(10),
          Text(
            'Place the QRCode withing \nthe camera box',
            textAlign: TextAlign.center,
          ),
          Gap(10),
          Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: FloatingActionButton(
                onPressed: () {
                  controller.cameraController.toggleTorch();
                  // controller.validateCode('97f58c899a9f4739bf4d94437b910760');
                },
                child: ValueListenableBuilder(
                  valueListenable: controller.cameraController.torchState,
                  builder: (context, state, child) {
                    switch (state) {
                      case TorchState.off:
                        return const Icon(Icons.flashlight_off_rounded);
                      case TorchState.on:
                        return const Icon(Icons.flashlight_on_rounded);
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
