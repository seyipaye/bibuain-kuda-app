import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:swift_pay_mobile/presentation/utils/constants.dart';

import '../../../../core/extentions.dart';
import '../../../../data/chat/chat_message_model.dart';
import '../../../utils/colors.dart';
import '../../../widgets/app_text_form_field.dart';
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
              Text(
                controller.accountName,
                style: Get.theme.appBarTheme.titleTextStyle?.copyWith(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            Icon(Icons.person_add, color: AppColors.green),
            Gap(kDefaultPadding)
          ],
        ),
        body: Obx(() {
          return SafeArea(
              child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: ListView.builder(
                    controller: controller.scrollController,
                    itemCount: controller.chatMessagesList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.chatMessagesList.length) {
                        return SizedBox(
                          height: 20,
                        );
                      }

                      final chat = controller.chatMessagesList[index];
                      return Message(message: chat);
                    },
                  ),
                ),
              ),
              ChatInputField(),
            ],
          ));
        }));
  }
}

class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Chats message;

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(Chats message) {
      return TextMessage(message: message);
      /* switch (message.messageType) {
        case ChatMessageType.text:
          return TextMessage(message: message);
        default:
          return SizedBox();
      }*/
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: message.sender == 'User'
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          messageContaint(message),
          //if (message.isSender) MessageStatusDot(status: message.messageStatus)
        ],
      ),
    );
  }
}

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final Chats? message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: message!.sender == 'User'
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 80,
          ),
          child: Container(
            // color: MediaQuery.of(context).platformBrightness == Brightness.dark
            //     ? Colors.white
            //     : Colors.black,
            padding: EdgeInsets.symmetric(
              horizontal: 21,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: message!.sender == 'User'
                  ? AppColors.primary
                  : AppColors.input_bg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message!.message!,
              softWrap: true,
              style: TextStyle(
                color: message!.sender == 'User'
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        // Add Space intentionally for padding
        Text(
          getTimeAgo(message!.updatedAt!),
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
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: kDefaultPadding / 2, horizontal: kDefaultPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AppTextFormField(
                minLines: 1,
                maxLines: 5,
                textEditingController: controller.replyController,
                decoration: InputDecoration(
                  hintText: "Write a reply",
                  fillColor: AppColors.input_bg,
                  filled: true,
                  isDense: true,
                  border: _buildBorder(),
                  enabledBorder: _buildBorder(),
                  errorBorder: _buildBorder(),
                  focusedBorder: _buildBorder(),
                  focusedErrorBorder: _buildBorder(),
                  disabledBorder: _buildBorder(),
                ),
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                /*SchedulerBinding.instance.addPostFrameCallback((_) {
                  controller.scrollController.animateTo(
                      controller.scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut);
                });*/

                if (controller.replyController.text.isEmpty) return;

                controller.chatMessagesList.add(Chats(
                    message: controller.replyController.text,
                    updatedAt: DateTime.now().toString(),
                    sender: 'User'));
                // controller.chatMessagesList.reversed;

                controller.sendMessage(controller.replyController.text.trim());

                controller.replyController.clear();

                SchedulerBinding.instance.addPostFrameCallback((_) {
                  controller.scrollController.animateTo(
                      controller.scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut);
                });
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
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
