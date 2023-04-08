import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:bibuain_pay/core/app_routes.dart';
import 'package:bibuain_pay/presentation/utils/constants.dart';
import 'package:bibuain_pay/presentation/utils/validators.dart';
import 'package:bibuain_pay/presentation/widgets/money_text_view.dart';

import '../../../../core/extentions.dart';
import '../../../../data/chat/chat_message_model.dart';
import '../../../utils/colors.dart';
import '../../../widgets/app_text_form_field.dart';
import '../../../widgets/number_pad/num_pad.dart';
import '../../home/home_page.dart';
import 'transfer_chat_controller.dart';

class TransferChatScreen extends GetView<TransferChatController> {
  TransferChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 40,
              child: BankLogo(bank: controller.bank),
            ),
            Gap(10),
            Expanded(
              child: Text(
                controller.accountName,
                style: Get.theme.appBarTheme.titleTextStyle?.copyWith(
                  fontSize: 14,
                ),
                softWrap: true,
                maxLines: 2,
              ),
            ),
          ],
        ),
        actions: [
          Icon(Icons.person_add, color: AppColors.green),
          Gap(kDefaultPadding)
        ],
      ),
      body: Obx(
        () {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: _buildList(),
                  ),
                ),
                ChatInputField(),
              ],
            ),
          );
        },
      ),
    );
  }

  ListView _buildList() {
    return ListView.builder(
      controller: controller.scrollController,
      itemCount: controller.transactions.length + 1,
      itemBuilder: (context, index) {
        if (index == controller.transactions.length) {
          return Padding(
            padding:
                const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 80),
            child: Text(
              'Tap on a message to see transaction details.',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.hint,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        final chat = controller.transactions[index];
        return Message(message: chat);
      },
    );
  }
}

class Message extends GetView<TransferChatController> {
  const Message({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Transaction message;

  @override
  Widget build(BuildContext context) {
    Widget messageContent(Transaction message) {
      return TextMessage(message: message);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      // Left or Right Gravity
      child: Row(
        mainAxisAlignment: controller.isSender(message)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          messageContent(message),
        ],
      ),
    );
  }
}

class TextMessage extends GetView<TransferChatController> {
  const TextMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final Transaction? message;

  @override
  Widget build(BuildContext context) {
    final isSender = controller.isSender(message!);
    const sidePadding = 120;
    return Column(
      // Left or Right Gravity for Time Label
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - sidePadding,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSender)
                Icon(
                  Icons.check_circle,
                  color: AppColors.green,
                  size: 20,
                ),
              if (isSender) Gap(20),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.transaction, arguments: message);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSender ? AppColors.primary : AppColors.input_bg,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft:
                            isSender ? Radius.circular(16) : Radius.zero,
                        bottomRight:
                            !isSender ? Radius.circular(16) : Radius.zero,
                      ),
                    ),
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MoneyText(
                            message?.amount ?? 90,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: isSender ? Colors.white : AppColors.green,
                            ),
                          ),
                          Divider(
                            color: isSender
                                ? Color(0xFF47296C)
                                : Color(0xFFF1F2F4),
                          ),
                          Text(
                            message!.description!,
                            softWrap: true,
                            style: TextStyle(
                              color: isSender ? Colors.white : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
        // Add Space intentionally for padding
        Text(
          getTimeAgo(message!.updatedAt.toString()),
          style: Get.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class ChatInputField extends GetView<TransferChatController> {
  const ChatInputField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -55,
            right: 0,
            left: 0,
            child: Center(
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Free transfers to other banks',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.primary,
                        ),
                      ),
                      Gap(10),
                      Text(
                        '16',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                shadowColor: AppColors.primary,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColors.primary.shade200),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: AppColors.outline),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -2),
                  blurRadius: 2,
                  color: AppColors.offset,
                )
              ],
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'NGN Balance:     ',
                        style: GoogleFonts.getFont(
                          'Roboto',
                          color: AppColors.buttonText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Obx(
                        () {
                          // Three states for [user.balance]
                          // Null -> Balance is [LOADING]
                          // Empty -> initial state, no balance is there yet
                          // isNotEmpty -> App has gotten value
                          final balance = controller.user.value.balance;

                          if (balance == null) {
                            return SpinKitThreeBounce(
                              size: 10,
                              color: AppColors.primary,
                            );
                          }

                          return MoneyText(
                            double.parse(controller.user.value.balance ?? '0'),
                            style: GoogleFonts.getFont(
                              'Roboto',
                              color: AppColors.buttonText,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  color: Color(0xFFFBFBFB),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AppTextFormField2(
                          maxLines: 1,
                          // inputFormatters: <TextInputFormatter>[
                          //   controller.formatter
                          // ],
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          focusNode: controller.myFocusNode,
                          textEditingController: controller.amountController,
                          onChanged: controller.onAmountChanged,
                          style: GoogleFonts.getFont(
                            'Roboto',
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'NGN',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: AppTextFormField(
                      maxLines: 1,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: controller.onDescriptionChanged,
                      validator: Validator.isDescription,
                      textEditingController: controller.descriptionController,
                      decoration: InputDecoration(
                        hintText: "Naration (e.g Sent from Kuda)",
                        isDense: true,
                        border: _buildBorder(),
                        enabledBorder: _buildBorder(),
                        errorBorder: _buildBorder(),
                        focusedBorder: _buildBorder(),
                        focusedErrorBorder: _buildBorder(),
                        disabledBorder: _buildBorder(),
                      ),
                      style: GoogleFonts.getFont(
                        'Roboto',
                        fontSize: 16,
                      ),
                    )),
                    Gap(10),
                    // Counter
                    GetX<TransferChatController>(
                      builder: (_) {
                        final length = _.description.value.length;
                        const max_length = 100;
                        const min_lenght = 3;
                        bool over_limit = length > max_length;
                        bool under_limit = length < min_lenght;

                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: under_limit
                                ? Colors.yellow.shade100
                                : over_limit
                                    ? Colors.red.shade100
                                    : AppColors.primary.shade200,
                          ),
                          child: CircularPercentIndicator(
                            radius: 14,
                            lineWidth: 3,
                            percent: over_limit ? 1.0 : length / max_length,
                            center: Text(
                              over_limit
                                  ? max_length.toString()
                                  : length.toString(),
                              style: TextStyle(fontSize: 10),
                            ),
                            progressColor: under_limit
                                ? Colors.yellow
                                : over_limit
                                    ? AppColors.red
                                    : AppColors.primary,
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 10),
                    GetX<TransferChatController>(
                      builder: (_) => IconButton(
                        onPressed: _.isButtonEnabled.value
                            ? controller.onSendPressed
                            : null,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.primary.shade200,
                          fixedSize: Size(55, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                // Implement the Custom NumPad
                GetX<TransferChatController>(
                  builder: (_) => !_.showNumberPad.value
                      ? SizedBox.shrink()
                      : NumPad(
                          buttonSize: 70,
                          buttonColor: Colors.purple,
                          iconColor: Colors.deepOrange,
                          controller: controller.amountController,
                          onDeletePressed: () {
                            controller.amountController.text =
                                controller.amountController.text.substring(
                                    0,
                                    controller.amountController.text.length -
                                        1);
                          },
                          // do something with the input numbers
                          onDotPressed: () {},
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: AppColors.input_bg),
    );
  }
}
