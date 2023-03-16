import 'package:flutter/material.dart';
import 'package:swift_pay_mobile/presentation/utils/colors.dart';
import 'package:vibration/vibration.dart';

const double innerSpacing = 7;

void vibrate() async {
  if (await Vibration.hasVibrator() ?? false) {
    Vibration.vibrate(duration: 50);
  }
}

class NumPad extends StatelessWidget {
  final double buttonSize;
  final Color buttonColor;
  final Color iconColor;
  final TextEditingController controller;
  final VoidCallback onDeletePressed;
  final Function onDotPressed;
  final bool isPinInput;

  const NumPad({
    Key? key,
    this.buttonSize = 70,
    this.buttonColor = Colors.indigo,
    this.iconColor = Colors.amber,
    required this.onDeletePressed,
    required this.onDotPressed,
    required this.controller,
    this.isPinInput = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: innerSpacing),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: innerSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // implement the number keys (from 0 to 9) with the NumberButton widget
            // the NumberButton widget is defined in the bottom of this file
            children: [
              NumberButton(
                number: 1,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 2,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 3,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
            ],
          ),
          const SizedBox(height: innerSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                number: 4,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 5,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 6,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
            ],
          ),
          const SizedBox(height: innerSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                number: 7,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 8,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 9,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
            ],
          ),
          const SizedBox(height: innerSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // this button is used to delete the last number
              isPinInput
                  ? TextButton(
                      onPressed: () {},
                      child: Text('            '),
                    )
                  : TextButton(
                      onPressed: () {
                        vibrate();
                        // Input
                        if (controller.text.contains('.')) return;
                        final output = controller.text += '.';

                        print('outer');

                        controller.value = TextEditingValue(
                          text: output,
                          selection:
                              TextSelection.collapsed(offset: output.length),
                        );
                      },
                      child: Text('     .      '),
                    ),
              NumberButton(
                number: 0,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              // this button is used to submit the entered value
              TextButton(
                onPressed: () {
                  vibrate();
                  onDeletePressed();
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: AppColors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// define NumberButton widget
// its shape is round
class NumberButton extends StatelessWidget {
  final int number;
  final double size;
  final Color color;
  final TextEditingController controller;

  const NumberButton({
    Key? key,
    required this.number,
    required this.size,
    required this.color,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size / 2),
          ),
        ),
        onPressed: () {
          vibrate();

          if (controller.text.contains('.') &&
              controller.text != '₦0.00' &&
              controller.text.indexOf('.') == controller.text.length - 3) {
            print('catch');
            return;
          }

          // Input
          final output = controller.text += number.toString();

          print('output2 $output');
        },
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontSize: 32,
            ),
          ),
        ),
      ),
    );
  }
}
