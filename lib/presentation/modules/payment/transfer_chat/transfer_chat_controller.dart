import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swift_pay_mobile/core/extentions.dart';

import '../../../../core/app_routes.dart';
import '../../../../data/bank/bank.dart';
import '../../../../data/chat/chat_message_model.dart';
import '../../../../data/user/user.dart';
import '../../../../domain/repositories/auth_repo.dart';

class TransferChatController extends GetxController {
  final balance = 0.0.obs;
  final wallet = Rxn<Wallet>();
  Rx<User> get user => AuthRepository.instance.user;
  late Bank bank;
  late String accountName;

  final ScrollController scrollController = ScrollController();
  final chatMessagesList = [
    Chats(
      id: 'fdfd',
      riderId: 'sdsdsd',
      user: 'dfdff',
      conversationId: 'ereerer',
      sender: 'dfdfdfdf',
      message: 'dfasasas',
      createdAt: '2022-09-09T08:23:38.649Z',
      updatedAt: '2022-09-09T08:23:38.649Z',
    ),
    Chats(
      id: 'fdfd',
      riderId: 'sdsdsd',
      user: 'dfdff',
      conversationId: 'ereerer',
      sender: 'dfdfdfdf',
      message: 'dfasasas',
      createdAt: '2022-09-09T08:23:38.649Z',
      updatedAt: '2022-09-09T08:23:38.649Z',
    ),
  ].obs;
  final replyController = TextEditingController();

  @override
  void onInit() {
    print(Get.arguments);
    bank = Get.arguments['bank'];
    accountName = Get.arguments['accountName'];
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

  @override
  void onReady() {
    if (scrollController.hasClients) //do your stuff here

      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void sendMessage(String message) {
    // if (AppProvider.value.sockett.disconnected) {
    //   AppProvider.value.sockett.connect();
    // }

    // debugPrint('im seending message to rider id ${riderId.value}');
    // AppProvider.value.sockett.emit(
    //   "message",
    //   {
    //     "riderId": riderId.value,
    //     "user": userType.value,
    //     "userId": userId.value,
    //     "sender": 'User',
    //     "message": message,
    //   },
    // );
  }

  void _fetchBalance() {
    AuthRepository.instance.fetchWallet().then((freshWallet) {
      // Success
      balance.value = freshWallet.balance;
      wallet.value = freshWallet;
    }).catchError((err, stackTrace) {
      if (err is! String) {
        err = err.toString();
      }
      // Error
      showError(err);
    });
  }

  Future<void> offlinePayment() async {
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
}
