import 'package:get/get.dart';
import 'package:swift_pay_mobile/presentation/modules/payment/pay/scan_controller.dart';
import 'package:swift_pay_mobile/presentation/modules/payment/pay/payment_screen.dart';
import 'package:swift_pay_mobile/presentation/modules/payment/pay/scan_screen.dart';
import 'package:swift_pay_mobile/presentation/modules/payment/transfer_chat/transfer_chat_screen.dart';
import '../domain/repositories/app_repo.dart';
import '../presentation/modules/auth/login/login_controller.dart';
import '../presentation/modules/auth/login/login_screen.dart';
import '../presentation/modules/auth/signup/signup_controller.dart';
import '../presentation/modules/auth/signup/signup_screen.dart';
import '../presentation/modules/home/home_controller.dart';
import '../presentation/modules/home/home_screen.dart';
import '../presentation/modules/payment/offline_payment/offline_payment_controller.dart.dart';
import '../presentation/modules/payment/offline_payment/offline_payment_screen.dart';
import '../presentation/modules/payment/offline_payment/qr_code_screen.dart';
import '../presentation/modules/payment/pay/payment_controller.dart';
import '../presentation/modules/payment/transfer_chat/transfer_chat_controller.dart';
import '../presentation/modules/payment/top-up/top_up_controller.dart';
import '../presentation/modules/payment/top-up/top_up_screen.dart';

class Routes {
  // Auth
  static const splash = '/';
  static const login = '/login';
  static const resetPassword = '/resetPassword';
  static const signup = '/signup';
  static const otp = '/otp';
  static const passwordOtp = '/passwordOtp';
  static const pinOtp = '/pinOtp';
  static const customerTypeScreen = '/customerTypeScreen';

  // Home
  static const home = '/home';
  static const homeSection = '/homeSection';
  static const transferChat = '/transferChat';
  static const newRecipient = '/newRecipient';
  static const makePayment = '/makePayment';
  static const topUp = '/topUp';
  static const offlinePay = '/offlinePay';
  static const offlineQrView = '/offlineQrView';
  static const offlineScan = '/offlineScan';

  static const profilePrompt = '/profilePrompt';
  static const profileSetup = '/resturantProfile';
  static const profileVerifying = '/profileVerifying';
  static const newPassword = '/newPassword';
  static const dashboard = '/dashboard';

  //Orders
  static const orders = '/orders';
  static const groupOrders = '/groupOrders';
  static const orderDetails = '/orderDetails';
  static const orderSummary = '/orderSummary';
  static const trackOrder = '/trackOrder';
  static const orderReceipt = '/orderReceipt';
  static const cancelOrder = '/cancelOrder';

  // Menus
  static const menu = '/menuScreen';
  static const addMenu = '/addMenuScreen';
  static const addMenuItem = '/addMenuItme';
  static const newMenuItem = '/newMenuItem';
  static const menuItemDetails = '/menuItemDetails';
  static const addOn = '/addOn';
  static const addChoice = '/addChoice';
  static const addSingleChoice = '/addSingleChoice';
  static const dishDetails = '/dishDetails';
  static const newMenuCategory = '/newMenuCategory';

  // Wallet
  static const wallet = '/wallet';
  static const transactions = '/transactions';
  static const earnings = '/earnings';

  static const withdrawal = '/withdrawal';

  // Order history
  static const history = '/history';

  // Settings
  static const settings = '/settings';
  static const editProfile = '/editProfile';
  static const changePassword = '/changePassword';
  static const withdrawalPin = '/withdrawalPin';
  static const withdrawalAccount = '/withdrawalAccount';
  static const deleteAccount = '/deleteAccount';

  // Resturant
  static const resturant = '/resturant';
  static const dish = '/foodDescription';
  static const fave = '/fave';
  static const manageRestaurant = '/manageRestaurant';
  static const manageRestaurantII = '/manageRestaurantII';

  // Checkout
  static const checkout = '/checkout';
  static const cart = '/cart';

  // Payment
  static const payment = '/payment';

  // Location
  static const savedAddress = '/savedAddress';
  static const newAddress = '/newAddress';
  static const locationPrompt = '/locationPrompt';

  // Customer Orders
  static const customerOrder = '/customerOrder';
  static const customerOrders = '/customerOrders';

  // Filter
  static const dashboardFilter = '/dashboardFilter';
  static const ordersFilter = '/ordersFilter';
  static const searchFilter = '/searchFilter';

  // Communication
  static const calling = '/calling';
  static const chatBox = '/chatBox';
  static const chat = '/chat';

  // Others
  static const notifications = '/notifications';
  static const ratings = '/ratings';
  static const riderRatings = '/riderRratings';
  static const reviews = '/reviews';
  static const helpCenter = '/helpCenter';
  static const exphelpCenter = '/exphelpCenter';
  static const share = '/share';
  static const restaurantRating = '/restaurantRating';
}

class AppPages {
  AppPages._();

  static final routes = [
    //   GetPage(
    //       name: Routes.share,
    //       page: () => InviteFriendScreen(),
    //       binding: BindingsBuilder(() {
    //         Get.put(InviteFriendScreen());
    //       })),
    //   GetPage(
    //     name: Routes.splash,
    //     page: () => SplashScreen(),
    //   ),
    //   GetPage(
    //     name: Routes.fave,
    //     page: () => FavouriteScreen(),
    //   ),
    //   GetPage(
    //     name: Routes.customerTypeScreen,
    //     page: () => UserTypeScreen(),
    //   ),
    GetPage(
        name: Routes.login,
        page: () => LoginScreen(),
        binding: BindingsBuilder(() {
          Get.put(LoginController());
        })),
    //   GetPage(
    //       name: Routes.resetPassword,
    //       page: () => ResetPasswordScreen(),
    //       binding: BindingsBuilder(() {
    //         Get.put(PasswordController());
    //       })),
    GetPage(
      name: Routes.signup,
      page: () => SignupScreen(),
      binding: BindingsBuilder(() {
        Get.put(SignupController());
      }),
    ),
    //   GetPage(
    //     name: Routes.otp,
    //     page: () => OtpScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(OtpController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.passwordOtp,
    //     page: () => ResetPasswordOtpScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(OtpController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.pinOtp,
    //     page: () => PinOtpScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(PinOtpController());
    //     }),
    //   ),
    GetPage(
      name: Routes.home,
      page: () => HomeScreen(),
      transition: Transition.circularReveal,
      binding: BindingsBuilder(() {
        Get.put(AppRepository());
        Get.put(HomeScreenController());
        Get.put(HomePageController());
        Get.lazyPut(() => PaymentController());
      }),
    ),
    GetPage(
      name: Routes.transferChat,
      page: () => TransferChatScreen(),
      transition: Transition.circularReveal,
      binding: BindingsBuilder(() {
        Get.put(TransferChatController());
      }),
    ),

    GetPage(
      name: Routes.newRecipient,
      page: () => NewRecipientScreen(),
      transition: Transition.circularReveal,
      binding: BindingsBuilder(() {
        Get.put(NewRecipientController());
      }),
    ),
    GetPage(
      name: Routes.makePayment,
      page: () => PayPage(),
      transition: Transition.zoom,
      binding: BindingsBuilder(() {
        // Get.put(PaymentController());
      }),
    ),
    GetPage(
      name: Routes.topUp,
      page: () => TopUpScreen(),
      // transition: Transition.zoom,
      binding: BindingsBuilder(() {
        Get.put(TopUpController());
      }),
    ),
    GetPage(
      name: Routes.offlinePay,
      page: () => OfflinePaymentScreen(),
      // transition: Transition.zoom,
      binding: BindingsBuilder(() {
        Get.put(OfflinePaymentController());
      }),
    ),
    GetPage(
      name: Routes.offlineQrView,
      page: () => QrCodeScreen(),
      binding: BindingsBuilder(() {
        Get.put(OfflinePaymentController());
      }),
    ),
    //   GetPage(
    //     name: Routes.homeSection,
    //     page: () => HomeCategoryScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(HomeScreenController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.homeSection,
    //     page: () => RestaurantRatingScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(HomeScreenController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.profilePrompt,
    //     page: () => ProfilePromptScreen(),
    //   ),
    //   GetPage(
    //     name: Routes.profileSetup,
    //     page: () => ProfileSetupScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(ProfileSetupController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.profileVerifying,
    //     page: () => ProfileVerifyingScreen(),
    //   ),
    //   GetPage(
    //     name: Routes.newPassword,
    //     page: () => NewPasswordScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(PasswordController());
    //     }),
    //   ),
    //   GetPage(
    //       name: Routes.dashboard,
    //       page: () => DashboardScreen(),
    //       transition: Transition.circularReveal,
    //       binding: BindingsBuilder(() {
    //         Get.put(AppRepository());
    //         Get.put(
    //           DashboardController(),
    //         );
    //         //Get.put(AppDrawerController(),);
    //       })),

    //   // Orders

    //   GetPage(
    //     name: Routes.orders,
    //     page: () => VendorOrdersScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(VendorOrderController());
    //     }),
    //   ),

    //   GetPage(
    //     name: Routes.groupOrders,
    //     page: () => GroupOrderScreen(),
    //     binding: BindingsBuilder(() {
    //       //Get.put(VendorOrderController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.orderDetails,
    //     page: () => VendorOrderDetailsScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(VendorOrderController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.orderSummary,
    //     page: () => OrderSummaryScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(OrderSummaryController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.trackOrder,
    //     page: () => TrackOrderScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(TrackOrderController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.orderReceipt,
    //     page: () => OrderReceiptScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(OrderSummaryController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.cancelOrder,
    //     page: () => CancelOrderConfirmation(),
    //     binding: BindingsBuilder(() {
    //       Get.put(OrderDetailController());
    //     }),
    //   ),

    //   GetPage(
    //       name: Routes.menu,
    //       page: () => ListMenuScreen(),
    //       binding: BindingsBuilder(() {
    //         Get.put(MenuuController());
    //       })),
    //   GetPage(
    //       transition: Transition.leftToRight,
    //       name: Routes.menuItemDetails,
    //       page: () => DishItemDetailScreen(),
    //       binding: BindingsBuilder(() {
    //         Get.put(DishDetailController());
    //       })),
    //   GetPage(
    //       name: Routes.newMenuItem,
    //       page: () => NewMenuItem(),
    //       binding: BindingsBuilder(() {
    //         Get.put(NewMenuController());
    //         Get.put(ComboController());
    //       })),
    //   GetPage(
    //       name: Routes.addMenu,
    //       page: () => AddMenu(),
    //       binding: BindingsBuilder(() {
    //         Get.put(NewMenuController());
    //         // Get.put(ComboController());
    //       })),
    //   GetPage(
    //       name: Routes.addMenuItem,
    //       page: () => AddMenuItem(),
    //       binding: BindingsBuilder(() {
    //         Get.put(NewMenuController());
    //       })),
    //   GetPage(
    //       name: Routes.addChoice,
    //       page: () => AddChoice(),
    //       binding: BindingsBuilder(() {
    //         Get.put(AddChoiceController());
    //       })),
    //   GetPage(
    //       name: Routes.addSingleChoice,
    //       page: () => AddSingleChoice(),
    //       binding: BindingsBuilder(() {
    //         Get.put(AddChoiceController());
    //       })),
    //   GetPage(
    //       name: Routes.dishDetails,
    //       page: () => MenuDetailScreen(),
    //       binding: BindingsBuilder(() {
    //         Get.put(MenuDetailController());
    //       })),
    //   GetPage(
    //     name: Routes.addOn,
    //     page: () => NewAddOnScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(AddOnController());
    //     }),
    //   ),

    //   /* GetPage(
    //     name: Routes.newMenuCategory,
    //     page: () => NewMenuCategoryScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(MenuDetailController());
    //     }),
    //   ),*/

    //   // Wallet
    //   GetPage(
    //     name: Routes.wallet,
    //     page: () => WalletScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(WalletController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.transactions,
    //     page: () => TransactionsScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(TransactionsController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.earnings,
    //     page: () => EarningsScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(EarningsController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.withdrawal,
    //     page: () => WithdrawalScreen(),
    //   ),

    //   // Order history
    //   GetPage(
    //     name: Routes.history,
    //     page: () => HistoryScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(VendorOrderController());
    //     }),
    //   ),

    //   // Settings
    //   GetPage(
    //     name: Routes.settings,
    //     page: () => SettingsScreen(),
    //   ),

    //   GetPage(
    //     name: Routes.editProfile,
    //     page: () => EditProfileScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(EditProfileController());
    //     }),
    //   ),

    //   GetPage(
    //     name: Routes.changePassword,
    //     page: () => ChangePasswordScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(PasswordController());
    //     }),
    //   ),

    //   GetPage(
    //     name: Routes.withdrawalPin,
    //     page: () => WithdrawalPinScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(WithdrawalPinController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.withdrawalAccount,
    //     page: () => WithdrawalAccountScreen(),
    //   ),
    //   GetPage(
    //     name: Routes.deleteAccount,
    //     page: () => DeleteAccount(),
    //   ),

    //   // Resturant
    //   GetPage(
    //     name: Routes.resturant,
    //     page: () => RestaurantScreen(),
    //     // page: () => ResturantScreen(),
    //     // page: () => NewResturantScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(RestaurantController());
    //     }),
    //   ),

    //   GetPage(
    //     name: Routes.dish,
    //     page: () => DishScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(DishController());
    //     }),
    //   ),

    //   GetPage(
    //     name: Routes.checkout,
    //     page: () => CheckoutScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(CheckOutController());
    //     }),
    //   ),

    //   GetPage(
    //     name: Routes.cart,
    //     page: () => CartScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(CartController());
    //     }),
    //   ),

    //   GetPage(
    //     name: Routes.payment,
    //     page: () => PaymentScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(PaymentController());
    //     }),
    //   ),

    //   GetPage(
    //     name: Routes.manageRestaurant,
    //     page: () => ManageRestaurantOptionScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(ManageRestaurantController());
    //     }),
    //   ),

    //  /* GetPage(
    //     name: Routes.manageRestaurantII,
    //     page: () => ManageRestaurantSecondPage(),
    //     // binding: BindingsBuilder(() {
    //     //   Get.put(PaymentController());
    //     // }),
    //   ),*/

    //   // Location
    //   GetPage(
    //     name: Routes.locationPrompt,
    //     page: () => LocationPrompt(),
    //     binding: BindingsBuilder(() {
    //       Get.put(AddressController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.newAddress,
    //     page: () => NewAddressScreen(),
    //     binding: BindingsBuilder(() {
    //       //Get.put(AddressController());
    //       Get.put(NewAddressController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.savedAddress,
    //     page: () => SavedAddressesScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(AddressController());
    //     }),
    //   ),

    //   // Customer Orders
    //   GetPage(
    //     name: Routes.customerOrders,
    //     page: () => OrdersPage(),
    //     binding: BindingsBuilder(() {
    //       Get.put(RestaurantController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.customerOrder,
    //     page: () => OrderScreenDetail(),
    //     binding: BindingsBuilder(() {
    //       Get.put(OrderDetailController());
    //     }),
    //   ),

    //   // Filter
    //   GetPage(
    //     name: Routes.searchFilter,
    //     page: () => FilterScreen(),
    //   ),
    //   GetPage(
    //     name: Routes.dashboardFilter,
    //     page: () => DashboardFilter(),
    //   ),
    //   GetPage(
    //     name: Routes.ordersFilter,
    //     page: () => OrdersFilter(),
    //   ),

    //   // Notifications
    //   GetPage(
    //     name: Routes.notifications,
    //     page: () => NotificationsScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(NotificationController());
    //     }),
    //   ),

    //   // Communication
    //   GetPage(
    //     name: Routes.calling,
    //     page: () => CallingScreen(),
    //   ),

    //   GetPage(
    //     name: Routes.chatBox,
    //     page: () => ChatBoxScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(ChatMessageController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.chat,
    //     page: () => ChatScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(CommunicationController());
    //     }),
    //   ),

    //   // Others
    //   GetPage(
    //     name: Routes.ratings,
    //     page: () => RatingsScreen(),
    //     binding: BindingsBuilder(() {
    //       //Get.put(RatingController());
    //     }),
    //   ),

    //   GetPage(
    //     name: Routes.riderRatings,
    //     page: () => RiderRatingScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(RatingController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.reviews,
    //     page: () => ReviewsScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(ReviewController());
    //     }),
    //   ),
    //   GetPage(
    //     name: Routes.helpCenter,
    //     page: () => HelpCenterScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(ContactSupportController());
    //     }),
    //   ),

    //   GetPage(
    //     name: Routes.exphelpCenter,
    //     page: () => ExpandedPage(),
    //   ),
    //   GetPage(
    //     name: Routes.restaurantRating,
    //     page: () => RestaurantRatingScreen(),
    //     binding: BindingsBuilder(() {
    //       Get.put(HomeScreenController());
    //     }),
    //   ),
  ];
}
