import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notification_app_web/models/user_model.dart';
import 'package:notification_app_web/view/home/chat_area.dart';
import 'package:notification_app_web/view/home/messages_area.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
late UserModel currentUserData;
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
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
