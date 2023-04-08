import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bibuain_pay/core/extentions.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../core/app_routes.dart';
import '../../../data/user/user.dart';
import '../../../domain/repositories/auth_repo.dart';
import '../../utils/colors.dart';

class HomeScreenController extends GetxController {
  final _selectedPage = 0.obs;

  final isLoading = true.obs;
  final isNotificationSet = false.obs;
  final notificationList = [].obs;

  final refreshKey = GlobalKey<RefreshIndicatorState>();

  static HomeScreenController get instance => Get.find<HomeScreenController>();

  Rx<User> get user => AuthRepository.instance.user;

  int get selectedPage => _selectedPage.value;

  set selectedPage(page) => _selectedPage.value = page;

  final formKey = GlobalKey<FormState>();

  Future<void> fetchData() async {}
//  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

//adb shell setprop debug.firebase.analytics.app africa.foodelo.hybrid
  @override
  void onInit() async {
    fetchData();
    super.onInit();
  }

  final loading = false.obs;

  Future<void> fetchHomeDetailPage() async {
    // try {
    //   AppRepository.instance.fetchHomePageDetails().then((newValue) {
    //     if (newValue.length == 0 || newValue[0].items.length == 0) {
    //       change(null, status: RxStatus.empty());
    //     } else {
    //       change(newValue, status: RxStatus.success());
    //       allHomeData.assignAll(newValue);
    //       homedata([]);
    //       homedata(newValue);
    //       //cartItem.value =

    //     }
    //   }, onError: (err) {
    //     debugPrint(err.toString());
    //     if (err is String)
    //       change(state, status: RxStatus.error(err.toString()));
    //   });
    // } catch (e) {
    //   change(null, status: RxStatus.error());
    // }
  }

  Future<void> onAddressPressed() async {
    final successful = await Get.toNamed(Routes.newAddress);

    if (successful == true) {
      fetchData();
    }

    /* if (AppDrawerController.instance.addressLine.value.isEmpty) {
      Get.toNamed(Routes.newAddress);
    } else {
      Get.toNamed(Routes.savedAddress);
    }*/
  }
}

class HomePageController extends GetxController {
  Rx<User> get user => AuthRepository.instance.user;
  final balance = RxnDouble();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void onInit() {
    _fetchBalance();
    super.onInit();
  }

  void refresh() => _fetchBalance();

  void _fetchBalance() {
    AuthRepository.instance.fetchBalance().then((value) {
      // Success
      balance.value = double.tryParse(value) ?? 0.0;
    }).catchError((err, stackTrace) {
      if (err is! String) {
        err = err.toString();
      }
      // Error
      showError(err);
    });
  }
}

class ItemController extends GetxController {
  final color = Rxn<Color>(AppColors.primary.shade100);
  final String logo;
  late ImageProvider imageProvider;

  ItemController(this.logo);

  @override
  void onInit() async {
    imageProvider = NetworkImage(logo, scale: 0.0001);

    PaletteGenerator.fromImageProvider(
      imageProvider,
      size: Size(20, 20), // optional
      maximumColorCount: 3, // optional
    ).then(
      (value) {
        color.value = value.dominantColor?.color.withOpacity(0.3);
        update();
      },
    );
    super.onInit();
  }
}
