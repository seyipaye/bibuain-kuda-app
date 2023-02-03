/* // ignore_for_file: unnecessary_null_comparison

// To parse this JSON data, do
//
//     final vouchers = vouchersFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'core/app_routes.dart';
import 'core/extentions.dart';
import 'data/communication/conversation_model.dart';
import 'data/home/home_category.dart';
import 'data/user/user.dart';
import 'domain/providers/app_api_provider.dart';
import 'domain/providers/local_notification_service.dart';
import 'domain/repositories/app_repo.dart';
import 'domain/repositories/auth_repo.dart';
import 'presentation/modules/comunication/communication_controller.dart';
import 'presentation/modules/customers/order/order_controller.dart';
import 'presentation/modules/drawer/drawer_controller.dart';
import 'presentation/utils/constants.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Vouchers vouchersFromJson(String str) => Vouchers.fromJson(json.decode(str));

String vouchersToJson(Vouchers data) => json.encode(data.toJson());

class Vouchers {
  Vouchers({
    this.id,
    this.code,
    this.type,
    this.expiryDate,
    this.discount,
    this.priceCap,
  });

  final String? id;
  final String? code;
  final String? type;
  final DateTime? expiryDate;
  final int? discount;
  final int? priceCap;

  factory Vouchers.fromJson(Map<String, dynamic> json) => Vouchers(
        id: json["_id"] == null ? null : json["_id"],
        code: json["code"] == null ? null : json["code"],
        type: json["type"] == null ? null : json["type"],
        expiryDate: json["expiryDate"] == null
            ? null
            : DateTime.parse(json["expiryDate"]),
        discount: json["discount"] == null ? null : json["discount"],
        priceCap: json["priceCap"] == null ? null : json["priceCap"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "code": code == null ? null : code,
        "type": type == null ? null : type,
        "expiryDate": expiryDate == null ? null : expiryDate!.toIso8601String(),
        "discount": discount == null ? null : discount,
        "priceCap": priceCap == null ? null : priceCap,
      };
}

enum HomepageTab { all, near_you, newly_added, pocket, discount, most_rated }

class HomeScreenController extends GetxController
    with StateMixin<List<HomeCategory>> {
  final _selectedPage = 0.obs;

  final homepage = HomepageTab.all.obs;
  final isLoading = true.obs;
  final contents = <HomeCategory>[].obs;
  final isNotificationSet = false.obs;
  final notificationList = [].obs;
  final cartItem = 0.obs;

  final refreshKey = GlobalKey<RefreshIndicatorState>();

  static HomeScreenController get instance => Get.find<HomeScreenController>();

  Rx<User> get user => AuthRepository.instance.user;

  int get selectedPage => _selectedPage.value;

  set selectedPage(page) => _selectedPage.value = page;

  final formKey = GlobalKey<FormState>();

  void navigateToOrders() {
    _selectedPage.value = 2;
    doAfterBuild(() {
      OrderController.instance.refreshIndicatorKey.currentState?.show();
    });
  }

  final Rx<List<String>> _tabList = Rx([
    '  All  ',
    'Near You',
    'Newly Added',
    'Pocket-friendly',
    'Discounted dishes',
    //'Most Rated'
  ]);

  Rx<String?> selectedTab = Rx(null);

  RxInt selectedIndex = 0.obs;

  List<String> get tabList => _tabList.value;

  final homeDetails = Rx<HomeCategory?>(null);
  final allHomeData = [].obs;
  final nearbyVendors = [].obs;
  final allVendors = [].obs;
  final trendingVendors = [].obs;
  final mostRated = [].obs;
  final newlyAddedVendors = <HomeCategory>[].obs;
  final voucherDetails = [].obs;
  final allPocketFriendly = <HomeCategory>[].obs;
  final availableDiscount = [].obs;
  final availableDiscountDish = <HomeCategory>[].obs;
  final Rx<List<HomeCategory>> homedata = Rx([]);

  final carouselSliderList = [].obs;
  late String restaurantName;
  late String restaurantLocation;
  final restaurantNameController = TextEditingController();
  final restaurantLocationController = TextEditingController();

  void toggle(int index) {
    if (index == 0) {
      homepage.value = HomepageTab.all;
    } else if (index == 1) {
      homepage.value = HomepageTab.near_you;
    } else if (index == 2) {
      homepage.value = HomepageTab.newly_added;
    } else if (index == 3) {
      homepage.value = HomepageTab.pocket;
    } else {
      homepage.value = HomepageTab.discount;
    }
    selectedIndex.value = index;
    update();
  }

  Future<void> fetchData() async {
    fetchHomeDetailPage();
    fetchAllVendors();
    fetchNearbyVendors();
    fetchPocketFriendly();
    fetchDiscountedDishes();
    fetchCartLength();
    fetchTrendingVendors();
    fetchNewlyAdded();
    fetchVoucherDetails();
  }
//  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

//adb shell setprop debug.firebase.analytics.app africa.foodelo.hybrid
  @override
  void onInit() async {
    Get.put(AppDrawerController());

    fetchData();
    _initNotification();

    //checkCustomer();
    super.onInit();
    LocalNotificationService.initialize(Get.context!);
    startSocket();
  }

  void _initNotification() async {
    //FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    setupToken();

    setupInteractedMessage();

    await FirebaseMessaging.instance.subscribeToTopic('foodelo-customer');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Foreground Notification for Android

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      log(notification?.toMap().toString() ?? 'No notification');
      Sentry.captureMessage(
          notification?.toMap().toString() ?? 'No notification');

      debugPrint(
          '######### the foreground notification ${message.notification!.title}');

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        LocalNotificationService.display(message);
      }
    });
  }

  void fetchAllVendors() async {
    try {
      final response = await AppRepository.instance.fetchAllVendors();

      if (response.length != 0) {
        allVendors.assignAll(response);
        //homedata([]);
        //homedata(response);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void fetchNearbyVendors() async {
    try {
      final response = await AppRepository.instance.fetchNearbyVendors();

      if (response.length != 0) {
        nearbyVendors.assignAll(response);
        homedata([]);
        homedata(response);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void fetchNewlyAdded() async {
    try {
      final response = await AppRepository.instance.fetchNewlyAdded();

      if (response.length != 0) {
        newlyAddedVendors.assignAll(response.reversed);
        // homedata([]);
        //homedata(response);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void fetchTrendingVendors() async {
    try {
      final response = await AppRepository.instance.fetchTrendingVendors();

      if (response.length != 0) {
        trendingVendors.assignAll(response);
        //homedata([]);
        //homedata(response);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  final voucher = Vouchers().obs;

  void fetchVoucherDetails() async {
    try {
      final response = await AppRepository.instance.fetchVouchers();

      if (response.length != 0) {
        voucherDetails.assignAll(response);
        homedata([]);
        voucher.value = response[0];
        // homedata(response);
        //carouselSliderList.assign(voucher.value);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void fetchDiscounts() async {
    try {
      final response = await AppRepository.instance.fetchDiscounts();

      if (response.length != 0) {
        availableDiscount.assignAll(response);
        homedata([]);
        homedata(response);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void suggestRestaurant() async {
    FocusManager.instance.primaryFocus!.unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }
    showLoadingState;
    formKey.currentState!.save();
    try {
      final response = await AppRepository.instance
          .suggestRestaurant(restaurantName, restaurantLocation);

      if (response != null) {
        Get.back();
        showMessage(response);
        restaurantNameController.clear();
        restaurantLocationController.clear();
        toggle(0);
      }
    } catch (e) {
      Get.back();
      debugPrint(e.toString());
    }
  }

  final isDisLoading = false.obs;

  void fetchDiscountedDishes() async {
    isDisLoading(true);
    try {
      final response = await AppRepository.instance.fetchDiscountedDishes();

      if (response.length != 0) {
        print('NA THE LENGTH  IS: ${response.length}');
        availableDiscountDish.assignAll(response!);
        homedata([]);
        homedata(response);
        isDisLoading(false);
      }
    } catch (e) {
      isDisLoading(false);
      debugPrint(e.toString());
    }
  }

  void fetchPocketFriendly() async {
    try {
      final response = await AppRepository.instance.fetchPocketFriendly();

      if (response.length != 0) {
        allPocketFriendly.assignAll(response);
        homedata([]);
        homedata(response);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void checkCustomer() async {
    if (AppDrawerController
        .instance.user.value.customerProfile!.savedAddresses!.isEmpty) {
      await Future.delayed(Duration(seconds: 1));
      Get.toNamed(Routes.locationPrompt);
    }
  }

  void startSocket() {
    AppProvider.value.initSocket();
  }

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> setupToken() async {
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();

    debugPrint('#### FCM token $token!');
    // Save the initial token to the database
    await saveTokenToDatabase(token!);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    try {
      final response = await AppRepository.instance.uploadToken(token);

      if (response != null) {
        debugPrint(response);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handleMessage(RemoteMessage message) {
    debugPrint('How messsssshgete he');
    log('Handle notification tap: ${message.toMap().toString()}');
    Sentry.captureMessage(
        'Handle notification tap: ${message.toMap().toString()}');

    if (message.data['type'] == 'order') {
      Get.toNamed(Routes.orderSummary, arguments: message.data['orderId']);
    } else if (message.data['type'] == 'transaction') {
      Get.toNamed(Routes.wallet);
    } else if (message.data['type'] == 'chat-conversation') {
      final convo = Conversations(
          riderId: RiderId(
              id: '638de3ef31340c5b655bd580',
              firstName: message.data['senderName'],
              image: message.data['image']),
          user: 'Customer',
          userId: UserId(iid: AppDrawerController.instance.userId.value));
      Get.put(CommunicationController());

      Get.toNamed(Routes.chatBox, arguments: [convo, message.data['phone']]);
    } else {
      return;
      //Get.toNamed(Routes.notifications);
    }
  }

  Future<void> fetchHomeDetailPage() async {
    change(null, status: RxStatus.loading());

    try {
      AppRepository.instance.fetchHomePageDetails().then((newValue) {
        if (newValue.length == 0 || newValue[0].items.length == 0) {
          change(null, status: RxStatus.empty());
        } else {
          change(newValue, status: RxStatus.success());
          allHomeData.assignAll(newValue);
          homedata([]);
          homedata(newValue);
          //cartItem.value =

        }
      }, onError: (err) {
        debugPrint(err.toString());
        if (err is String)
          change(state, status: RxStatus.error(err.toString()));
      });
    } catch (e) {
      change(null, status: RxStatus.error());
    }
  }

  void fetchCartLength() async {
    final response = await AppRepository.instance.fetchCartLength();
    if (response != null) {
      cartItem.value = response;

      debugPrint('++++++++ ${cartItem.value}');
    }
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
 */