import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/app_routes.dart';
import 'domain/app_shared_prefs.dart';
import 'domain/providers/auth_api_provider.dart';
import 'domain/repositories/app_repo.dart';
import 'domain/repositories/auth_repo.dart';
import 'presentation/utils/theme.dart';

var initialRoute = Routes.signup;
final appDebugMode = false.obs;

Future _initializeUser() async {
  // Create App Sheared Pref
  Get.put<AppSharedPrefs>(await AppSharedPrefs.create());
  // Check if there is a User
  final user = AppSharedPrefs.instance.user;
  if (user != null) {
    // if (user.type == UserType.vendor && user.vendorProfile != null ||
    //     user.unverifiedVendorProfile != null) {
    //   initialRoute = Routes.dashboard;
    // } else if (user.type == UserType.customer && user.customerProfile != null) {
    //   initialRoute = Routes.home;
    // } else
    //   initialRoute = Routes.customerTypeScreen;

    // if ((user.sureEmail?.contains('@foodelo.africa') ?? false))
    //   appDebugMode.value = true;
  }
}

/* Future _initializeFirebase() async {
  await Firebase.initializeApp();
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  //FirebaseAnalytics analytics = await FirebaseAnalytics.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//Firebase messaging
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await FirebaseMessaging.instance.subscribeToTopic('foodelo');

  //TODO remove
  // Only call clearSavedSettings() during testing to reset internal values.
}
 */

/* Future _initializeSentry() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://40c3e5ff231b41fd81b72c4336a08dca@o1418010.ingest.sentry.io/6762501';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );
} */

/* // firebase background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('A Background message just showed up :  ${message.messageId}');
  debugPrint('A Background message for :  ${message.data['user']}');

  log('Background notification: ${message.toMap().toString()}');
  Sentry.captureMessage(
      'Background notification: ${message.toMap().toString()}');

  //LocalNotificationService.vendorDisplay(message);
  /* if (message.data['user'] == "Vendor")
    LocalNotificationService.vendorDisplay(message);
  else*/
  LocalNotificationService.display(message);
} */

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // await _initializeFirebase();

  await _initializeUser();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    appDebugMode.value = kDebugMode;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Swift Pay',
      debugShowCheckedModeBanner: false,
      //initialRoute: Routes.customerTypeScreen,
      initialRoute: initialRoute,
      initialBinding: BindingsBuilder(
        () {
          // It is mandatory for all of these to be initialized for the effectual running of the app

          // T for Thanks

          /*
          Please note:
          Auth Repository & Provider are stand alone
          App Repository & Provider depends on them 
          */

          Get.put<AuthRepository>(AuthRepository(), permanent: true);
          Get.put<AppRepository>(AppRepository(), permanent: true);
          Get.lazyPut<AuthProvider>(() => AuthProvider(), fenix: true);
        },
      ),
      getPages: AppPages.routes,
      theme: getLightTheme(),
    );
  }
}
