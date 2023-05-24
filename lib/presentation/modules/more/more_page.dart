import 'package:bibuain_pay/core/extentions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:bibuain_pay/presentation/utils/colors.dart';
import 'package:bibuain_pay/presentation/utils/constants.dart';
import '../../../../core/app_routes.dart';
import 'payment_controller.dart';

class MorePage extends GetView<PaymentController> {
  MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('More'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Beneficiaries
            Container(
              child: Column(
                children: [
                  // Header
                  Container(
                    child: Column(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            ProfileHeader(
                              title: 'User User',
                              subTitle: 'Account Details',
                              onTap: () {},
                            ),
                            Gap(30),
                            PaymentItem(
                              title: 'Get Kuda Business',
                              subTitle: '',
                              leading: Card(
                                child: Center(
                                  child: Text(
                                    'K.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onTap: () {},
                            ),
                            PaymentItem(
                              title: 'Statements & Reports',
                              subTitle: 'Download monthly statements',
                              icon: Icon(
                                size: 15,
                                Icons.receipt_rounded,
                                color: AppColors.green,
                              ),
                              onTap: () {
                                Get.toNamed(Routes.statments_reports);
                              },
                            ),
                            PaymentItem(
                              title: 'Saved Cards',
                              subTitle: 'Manage connected cards',
                              icon: Icon(
                                size: 15,
                                Icons.credit_card,
                                color: AppColors.blue,
                              ),
                              onTap: () {},
                            ),
                            PaymentItem(
                              title: 'Get Help',
                              subTitle: 'Get support or send feedback',
                              icon: Icon(
                                size: 15,
                                Icons.help_center_sharp,
                                color: AppColors.red,
                              ),
                              onTap: () {},
                            ),
                            PaymentItem(
                              title: 'Security',
                              subTitle: 'Protect yourself from intruders',
                              icon: Icon(
                                size: 15,
                                Icons.lock,
                                color: AppColors.yellow,
                              ),
                              onTap: () {},
                            ),
                            PaymentItem(
                              title: 'Referrals',
                              subTitle:
                                  'Earn money when your friends join Kuda',
                              icon: Icon(
                                size: 15,
                                Icons.discount,
                                color: AppColors.green,
                              ),
                              onTap: () {},
                            ),
                            PaymentItem(
                              title: 'Account Limits',
                              subTitle: 'How much can you spend and receive',
                              icon: Icon(
                                size: 15,
                                Icons.speed,
                                color: AppColors.blue,
                              ),
                              onTap: () {},
                            ),
                            PaymentItem(
                              title: 'Legal',
                              subTitle: 'About our contract with you',
                              icon: Icon(
                                size: 15,
                                Icons.ballot_outlined,
                                color: AppColors.red,
                              ),
                              onTap: () {},
                            ),
                            Gap(10),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Sign Out',
                                style: TextStyle(
                                  color: AppColors.red,
                                ),
                              ),
                            ).center,
                            Gap(10),
                          ],
                        )
                      ],
                    ),
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

class ProfileHeader extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget? leading;
  final Icon? icon;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  const ProfileHeader({
    super.key,
    required this.title,
    required this.subTitle,
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
                height: 70,
                width: 70,
                child: CircleAvatar(
                  backgroundColor: Colors.black26,
                )),
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
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 12,
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

class PaymentItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget? leading;
  final Icon? icon;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  const PaymentItem({
    super.key,
    required this.title,
    required this.subTitle,
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
            EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 5),
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
                          size: 16,
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
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 11,
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
