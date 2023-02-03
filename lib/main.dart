import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/app_routes.dart';

var initialRoute = Routes.onboarding;
final appDebugMode = false.obs;

/* Future _initializeUser() async {
  // Create App Sheared Pref
  Get.put<AppSharedPrefs>(await AppSharedPrefs.create());
  // Check if there is a User
  final user = AppSharedPrefs.instance.user;
  if (user != null) {
    if (user.type == UserType.vendor && user.vendorProfile != null ||
        user.unverifiedVendorProfile != null) {
      initialRoute = Routes.dashboard;
    } else if (user.type == UserType.customer && user.customerProfile != null) {
      initialRoute = Routes.home;
    } else
      initialRoute = Routes.customerTypeScreen;

    if ((user.sureEmail?.contains('@foodelo.africa') ?? false))
      appDebugMode.value = true;
  }
}
 */

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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        title: Text(widget.title),
      ),
      body: Center(
        
        child: Column(
         
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
