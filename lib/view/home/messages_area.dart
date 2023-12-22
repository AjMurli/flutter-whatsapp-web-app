import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notification_app_web/models/user_model.dart';
import 'package:notification_app_web/provider/chat_provider.dart';
import 'package:notification_app_web/utils/app_colors.dart';
import 'package:notification_app_web/utils/app_string.dart';
import 'package:notification_app_web/utils/common_widgets.dart';
import 'package:notification_app_web/view/widgets/messages_widgets.dart';
import 'package:provider/provider.dart';

class MessagesArea extends StatefulWidget {
  final UserModel currentUserData;
  MessagesArea({
    super.key,
    required this.currentUserData
  });


  @override
  State<MessagesArea> createState() => _MessagesAreaState();
}

class _MessagesAreaState extends State<MessagesArea> {
  @override
  Widget build(BuildContext context) {
    UserModel? toUserData = context.watch<ChatProvider>().toUserData;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: AppColors.secondaryDarkColor
      ),
      child: toUserData == null ?
      Center(child: textWidget("Choose a chat to see messages", 15, AppColors.whiteColor, FontWeight.normal)) :
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                color: AppColors.secondaryDarkColor,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      child: CachedNetworkImage(
                        imageUrl: toUserData.profileImageUrl,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.asset(AppString.logoImg),
                      ),
                    ),
                    SizedBox(width: 10),
                    textWidget(toUserData.name, 15, AppColors.whiteColor, FontWeight.bold),
                    Spacer(),
                    Icon(Icons.search),
                    Icon(Icons.more_vert_outlined),
                  ],
                ),
              ),
              Expanded(
                child: MessagesWidgets(
                  fromUserData: widget.currentUserData,
                  toUserData: toUserData,
                ),
              )
            ],
          )
    );
  }
}
