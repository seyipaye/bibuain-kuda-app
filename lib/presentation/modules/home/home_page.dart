// ignore_for_file: must_be_immutable, unused_local_variable, unnecessary_statements, unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swift_pay_mobile/presentation/widgets/app_card.dart';
import 'package:swift_pay_mobile/presentation/widgets/money_text_view.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomePageController> {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello! '),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppMaterial(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(50),
            child: Column(
              children: [
                Text('Total Balance'),
                Obx(
                  () => MoneyText(
                    controller.balance.value,
                    fontsize: 40,
                  ),
                ),
                IconButton(
                    onPressed: controller.refresh,
                    icon: Icon(
                      Icons.refresh,
                    )),
                Row(
                  children: [
                    Column(
                      children: [
                        IconButton(
                            onPressed: controller.refresh,
                            icon: Icon(
                              Icons.input_rounded,
                            )),
                        Text('Recieve Payment')
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
