import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bibuain_pay/core/extentions.dart';
import 'package:bibuain_pay/presentation/utils/constants.dart';

import '../../../../core/app_routes.dart';
import '../../../../data/bank/bank.dart';
import '../../../../data/chat/chat_message_model.dart';
import '../../../../data/user/user.dart';
import '../../../../domain/repositories/auth_repo.dart';
import '../offline_payment/pin_screen.dart';

class TransferChatController extends GetxController {
  final balance = 0.0.obs;
  Rx<User> get user => AuthRepository.instance.user;
  late Bank bank;
  late String accountName;
  final description = ''.obs;
  final amount = ''.obs;
  final unfomartedAmount = 0.0.obs;
  final showNumberPad = false.obs;
  final formKey = GlobalKey<FormState>();

  final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'en_NG', decimalDigits: 0, symbol: '₦');

  final CurrencyTextInputFormatter formatter1 = CurrencyTextInputFormatter(
      locale: 'en_NG', decimalDigits: 1, symbol: '₦');

  final CurrencyTextInputFormatter formatter2 = CurrencyTextInputFormatter(
      locale: 'en_NG', decimalDigits: 2, symbol: '₦');

  FocusNode myFocusNode = FocusNode();

  final ScrollController scrollController = ScrollController();
  final chatMessagesList = [
    Chats(
      amount: 3000,
      senderName: 'Sample account name',
      description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
      createdAt: '2022-09-09T08:23:38.649Z',
      updatedAt: '2022-09-09T08:23:38.649Z',
    ),
    Chats(
      amount: 45000,
      senderName: 'dfdfdfdf',
      description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
      createdAt: '2022-09-09T08:23:38.649Z',
      updatedAt: '2022-09-09T08:23:38.649Z',
    ),
    Chats(
      amount: 3000,
      senderName: 'Sample account name',
      description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
      createdAt: '2022-09-09T08:23:38.649Z',
      updatedAt: '2022-09-09T08:23:38.649Z',
    ),
    Chats(
      amount: 3000,
      senderName: 'Sample account name',
      description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
      createdAt: '2022-09-09T08:23:38.649Z',
      updatedAt: '2022-09-09T08:23:38.649Z',
    ),
    Chats(
      amount: 3000,
      senderName: 'Sample account name',
      description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
      createdAt: '2022-09-09T08:23:38.649Z',
      updatedAt: '2022-09-09T08:23:38.649Z',
    ),
    Chats(
      amount: 3000,
      senderName: 'Sample account name',
      description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
      createdAt: '2022-09-09T08:23:38.649Z',
      updatedAt: '2022-09-09T08:23:38.649Z',
    ),
    Chats(
      amount: 3000,
      senderName: 'Sample account name',
      description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
      createdAt: '2022-09-09T08:23:38.649Z',
      updatedAt: '2022-09-09T08:23:38.649Z',
    ),
    Chats(
      amount: 3000,
      senderName: 'Sample account name',
      description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
      createdAt: '2022-09-09T08:23:38.649Z',
      updatedAt: '2022-09-09T08:23:38.649Z',
    ),
    Chats(
      amount: 3000,
      senderName: 'Sample account name',
      description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
      createdAt: '2022-09-09T08:23:38.649Z',
      updatedAt: '2022-09-09T08:23:38.649Z',
    ),
    Chats(
      amount: 3000,
      senderName: 'Sample account name',
      description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
      createdAt: '2022-09-09T08:23:38.649Z',
      updatedAt: '2022-09-09T08:23:38.649Z',
    ),
    Chats(
      amount: 3000,
      senderName: 'Sample account name',
      description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
      createdAt: '2022-09-09T08:23:38.649Z',
      updatedAt: '2022-09-09T08:23:38.649Z',
    ),
    Chats(
      amount: 3000,
      senderName: 'Sample name',
      description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
      createdAt: '2022-09-09T08:23:38.649Z',
      updatedAt: '2022-09-09T08:23:38.649Z',
    ),
  ].obs;
  final amountController = TextEditingController(text: '₦0.00');
  final descriptionController = TextEditingController();

  final isButtonEnabled = false.obs;

  @override
  void onInit() {
    print(Get.arguments);
    bank = Get.arguments['bank'];
    accountName = Get.arguments['accountName'];
    amountController.addListener(() {
      print('innner ${amountController.text}');

      if (amountController.text.contains('.') &&
          amountController.text != '₦0.00') {
        if (amountController.text.endsWith('.')) {
          formatter.format(amountController.text);
          unfomartedAmount.value = formatter.getUnformattedValue().toDouble();
          validate();
          return;
        }
        ;

        if (amountController.text.indexOf('.') ==
            amountController.text.length - 2) {
          // Output
          final output = formatter1.format(amountController.text);
          amountController.text = output;
          unfomartedAmount.value = formatter1.getUnformattedValue().toDouble();
          validate();
          return;
        }
        if (amountController.text.indexOf('.') ==
            amountController.text.length - 3) {
          // Output
          final output = formatter2.format(amountController.text);
          amountController.text = output;
          unfomartedAmount.value = formatter2.getUnformattedValue().toDouble();
          validate();
          return;
        }
        // if (amountController.text.indexOf('.') <
        //     amountController.text.length - 3) {
        //   // Output
        //   final output = formatter2.format(amountController.text);
        //   amountController.text = output;
        //   return;
        // }
      }
      // Output
      final output = formatter.format(amountController.text);
      amountController.text = output;
      unfomartedAmount.value = formatter.getUnformattedValue().toDouble();
      validate();
      print('listened');
    });
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        showNumberPad.value = true;
        // Hide the keyboard
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      } else {
        showNumberPad.value = false;
      }
    });
    _fetchBalance();
    super.onInit();
    debugPrint('Listening to message');
    fetchChatMessage();
    // AppProvider.value.sockett.on('message', (data) {
    //   debugPrint('$data');

    //   chatMessagesList
    //       .add(Chats(message: data, updatedAt: DateTime.now().toString()));

    //   SchedulerBinding.instance.addPostFrameCallback((_) {
    //     if (scrollController.hasClients) //do your stuff here

    //       scrollController.animateTo(scrollController.position.maxScrollExtent,
    //           duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    //   });
    // });
  }

  void fetchChatMessage() async {
    // showLoadingState;
/* 
    try {
      ChatMessageModel? csModel =
          await AppRepository.instance.fetchChatMessage(riderId.value);
      if (csModel != null) {
        chatMessagesList.assignAll(csModel.chats!);
      }
    } catch (e) {
      showError(e.toString());
    } */
  }

  isSender(Chats chats) => chats.senderName == accountName;

  @override
  void onReady() {
    if (scrollController.hasClients) //do your stuff here

      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 600), curve: Curves.easeOut);
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onSendPressed() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final result = await Get.bottomSheet(PinSheet());

    if (result != null) {
      showLoadingState;
      await kAnimationDelay;
      await kAnimationDelay;
      showMessage('Successful', clear: true);

      sendMessage();
    }
  }

  void sendMessage() {
    chatMessagesList.add(
      Chats(
        description: descriptionController.text,
        updatedAt: DateTime.now().toString(),
        senderName: accountName,
        amount: unfomartedAmount.value,
      ),
    );
    // controller.chatMessagesList.reversed;

    // sendMessage(descriptionController.text.trim());

    descriptionController.clear();
    description.value = '';
    amountController.clear();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _fetchBalance() {
    AuthRepository.instance.fetchWallet().then((freshWallet) {
      // Success
      balance.value = freshWallet.balance;
      // wallet.value = freshWallet;
    }).catchError((err, stackTrace) {
      if (err is! String) {
        err = err.toString();
      }
      // Error
      showError(err);
    });
  }

  validate() {
    if (description.value.length >= 3 && unfomartedAmount.value > 0) {
      isButtonEnabled.value = true;
    } else {
      isButtonEnabled.value = false;
    }
  }

  Future<void> offlinePayment() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final form = formKey.currentState!;

    // if (!form.validate()) {
    // } else if (accountName.value == null || accountName.value!.isEmpty) {
    //   showError('Account name is required');
    // } else {
    //   form.save();

    //   _uploadDetails();
    // }

    final url = await Get.toNamed(Routes.offlineScan);
    if (url != null) {
      final uri = Uri.parse(url as String);

      final wallet_id = uri.pathSegments.last;
      final amount = uri.queryParameters['amount'];

      print('$wallet_id $amount');

      // proccess charge here

      showLoadingState;

      AuthRepository.instance
          .charge(
        id: wallet_id,
        amount: num.parse(amount ?? '0'),
      )
          .then((msg) {
        // Success, Go Back back
        showMessage(msg, clear: true);
        Get.until((route) => Get.currentRoute == Routes.home);
      }).catchError((err, stackTrace) {
        if (err is! String) {
          err = err.toString();
        }
        // Error
        showError(err, clear: true);
      });
    }
  }

  void onDescriptionChanged(String value) {
    description.value = value;
    print('$value lenght: ${value.length}');
    validate();
  }

  void onAmountChanged(String value) {
    amount.value = value;
    validate();
  }
}
