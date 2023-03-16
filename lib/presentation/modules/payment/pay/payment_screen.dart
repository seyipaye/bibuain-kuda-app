import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swift_pay_mobile/presentation/utils/colors.dart';
import 'package:swift_pay_mobile/presentation/utils/constants.dart';
import '../../../../core/app_routes.dart';
import 'payment_controller.dart';

class PayPage extends GetView<PaymentController> {
  PayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Pay'),
        actions: [
          Icon(
            Icons.search,
            color: AppColors.primary,
          ),
          Gap(10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Beneficiaries
            Container(
              child: Column(
                children: [
                  // Header
                  Header(
                    title: 'Beneficiaries',
                    trailing: 'View all',
                  ),
                  Container(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(left: kDefaultPadding - 10),
                      children: [
                        BeneficiaryItem(
                          name: 'Anita',
                          index: 0,
                        ),
                        BeneficiaryItem(
                          name: 'Book',
                          index: 1,
                        ),
                        BeneficiaryItem(
                          name: 'Stone',
                          index: 2,
                        ),
                        BeneficiaryItem(
                          name: 'Daniel',
                          index: 3,
                        ),
                        BeneficiaryItem(
                          name: 'Anita',
                          index: 4,
                        ),
                        BeneficiaryItem(
                          name: 'Sheep',
                          index: 5,
                        ),
                        BeneficiaryItem(
                          name: 'Car',
                          index: 6,
                        ),
                        BeneficiaryItem(
                          name: 'Elon',
                          index: 7,
                        ),
                        BeneficiaryItem(
                          name: 'David',
                          index: 8,
                        ),
                        BeneficiaryItem(
                          name: 'Lagos',
                          index: 9,
                        ),
                        BeneficiaryItem(
                          name: 'Ibadan',
                          index: 10,
                        ),
                      ],
                    ),
                  ),
                  // Header
                  Container(
                    child: Column(
                      children: [
                        Header(
                          title: 'Send Money',
                        ),
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            PaymentItem(
                              title: 'Send to @username',
                              subTitle: 'Send to any Kuda account, for free.',
                              onTap: () {},
                              leading: Card(
                                child: Center(
                                  child: Text(
                                    'K.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                color: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            PaymentItem(
                              title: 'Send To Bank Account',
                              subTitle: 'Send to a local bank account.',
                              icon: Icon(
                                size: 15,
                                Icons.send,
                                color: AppColors.green,
                              ),
                              onTap: () {
                                Get.toNamed(Routes.newRecipient);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Header(
                          title: 'Pay Bills',
                        ),
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            PaymentItem(
                              title: 'Buy Airtime',
                              subTitle: 'Recharge any phone easily.',
                              icon: Icon(
                                size: 15,
                                Icons.phone_iphone,
                                color: AppColors.yellow,
                              ),
                              onTap: () {},
                            ),
                            PaymentItem(
                              title: 'Pay A Bill',
                              subTitle:
                                  'Send and receive money without account numbers',
                              icon: Icon(
                                size: 15,
                                Icons.receipt_rounded,
                                color: AppColors.green,
                              ),
                              onTap: () {},
                            ),
                            PaymentItem(
                              title: 'Gift Cards',
                              subTitle: 'Shop around the world online.',
                              icon: Icon(
                                size: 15,
                                Icons.shopping_bag_rounded,
                                color: AppColors.blue,
                              ),
                              onTap: () {},
                            ),
                            PaymentItem(
                              title: 'Cardless Payments',
                              subTitle: 'Make payments without a card',
                              icon: Icon(
                                size: 15,
                                Icons.language_rounded,
                                color: AppColors.red,
                              ),
                              onTap: () {},
                            ),
                            PaymentItem(
                              title: 'Scheduled Payments',
                              subTitle: 'Future payments and standing orders.',
                              icon: Icon(
                                size: 15,
                                Icons.calendar_month_rounded,
                                color: AppColors.blue,
                              ),
                              onTap: () {},
                            ),
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
                  Text(
                    subTitle,
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
