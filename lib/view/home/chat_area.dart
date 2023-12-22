import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notification_app_web/models/user_model.dart';
import 'package:notification_app_web/utils/app_colors.dart';
import 'package:notification_app_web/utils/common_widgets.dart';
import 'package:notification_app_web/view/home/contact_list.dart';
import 'package:notification_app_web/view/home/recent_chats.dart';

class ChatArea extends StatefulWidget {
  final UserModel currentUserData;
  ChatArea({
    super.key,
    required this.currentUserData
  });

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryDarkColor,
            // border: Border(
            //     right: BorderSide(
            //         color: AppColors.secondaryDarkColor,
            //         // width: 1
            //     )
            // ),
          ),
          child: Column(
            children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryDarkColor
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    child: CachedNetworkImage(
                      imageUrl: widget.currentUserData.profileImageUrl,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Container(),
                    ),
                  ),
                  SizedBox(width: 15),
                  textWidget(widget.currentUserData.name, 15, AppColors.whiteColor, FontWeight.bold),
                  Spacer(),
                  IconButton(
                      onPressed: () async{
                        await FirebaseAuth.instance.signOut().then((value){
                          Navigator.pushReplacementNamed(context, "/login");
                        });
                      },
                      icon: Icon(Icons.logout_outlined,color: AppColors.whiteColor,)
                  ),
                ],
              ),
            ),
              TabBar(
                unselectedLabelColor: AppColors.whiteColor,
                labelColor: AppColors.whiteColor,
                indicatorColor: Theme.of(context).primaryColor,
                indicatorWeight: 2,
                labelStyle: TextStyle(fontSize: 14),
                tabs: [
                  Tab(
                    text: "Recent Chats",
                  ),
                  Tab(
                    text: "Contacts",
                  ),
                ],
              ),
              Container( // expanded
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryDarkColor,
                  ),
                  child: TabBarView(
                    children: [
                      RecentChats(),
                      ContactList()
                    ],
                  ),
                ),
              )
          ],
        ),
      )
    );
  }
}
