import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notification_app_web/models/user_model.dart';
import 'package:notification_app_web/view/home/chat_area.dart';
import 'package:notification_app_web/view/home/messages_area.dart';
import 'package:notification_app_web/view/widgets/notification_dialog_widget.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
late UserModel currentUserData;
String? _token;
Stream<String>? _tokenStream;

@override
void initState() {
  super.initState();
  readCurrentUserData();
}

Future readCurrentUserData() async{
  User? currentUser = FirebaseAuth.instance.currentUser!;
  if(currentUser != null){
    String uid = currentUser.uid;
    String name = currentUser.displayName ?? "";
    String email = currentUser.email ?? "";
    String password =  "";
    String photoURL = currentUser.photoURL ?? "";

    currentUserData = UserModel(uid, name, email, password, profileImageUrl: photoURL);
  }

  await getPermissionForNotifications();
  await pushNotificationMessageListener();

  await FirebaseMessaging.instance.getToken().then(setTokenNow);
  _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
  _tokenStream!.listen(setTokenNow);
  await saveTokenToUserInfo();
}

getPermissionForNotifications() async{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    sound: true,
    badge: true,
    announcement: false,
    carPlay: false,
    criticalAlert: false,
    provisional: false
  );
}

pushNotificationMessageListener() async{
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if(message.notification != null){
      showDialog(
          context: context,
          builder:( (BuildContext context) {
            return NotificationDialogWidget(
                titleText: message.notification!.title,
                body: message.notification!.body
            );
          })
      );
    }
  });
}

setTokenNow(String? token) async{
  debugPrint("FCM User Token: $token");
  setState(() {
    _token = token;
  });
}

saveTokenToUserInfo() async{
  await FirebaseFirestore.instance.collection("UserDetails")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
    "token": _token,
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: ChatArea(currentUserData : currentUserData),
                  ),
                  Expanded(
                    flex: 10,
                    child: MessagesArea(currentUserData : currentUserData),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
