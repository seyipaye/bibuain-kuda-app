import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bibuain_pay/core/extentions.dart';
import 'package:bibuain_pay/presentation/modules/home/home_page.dart';
import 'package:bibuain_pay/presentation/utils/colors.dart';
import 'package:bibuain_pay/presentation/utils/constants.dart';
import 'package:bibuain_pay/presentation/widgets/app_card.dart';
import '../../../../data/bank/bank.dart';
import '../pay/payment_screen.dart';
import 'transaction_controller.dart';

class TransactionScreen extends GetView<TransactionController> {
  TransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction'),
        actions: [
          ElevatedButton(
            onPressed: () {},
            child: Text('Share'),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(0, 0),
                padding: EdgeInsets.symmetric(horizontal: 8)),
          ),
          Gap(kDefaultPadding)
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Center(
            child: Column(
              children: [
                AppCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: kDefaultPadding,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.shade200,
                          ),
                          child: Transform.rotate(
                            angle: 100,
                            child: Icon(
                              Icons.send,
                              size: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Gap(kDefaultPadding * 1.5),
                        Text(
                          'Transfer',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(10),
                Text(
                  'On JAN 07, 2023 at 05:16 PM',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Gap(kDefaultPadding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '+N12,000.00',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Gap(4),
              Text(
                'IPAYE OLUWASEYIFUNMI SULAIMON',
                style: TextStyle(fontSize: 15, color: AppColors.buttonText),
              ),
            ],
          ),
          Divider(color: AppColors.buttonText),
          TransListTile(
            title: 'From',
            content: 'GTBank Plc',
            trailing: BankLogo(
              size: Size(52, 52),
              bank: Bank(
                'Gtbank',
                'code',
                'slug',
                'https://nigerianbanks.xyz/logo/guaranty-trust-bank.png',
                4,
              ),
            ),
          ),
          Divider(color: AppColors.buttonText),
          TransListTile(
            title: 'Description',
            content: 'KIP.GTB/IPAYE OLUWASEYIFUN/viazGTWORLD',
          ),
          Divider(color: AppColors.buttonText),
          TransListTile(
            title: 'Payment method',
            content: 'Inward Transfer',
          ),
          Divider(color: AppColors.buttonText),
          TransListTile(
            title: 'Status',
            content: 'Successful',
            leading: Icon(
              Icons.circle,
              size: 12,
              color: AppColors.green,
            ),
          ),
          Divider(color: AppColors.buttonText),
          TransListTile(
            title: 'Session ID',
            content: '2301071550879',
          ),
          Header(
            title: 'More Actions',
            padding: EdgeInsets.symmetric(vertical: 2),
          ),
          PaymentItem(
            title: 'Report Transaction',
            subTitle: 'Report an issue with this payment',
            padding: EdgeInsets.symmetric(vertical: 12),
            icon: Icon(
              size: 15,
              Icons.calculate,
              color: AppColors.red,
            ),
            onTap: () {},
          ),
          // ElevatedButton(onPressed: controller.topUp, child: Text('Top-Up'))
        ],
      ),
    );
  }
}

class TransListTile extends StatelessWidget {
  const TransListTile({
    super.key,
    required this.title,
    this.content,
    this.trailing,
    this.leading,
  });

  final String title;
  final String? content;
  final Widget? trailing;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 13, color: AppColors.buttonText),
                ),
                Row(
                  children: [
                    if (leading != null) leading!,
                    if (leading != null) Gap(10),
                    Expanded(
                      child: Text(
                        content ?? '',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          trailing ??
              SizedBox(
                height: 52,
                width: 52,
              )
        ],
      ),
    );
  }
}
