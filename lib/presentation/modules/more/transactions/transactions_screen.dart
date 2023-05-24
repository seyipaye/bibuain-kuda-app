import 'package:bibuain_pay/presentation/utils/strings.dart';
import 'package:bibuain_pay/presentation/widgets/money_text_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:bibuain_pay/presentation/utils/colors.dart';
import 'package:bibuain_pay/presentation/utils/constants.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../../../core/app_routes.dart';
import '../../../../data/bank/bank.dart';
import '../../../../data/chat/chat_message_model.dart';
import 'transactions_controller.dart';

class TransactionsScreen extends GetView<TransactionsController> {
  TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statement'),
      ),
      body: GetX<TransactionsController>(
        builder: (controller) => controller.statements.value == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: controller.statements.value!.length,
                itemBuilder: (BuildContext context, int index) =>
                    StatementItem(controller.statements.value![index]),
              ),
      ),
    );
  }
}

class StatementItem extends StatelessWidget {
  final Statement statement;

  const StatementItem(this.statement, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Get.toNamed(Routes.transaction, arguments: statement);
      },
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: 20, horizontal: kDefaultPadding),
        color: Colors.white,
        child: Row(
          children: [
            BankLogo(
              bank: kBank,
            ),
            Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    statement.description,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        statement.date,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppColors.hint,
                        ),
                      ),
                      Gap(10),
                      (statement.amount_paid == '--' &&
                              statement.amount_received != '--')
                          ? _buildMoneyText(
                              prefix: '+',
                              text: statement.amount_received,
                              color: AppColors.green,
                            )
                          : (statement.amount_received == '--' &&
                                  statement.amount_paid != '--')
                              ? _buildMoneyText(
                                  prefix: '-',
                                  text: statement.amount_paid,
                                  color: Colors.black,
                                )
                              : _buildMoneyText(
                                  prefix: '',
                                  text: '0',
                                  color: Colors.black,
                                )

                      // MoneyText(
                      //   statement.amount,
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 12,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  RichText _buildMoneyText({prefix, required text, color}) {
    final textStyle = TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
    );

    return RichText(
      text: TextSpan(
        style: textStyle,
        children: [
          TextSpan(
            text: prefix,
            style: textStyle,
          ),
          TextSpan(
              text: '₦',
              style: textStyle.copyWith(
                fontFamily: '.SF UI Display',
              )),
          TextSpan(
            text: text,
            style: textStyle,
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
            color: paletteGenerator.data?.dominantColor?.color.withOpacity(0.3),
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
      },
    );
  }
}
