import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notification_app_web/models/message_model.dart';
import 'package:notification_app_web/models/user_model.dart';
import 'package:notification_app_web/utils/app_colors.dart';
import 'package:notification_app_web/utils/app_string.dart';

class MessagesWidgets extends StatefulWidget {
  UserModel fromUserData;
  UserModel toUserData;
  MessagesWidgets({
    super.key,
    required this.fromUserData,
    required this.toUserData
  });

  @override
  State<MessagesWidgets> createState() => _MessagesWidgetsState();
}

class _MessagesWidgetsState extends State<MessagesWidgets> {
  TextEditingController sendMessageController = TextEditingController();

  sendMessage(){
    String messageText = sendMessageController.text.trim();
    if(messageText.isNotEmpty){
      String fromUserID = widget.fromUserData.uid;
      final message = MessageModel(fromUserID, messageText, Timestamp.now().toString());

      String toUserID = widget.toUserData.uid;
      String messageID = DateTime.now().millisecondsSinceEpoch.toString();

      // Save Message For Sender
      saveMessageToDatabase(fromUserID, toUserID, message,messageID);

      // Save Message For Receiver
      saveMessageToDatabase(toUserID, fromUserID, message,messageID);
    }
  }

  saveMessageToDatabase(fromUserID, toUserID, message,messageID){
    FirebaseFirestore.instance
        .collection("messages")
        .doc(fromUserID).collection(toUserID)
        .doc(messageID)
        .set(message.toMap());

    sendMessageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(AppString.backgroundImage),
      //     fit: BoxFit.cover
      //   ),
      // ),
      child: Column(
        children: [
          // Display Message Here
          Spacer(),
          // TextFormField send message
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [

                // TextFormField with 2 Icons Buttons
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(42)
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.insert_emoticon_rounded),
                        SizedBox(width: 5,),
                        Expanded(
                          child: TextFormField(
                            controller: sendMessageController,
                            decoration: InputDecoration(
                              hintText: "Write a Message",
                              border: InputBorder.none
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: (){},
                            icon: Icon(Icons.attach_file_outlined)
                        ),
                        IconButton(
                            onPressed: (){},
                            icon: Icon(Icons.camera_alt)
                        )
                      ],
                    ),
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: AppColors.greenColor,
                    mini: true,
                    child: Icon(Icons.send),
                    onPressed: (){
                    sendMessage();
                    },
                )
              ],
            ),
          )

        ],
      ),
    );
  }
}
