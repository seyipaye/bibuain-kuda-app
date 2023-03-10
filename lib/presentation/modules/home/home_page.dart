// ignore_for_file: must_be_immutable, unused_local_variable, unnecessary_statements, unnecessary_null_comparison
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:swift_pay_mobile/presentation/utils/colors.dart';
import 'package:swift_pay_mobile/presentation/utils/constants.dart';
import 'package:swift_pay_mobile/presentation/widgets/app_card.dart';
import 'package:swift_pay_mobile/presentation/widgets/money_text_view.dart';

import '../../utils/strings.dart';
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
                    MoneyText(
                      5000,
                      fontsize: 25,
                      fontWeight: FontWeight.bold,
                    )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    HomeCard(
                      text: 'Convert',
                      icon: Icon(
                        Icons.swap_horizontal_circle_rounded,
                        color: AppColors.primary,
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
          Expanded(
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
          )
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: kDefaultPadding),
      color: Colors.white,
      child: Row(
        children: [
          BankLogo(
            link: 'https://nigerianbanks.xyz/logo/guaranty-trust-bank.png',
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
                        'Fakehinde Precious Adedamola',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Gap(10),
                    MoneyText(
                      1000,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  '10:03 AM',
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
  final String link;
  const BankLogo({
    super.key,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider = NetworkImage(link);

    return FutureBuilder(
        future: PaletteGenerator.fromImageProvider(
          imageProvider,
          size: Size(100, 100), // optional
          maximumColorCount: 20, // optional
        ),
        builder: (context, paletteGenerator) {
          return Container(
            width: 45,
            // Outer ring
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  paletteGenerator.data?.dominantColor?.color.withOpacity(0.1),
            ),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: paletteGenerator.data?.dominantColor?.color,
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(link),
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
      child: Card(
        surfaceTintColor: Colors.white,
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
