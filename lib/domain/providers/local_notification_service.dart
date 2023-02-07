import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:get/get.dart';

class LocalNotificationService {
  String? selectedNotificationPayload;
  static String navigationActionId = 'id_3';

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /*late AudioPlayer player;
   initAudio() async {
    player = AudioPlayer();
    //await player.setAsset('assets/sounds/ding_dong.mp3');
    player.setAudioSource(
      AudioSource.uri(
        Uri.parse("asset:///assets/sounds/ding_dong.mp3"),
        tag: MediaItem(
          id: 'fd',
          title: "",

        ),
      ),
    );


    player.setVolume(10.0);
    await player.setLoopMode(LoopMode.one);

    debugPrint('''
    ###################################################

    audio initialized

    #########################

    ''');

  }

  void stopPlayer() async{
    player.stop();
  }

  void playPlayer() async{
    player.play();
  }
*/
  static void initialize(BuildContext context) async {
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      /* notificationCategories: [
         DarwinNotificationCategory(
          'demoCategory',
         actions: <DarwinNotificationAction>[
            IOSNotificationAction('id_1', 'Action 1'),
            IOSNotificationAction(
              'id_2',
              'Action 2',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.destructive,
              },
            ),
            DarwinNotificationAction(
              'id_3',
              'Action 3',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        )

      ],*/
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: initializationSettingsDarwin,
    );

    /* final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await _notificationsPlugin.getNotificationAppLaunchDetails();
    final didNotificationLaunchApp =
        notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

    if (didNotificationLaunchApp) {
      var payload = notificationAppLaunchDetails!.notificationResponse!;
      onSelectNotification(payload);
    } else {*/
    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            //Get.toNamed(Routes.notifications);
            // final String jsonString = jsonEncode(data)
            Map<String, dynamic> payloadData =
                json.decode(notificationResponse.payload!);

/*             if (payloadData["type"] == "order" &&
                payloadData["user"] == "Customer") {
              Get.toNamed(Routes.orderSummary,
                  arguments: payloadData['orderId']);
            } else if (payloadData["type"] == "order" &&
                payloadData["user"] == "Vendor") {
              Get.toNamed(
                Routes.orders,
              );
            } else if (payloadData['type'] == 'transaction' &&
                payloadData["user"] == "Vendor") {
              Get.toNamed(Routes.wallet);
            } else if (payloadData['type'] == 'chat-conversation' &&
                payloadData["user"] == "Customer") {
              final convo = Conversations(
                  riderId: RiderId(
                      id: payloadData['senderId'],
                      firstName: payloadData['senderName'],
                      image: payloadData['image']),
                  user: 'Customer',
                  userId:
                      UserId(iid: AppDrawerController.instance.userId.value));
              Get.put(CommunicationController());

              Get.toNamed(Routes.chatBox,
                  arguments: [convo, payloadData['phone']]);
            } else if (payloadData['type'] == 'chat-conversation' &&
                payloadData["user"] == "Vendor") {
              Get.toNamed(Routes.wallet);
            } else if (payloadData['type'] == 'ratings' &&
                payloadData["user"] == "Vendor") {
              Get.toNamed(Routes.reviews);
            } else {
              return;
              //AppDrawerController.instance.getNotification();
              // Get.toNamed(Routes.notifications);
            } */
            /* if (notificationResponse.payload != null) {
                debugPrint(
                    'notification payload: ${notificationResponse.payload}');
// Here you can check notification payload and redirect user to the respective screen
                */ /* await Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
            );*/ /*
              }
              //this is the data {orderId: 637e24b7493add0a6bd86cd4, userId: 634eb65f228d6c78937d9037, user: Customer}
              Get.toNamed(Routes.notifications);*/

            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              // selectNotificationSubject.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static onSelectNotification(NotificationResponse notificationResponse) async {
    var payloadData = jsonDecode(notificationResponse.payload!);
    print("payload ${notificationResponse!.payload!}");
    // if (payloadData["type"] == "order" && payloadData["user"] != "Customer") {
    //   Get.toNamed(Routes.orderSummary, arguments: payloadData['orderId']);
    // }
  }

  static void notificationTapBackground(
      NotificationResponse notificationResponse) {
    // ignore: avoid_print
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    Map<String, dynamic> payloadData =
        json.decode(notificationResponse.payload!);

/*     if (payloadData["type"] == "order" && payloadData["user"] == "Customer") {
      Get.toNamed(Routes.orderSummary, arguments: payloadData['orderId']);
    } else if (payloadData["type"] == "order" &&
        payloadData["user"] == "Vendor") {
      Get.toNamed(
        Routes.orders,
      );
    } else if (payloadData['type'] == 'transaction' &&
        payloadData["user"] == "Vendor") {
      Get.toNamed(Routes.wallet);
    } else if (payloadData['type'] == 'chat-conversation' &&
        payloadData["user"] == "Customer") {
      final convo = Conversations(
          riderId: RiderId(
              id: payloadData['senderId'],
              firstName: payloadData['senderName'],
              image: payloadData['image']),
          user: 'Customer',
          userId: UserId(iid: AppDrawerController.instance.userId.value));
      Get.put(CommunicationController());

      Get.toNamed(Routes.chatBox, arguments: [convo, payloadData['phone']]);
    } else if (payloadData['type'] == 'ratings' &&
        payloadData["user"] == "Vendor") {
      Get.toNamed(Routes.reviews);
    } else {
      //AppDrawerController.instance.getNotification();
      // Get.toNamed(Routes.notifications);
    } */
  }

  static void display(RemoteMessage message) async {
    String sound = 'notification_sound.mp3';
    String iosSound = 'notification.wav';
    var soundFile = sound.replaceAll('.mp3', '');

// #2
    final notificationSound =
        sound == '' ? null : RawResourceAndroidNotificationSound(soundFile);

    final iosDetail =
        DarwinNotificationDetails(presentSound: true, sound: iosSound);

    // final iosDetail = DarwinNotificationDetails();

    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          iOS: iosDetail,
          android: AndroidNotificationDetails(
            "foodelo_id_4",
            "${message.notification!.title!}",
            channelDescription: "Foodelo notification channel",
            importance: Importance.max,
            priority: Priority.high,
            sound: notificationSound,
            playSound: true,
          ));

      debugPrint(" this is the data ${message.data}");
      final String payloadString = jsonEncode(message.data);

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: payloadString,
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  static void vendorDisplay(RemoteMessage message) async {
    print(" this is the data ${message.data}");

    String sound = 'notification_sound.mp3';
    String iosSound = 'notification.wav';
    //String sound = 'under_bottle.mp3';
    var soundFile = sound.replaceAll('.mp3', '');

// #2
    final notificationSound =
        sound == '' ? null : RawResourceAndroidNotificationSound(soundFile);

    final iosDetail =
        DarwinNotificationDetails(presentSound: true, sound: iosSound);

    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          iOS: iosDetail,
          android: AndroidNotificationDetails(
            "foodelo_id_4",
            "${message.notification!.title!}",
            channelDescription: "Foodelo notification channel",
            importance: Importance.max,
            priority: Priority.high,
            sound: notificationSound,
            playSound: true,
            additionalFlags: Int32List.fromList(<int>[1]),
          ));

      print(" this is the data ${message.data}");

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: '${message.data}',
      );

      /* if (message.notification!.title == 'Order Purchase Request') {
        AppDrawerController.instance.playPlayer();
      }*/

    } catch (e) {
      print(e);
    }
  }

  /*static void onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title??''),
        content: Text(body??''),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(payload),
                ),
              );
            },
          )
        ],
      ),
    );
  }*/

}
