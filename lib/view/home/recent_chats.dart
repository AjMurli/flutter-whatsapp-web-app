import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:notification_app_web/models/user_model.dart';
import 'package:notification_app_web/provider/chat_provider.dart';
import 'package:notification_app_web/utils/app_colors.dart';
import 'package:notification_app_web/utils/common_widgets.dart';
import 'package:provider/provider.dart';

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
    return StreamBuilder(
        stream: streamController.stream,
        builder: (context, snapshot){
      switch(snapshot.connectionState){
        case ConnectionState.none:
        case ConnectionState.waiting:
          return Center(
            child: CircularProgressIndicator(),
          );
        case ConnectionState.active:
        case ConnectionState.done:
        if(snapshot.hasError){
          return textWidget("Error Loading Chats Details", 14, AppColors.whiteColor, FontWeight.normal);
        }else{
          final snapshotData = snapshot.data as QuerySnapshot;
          List<DocumentSnapshot> recentChatsList = snapshotData.docs.toList();

          return ListView.separated(
            itemCount: recentChatsList.length,
              separatorBuilder: (context, index){
              return Divider(
                color: Colors.grey,
                thickness: 0.3,
              );
              },
            itemBuilder: (context,index){
              DocumentSnapshot chat = recentChatsList[index];
              String toUserImage = chat["toUserImage"];
              String toUserName = chat["toUserName"];
              String toUserEmail = chat["toUserEmail"];
              String lastMessage = chat["lastMessage"];
              String toUserId = chat["toUserId"];
              
              final toUserData = UserModel(toUserId, toUserName, toUserEmail, "",profileImageUrl: toUserImage);
              return ListTile(
                onTap: (){
                  context.read<ChatProvider>().toUserData = toUserData;
                  // Navigator.pushNamed(context, "/messages", arguments: toUserData);
                },
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.greyColor,
                  backgroundImage: NetworkImage(
                    toUserData.profileImageUrl
                  ),
                ),
                title: textWidget(toUserData.name, 18, AppColors.whiteColor, FontWeight.bold),
                subtitle: Text(
                lastMessage.toString().contains(".jpg")
                    ? "sent you an image"
                    :
                lastMessage.toString().contains(".docx")
                    ||  lastMessage.toString().contains(".pptx")
                    ||  lastMessage.toString().contains(".xlsx")
                    ||  lastMessage.toString().contains(".pdf")
                    ||  lastMessage.toString().contains(".mp3")
                    ||  lastMessage.toString().contains(".mp4") ? "sent you a file" :
                lastMessage.toString(),
                  style: TextStyle(fontSize: 14,color: AppColors.greyColor),maxLines: 3,overflow: TextOverflow.ellipsis,
                ),
                contentPadding: EdgeInsets.all(9),
              );
            },
          );
        }
      }}
    );
  }
}
