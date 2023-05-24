import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:bibuain_pay/presentation/utils/colors.dart';
import 'package:bibuain_pay/presentation/utils/constants.dart';
import '../../../../core/app_routes.dart';
import 'statement_controller.dart';

class StatementReportScreen extends GetView<StatementController> {
  StatementReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Text('Statement & Reports'),
            Gap(10),
            Image.asset(
              'assets/images/nigeria-flag.jpeg',
              width: 20,
            ),
          ],
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          PaymentItem(
            title: 'Request Statement',
            icon: Icon(
              size: 15,
              Icons.receipt,
              color: AppColors.green,
            ),
            onTap: () {
              Get.toNamed(Routes.statments);
            },
          ),
          PaymentItem(
            title: 'Spending Report',
            icon: Icon(
              size: 15,
              Icons.pie_chart,
              color: AppColors.blue,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class PaymentItem extends StatelessWidget {
  final String title;
  final String? subTitle;
  final Widget? leading;
  final Icon? icon;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  const PaymentItem({
    super.key,
    required this.title,
    this.subTitle,
    this.leading,
    required this.onTap,
    this.icon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding ??
            EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 10),
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              child: leading ??
                  Card(
                    child: icon ??
                        Icon(
                          Icons.send,
                          size: 15,
                        ),
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
            ),
            Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  if (subTitle != null)
                    Text(
                      subTitle!,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.hint,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: AppColors.buttonText,
            )
          ],
        ),
      ),
    );
  }
}

const colors = [
  AppColors.blue,
  AppColors.yellow,
  AppColors.green,
  AppColors.purple,
];

class BeneficiaryItem extends StatelessWidget {
  final String name;
  final int index;
  const BeneficiaryItem({
    super.key,
    required this.name,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            child: Center(
              child: Text(
                '${name.trim().substring(0, 1)}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              ),
            ),
            backgroundColor: colors[index % 4],
          ),
          Gap(10),
          Text(name),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String title;
  final String? trailing;
  const Header({
    super.key,
    required this.title,
    this.trailing,
    this.padding,
  });

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: kDefaultPadding,
          ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            trailing ?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.green,
            ),
          ),
        ],
      ),
    );
  }
}
