// ignore_for_file: must_be_immutable, unused_local_variable, unnecessary_statements, unnecessary_null_comparison
import 'dart:io';

import 'package:bibuain_pay/core/extentions.dart';
import 'package:bibuain_pay/data/chat/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:bibuain_pay/presentation/utils/colors.dart';
import 'package:bibuain_pay/presentation/utils/constants.dart';
import 'package:bibuain_pay/presentation/widgets/app_card.dart';
import 'package:bibuain_pay/presentation/widgets/money_text_view.dart';

import '../../../core/app_routes.dart';
import '../../../data/bank/bank.dart';
import '../../utils/strings.dart';
import '../more/statements/statements_screen.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomePageController> {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Hello ${controller.user.value.username}!'),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.avatar_ring,
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage(kAvatar),
              ),
            ),
            Gap(10),
            Text('Hi, ${controller.user.value.username ?? 'Bibuain'}'),
          ],
        ),
        actions: [
          Icon(
            Icons.pie_chart_rounded,
            color: AppColors.primary,
          ),
          Gap(kDefaultPadding),
        ],
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppMaterial(
            padding:
                EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 5),
            radius: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      child: Text('Spend'),
                    ),
                    Gap(10),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text('Save'),
                    ),
                    Gap(10),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text('Borrow'),
                    ),
                  ],
                ),
                Gap(kDefaultPadding),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/nigeria-flag.jpeg',
                      width: 20,
                    ),
                    Gap(5),
                    Text('Nigerian Naira'),
                  ],
                ),
                Row(
                  children: [
                    Obx(
                      () {
                        // Three states for [user.balance]
                        // Null -> Balance is [LOADING]
                        // Empty -> initial state, no balance is there yet
                        // isNotEmpty -> App has gotten value
                        final balance = controller.user.value.balance;

                        if (balance == null) {
                          return Padding(
                            padding: const EdgeInsets.all(13),
                            child: SpinKitThreeBounce(
                              size: 20,
                              color: AppColors.primary,
                            ),
                          );
                        }

                        return MoneyText(
                          double.parse(controller.user.value.balance ?? '0'),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: controller.refresh,
                      child: HomeCard(
                        text: 'Refresh               ',
                        icon: Icon(
                          Icons.refresh,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Gap(10),
                    HomeCard(
                      text: 'Add Money',
                      icon: Icon(
                        Icons.add_circle,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          /* Expanded(
            child: ListView(
              children: [
                TransactionItemHeader(),
                TransactionItem(),
                TransactionItem(),
                TransactionItem(),
                TransactionItem(),
                TransactionItem(),
                TransactionItemHeader(),
                TransactionItem(),
                TransactionItem(),
                TransactionItemHeader(),
                TransactionItem(),
                TransactionItem(),
                TransactionItem(),
                TransactionItemHeader(),
                TransactionItem(),
                TransactionItem(),
                TransactionItem(),
                TransactionItem(),
                TransactionItem(),
              ],
            ),
          ) */
          Expanded(
            child: GetX<HomePageController>(
              builder: (controller) => controller.statements.value == null
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: controller.statements.value!.length,
                      itemBuilder: (BuildContext context, int index) =>
                          StatementItem(controller.statements.value![index]),
                    ),
            ),
          )
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem(this.transaction, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.transaction, arguments: transaction);
      },
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: 20, horizontal: kDefaultPadding),
        color: Colors.white,
        child: Row(
          children: [
            BankLogo(
              bank: transaction.bank,
            ),
            Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          transaction.recipientName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Gap(10),
                      MoneyText(
                        transaction.amount,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    transaction.createdAt.jmFomart,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.hint),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionItemHeader extends StatelessWidget {
  const TransactionItemHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: kDefaultPadding),
      child: Text(
        '14 lan 2023',
        style: TextStyle(color: AppColors.buttonText),
      ),
    );
  }
}

class BankLogo extends StatelessWidget {
  final Bank bank;
  final bool improve;
  const BankLogo({
    super.key,
    required this.bank,
    this.size,
    this.improve = false,
  });
  final Size? size;

  bool isEmpty(String? i) =>
      i == null || i.isEmpty || i == '' || i.contains('default-image');

  @override
  Widget build(BuildContext context) {
    if (isEmpty(bank.logo)) {
      return CircleAvatar(
        radius: (size?.height ?? 45) / 2,
        child: Center(
          child: Text(
            '${bank.name.trim().replaceFirst('.', '').substring(0, 1)}',
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: AppColors.primary.shade300,
      );
    }
/* 
        if (improve) {
//       GetBuilder<MyController>(
//   init: MyController(),
//   initState: (_) {},

// )//
      return Container(
        height: 50,
        width: 50,
        child: GetBuilder<ItemController>(
            init: ItemController(bank.logo!),
            builder: (_) => Container(
                  height: size?.height ?? 45,
                  width: size?.width ?? 45,
                  // Outer ring
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _.color.value,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        image: _.imageProvider,
                      ),
                    ),
                    // clipBehavior: Clip.hardEdge,
                  ),
                )),
      );
    } */

    ImageProvider imageProvider = NetworkImage(bank.logo!, scale: 0.0001);

    if (improve) {
      return Container(
        height: size?.height ?? 45,
        width: size?.width ?? 45,
        // Outer ring
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.shade200,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            image: DecorationImage(
              image: imageProvider,
            ),
          ),
          // clipBehavior: Clip.hardEdge,
        ),
      );
    }

    return FutureBuilder(
        future: PaletteGenerator.fromImageProvider(
          imageProvider,
          size: Size(20, 20), // optional
          maximumColorCount: 3, // optional
        ),
        builder: (context, paletteGenerator) {
          return Container(
            height: size?.height ?? 45,
            width: size?.width ?? 45,
            // Outer ring
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  paletteGenerator.data?.dominantColor?.color.withOpacity(0.3),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                  image: imageProvider,
                ),
              ),
              // clipBehavior: Clip.hardEdge,
            ),
          );
        });
  }
}

class HomeCard extends StatelessWidget {
  final String text;
  final Widget icon;

  const HomeCard({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Gap(10),
              icon,
              Gap(10),
              Text(
                text,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
