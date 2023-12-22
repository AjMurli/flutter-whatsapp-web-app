import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notification_app_web/models/user_model.dart';
import 'package:notification_app_web/utils/app_colors.dart';
import 'package:notification_app_web/utils/common_widgets.dart';
import 'package:notification_app_web/view/widgets/messages_widgets.dart';

class MessagesScreen extends StatefulWidget {
  final UserModel toUserData;
  MessagesScreen(
      this.toUserData,
      {Key? key}
  ): super(key : key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late UserModel toUser;
  late UserModel fromUser;

  getUserData(){
    toUser = widget.toUserData;
    User? loggedInUser = FirebaseAuth.instance.currentUser!;
    if(loggedInUser != null){
      fromUser = UserModel(
          loggedInUser.uid,
          loggedInUser.displayName ?? "",
          loggedInUser.email ?? "",
          "",
        profileImageUrl: loggedInUser.photoURL ?? ""
      );
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDarkColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryDarkColor,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new,color: AppColors.whiteColor,),onPressed: (){
          Navigator.pop(context);
        },),
        centerTitle: true,
        title: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(toUser.profileImageUrl),
            ),
            SizedBox(width: 8,),
            textWidget(toUser.name, 15, AppColors.whiteColor, FontWeight.bold)
          ],
        ),
        actions: [
          Icon(Icons.more_vert_outlined,color: AppColors.whiteColor,)
        ],
      ),
      body: SafeArea(
        child: MessagesWidgets(
          fromUserData: fromUser,
          toUserData: toUser,
        )
      ),
    );
  }
}
