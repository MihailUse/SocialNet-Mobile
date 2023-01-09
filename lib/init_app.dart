import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:social_net/domain/repository/database_repository.dart';
import 'package:social_net/firebase_options.dart';
import 'package:social_net/ui/navigation/app_navigator.dart';
import 'package:social_net/utils.dart';

Future<void> initApp() async {
  await DatabaseRepository.instance.init();
  // await initFireBase();
}

Future<void> initFireBase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    carPlay: false,
    announcement: false,
    criticalAlert: true,
    provisional: false,
  );

  FirebaseMessaging.onMessage.listen(catchMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(catchMessage);
}

void catchMessage(RemoteMessage message) {
  "Got a message whilst in the foreground!".console();
  "Message data: ${message.data}".console();

  if (message.notification != null) {
    showModal(message.notification!.title!, message.notification!.body!);
    // var post = '81b4293b-e874-4f2d-a6e0-c0135006c75e';
    // var ctx = AppNavigator.navigationKeys[TabItemEnum.home]?.currentContext;
    // if (ctx != null) {
    //   var appviewModel = ctx.read<AppViewModel>();
    //   Navigator.of(ctx)
    //       .pushNamed(TabNavigatorRoutes.postDetails, arguments: post);
    //   appviewModel.selectTab(TabItemEnum.home);
    // }
  }
}

void showModal(
  String title,
  String content,
) {
  final context = AppNavigator.navigatorKey.currentContext;
  if (context != null) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("got it"),
            )
          ],
        );
      },
    );
  }
}
