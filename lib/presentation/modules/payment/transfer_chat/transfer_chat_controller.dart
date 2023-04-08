import 'package:bibuain_pay/presentation/utils/strings.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bibuain_pay/core/extentions.dart';

import '../../../../core/app_routes.dart';
import '../../../../data/bank/bank.dart';
import '../../../../data/chat/chat_message_model.dart';
import '../../../../data/user/user.dart';
import '../../../../domain/repositories/auth_repo.dart';
import '../offline_payment/pin_screen.dart';

class TransferChatController extends GetxController {
  Rx<User> get user => AuthRepository.instance.user;

  Transactions get transactions =>
      AuthRepository.instance.user.value.transactions
          .where((element) => element.recipientName == accountName)
          .toList();

  // Three states for [user.balance]
  // Null -> initial state, no balance is there yet
  // Empty -> Balance is [LOADING]
  // isNotEmpty -> App has gotten value

  late Bank bank;
  late String accountName;
  late String accountNumber;
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
  // final transactions = <Transaction>[
  //   /*  Transaction(
  //     amount: 3000,
  //     senderName: 'Sample account name',
  //     description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
  //     createdAt: DateTime.now(),
  //     updatedAt: DateTime.now(),
  //     bank: kBank,
  //   ),
  //   Transaction(
  //     amount: 45000,
  //     senderName: '45000',
  //     description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
  //     createdAt: DateTime.now(),
  //     updatedAt: DateTime.now(),
  //     bank: kBank,
  //   ),
  //   Transaction(
  //     amount: 3000,
  //     senderName: 'Sample account name',
  //     description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
  //     createdAt: DateTime.now(),
  //     updatedAt: DateTime.now(),
  //     bank: kBank,
  //   ),
  //   Transaction(
  //     amount: 3000,
  //     senderName: 'Sample account name',
  //     description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
  //     createdAt: DateTime.now(),
  //     updatedAt: DateTime.now(),
  //     bank: kBank,
  //   ),
  //   Transaction(
  //     amount: 3000,
  //     senderName: 'Sample account name',
  //     description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
  //     createdAt: DateTime.now(),
  //     updatedAt: DateTime.now(),
  //     bank: kBank,
  //   ),
  //   Transaction(
  //     amount: 3000,
  //     senderName: 'Sample account name',
  //     description: 'KIP:PAP/Palmpay - Kaosara/Palmpay - Kaosara Amus',
  //     createdAt: DateTime.now(),
  //     updatedAt: DateTime.now(),
  //     bank: kBank,
  //   ), */
  // ].obs;
  final amountController = TextEditingController(text: '₦0.00');
  final descriptionController = TextEditingController();

  final isButtonEnabled = false.obs;

  @override
  void onInit() {
    print(Get.arguments);
    bank = Get.arguments['bank'];
    accountName = Get.arguments['accountName'];
    accountNumber = Get.arguments['accountNumber'];
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
    //_fetchBalance();
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

  isSender(Transaction chats) => chats.recipientName == accountName;

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

      AuthRepository.instance
          .makePayment(
        number: accountNumber,
        bank: bank.name,
        account_name: accountName,
        amount: unfomartedAmount.value.toString(),
        narration: descriptionController.text,
      )
          .then((msg) {
        // Success
        showMessage('Successful', clear: true);
        addMessage();
      }).catchError((err, stackTrace) {
        if (err is! String) {
          err = err.toString();
        }
        // Error
        showError(err, clear: true);
      });
    }
  }

  void addMessage() {
    user.value = user.value.copyWith(
      transactions: [
        ...user.value.transactions,
        Transaction(
          amount: unfomartedAmount.value,
          recipientName: accountName,
          senderName: accountName,
          description: descriptionController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          bank: bank,
        ),
      ],
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
    AuthRepository.instance.fetchBalance().then((freshWallet) {
      // Success
      // balance.value = freshWallet.balance;
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
