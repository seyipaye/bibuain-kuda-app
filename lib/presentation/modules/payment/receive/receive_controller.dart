import 'package:get/get.dart';
import 'package:swift_pay_mobile/core/extentions.dart';

import '../../../../core/app_routes.dart';
import '../../../../data/user/user.dart';
import '../../../../domain/repositories/auth_repo.dart';

class ReceiveController extends GetxController {
  final balance = 0.0.obs;
  final wallet = Rxn<Wallet>();
  Rx<User> get user => AuthRepository.instance.user;

  @override
  void onInit() {
    _fetchBalance();
    super.onInit();
  }

  void refresh() => _fetchBalance();

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

  void recievePayment() => Get.toNamed(Routes.receivePayment);
}
