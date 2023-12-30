import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:notification_app_web/models/user_model.dart';

class RecentChats extends StatefulWidget {
  const RecentChats({super.key});

  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  late UserModel fromUserData;
  final streamController = StreamController<QuerySnapshot>.broadcast();
  late StreamSubscription streamSubscriptionChats;

  chatListener() {
    final streamRecentChats = FirebaseFirestore.instance.collection("chats").doc(fromUserData.uid).collection('lastMessage').snapshots();
    streamSubscriptionChats = streamRecentChats.listen((newMessageData) {
      streamController.add(newMessageData);
    });
  }

  loadInitialData() {
    User? currentFirebaseUser = FirebaseAuth.instance.currentUser;
    if(currentFirebaseUser != null){
      String userId = currentFirebaseUser.uid;
      String name = currentFirebaseUser.displayName ?? "";
      String email = currentFirebaseUser.email ?? "";
      String password = "" ;
      String profileImage = currentFirebaseUser.photoURL ?? "" ;
      fromUserData = UserModel(userId, name, email, password,profileImageUrl: profileImage);
    }
    chatListener();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInitialData();
  }

  @override
  void dispose() {
    streamSubscriptionChats.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
