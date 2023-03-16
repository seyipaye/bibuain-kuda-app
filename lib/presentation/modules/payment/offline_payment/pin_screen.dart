import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:swift_pay_mobile/presentation/utils/colors.dart';
import '../../../widgets/number_pad/num_pad.dart';
import 'pin_controller.dart';

const greenCircle = Icon(
  Icons.circle,
  color: AppColors.green,
);

const greyCircle = Padding(
  padding: EdgeInsets.all(5),
  child: Icon(
    Icons.circle,
    size: 10,
    color: AppColors.hint,
  ),
);

class PinSheet extends GetView<PinController> {
  PinSheet({Key? key}) : super(key: key) {
    Get.put(PinController());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.close),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock,
                color: AppColors.green,
                size: 15,
              ),
              Gap(5),
              Text('Transaction PIN'),
            ],
          ),
          Gap(10),
          Container(
            child: GetX<PinController>(
              builder: (_) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Gap(10),
                    controller.pin.value.length > 0 ? greenCircle : greyCircle,
                    Gap(10),
                    controller.pin.value.length > 1 ? greenCircle : greyCircle,
                    Gap(10),
                    controller.pin.value.length > 2 ? greenCircle : greyCircle,
                    Gap(10),
                    controller.pin.value.length > 3 ? greenCircle : greyCircle,
                  ],
                );
              },
            ),
          ),
          Gap(10),
          NumPad(
            buttonSize: 70,
            buttonColor: Colors.purple,
            iconColor: Colors.deepOrange,
            controller: controller.pinController,
            onDeletePressed: () {
              controller.pinController.text = controller.pinController.text
                  .substring(0, controller.pinController.text.length - 1);
            },
            // do something with the input numbers
            onDotPressed: () {},
            isPinInput: true,
           
          ),
        ],
      ),
    );
  }
}
