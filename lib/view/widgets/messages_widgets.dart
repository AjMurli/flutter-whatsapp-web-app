import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:notification_app_web/models/chat_model.dart';
import 'package:notification_app_web/models/message_model.dart';
import 'package:notification_app_web/models/user_model.dart';
import 'package:notification_app_web/provider/chat_provider.dart';
import 'package:notification_app_web/utils/app_colors.dart';
import 'package:notification_app_web/utils/app_string.dart';
import 'package:notification_app_web/utils/common_widgets.dart';
import 'package:provider/provider.dart';

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
  late StreamSubscription _streamSubscriptionMessages;
  final streamController = StreamController<QuerySnapshot>.broadcast();
  final scrollControllerMessage = ScrollController();
  String? fileTypeChoosed;
  bool _loadingPic = false;
  bool _loadingFile = false;
  Uint8List? _selectedImage;
  Uint8List? _selectedFile;


  sendMessage() {
    String messageText = sendMessageController.text.trim();
    if(messageText.isNotEmpty){
      String fromUserID = widget.fromUserData.uid;
      final message = MessageModel(fromUserID, messageText, Timestamp.now().toString());

      String toUserID = widget.toUserData.uid;
      String messageID = DateTime.now().millisecondsSinceEpoch.toString();

      // Save Message For Sender
      saveMessageToDatabase(fromUserID, toUserID, message,messageID);

      //  -----------------------  Sender Section Start ---------------------
      // Save chat for recent [ sender ]
      final chatFromData = ChatModel(
        fromUserID,
        toUserID,
        messageText.trim(),
        widget.toUserData.name,
        widget.toUserData.email,
        widget.toUserData.profileImageUrl,
      );
      saveRecentChatToDatabase(chatFromData, messageText);
      //  -----------------------  Sender Section End ---------------------

      //  -----------------------  Receiver Section Start ---------------------
      // Save Message For Receiver
      saveMessageToDatabase(toUserID, fromUserID, message,messageID);
      // Save chat for recent [ sender ]
      final chatToData = ChatModel(
        toUserID,
        fromUserID,
        messageText.trim(),
        widget.fromUserData.name,
        widget.fromUserData.email,
        widget.fromUserData.profileImageUrl,
      );
      saveRecentChatToDatabase(chatToData,messageText);
      //  -----------------------  Receiver Section End ---------------------
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

  saveRecentChatToDatabase(ChatModel chat, message){
    FirebaseFirestore.instance
        .collection("chats")
        .doc(chat.fromUserId).collection("lastMessage")
        .doc(chat.toUserId)
        .set(chat.toMap()).then((value) {
          // Send Push Notification
    });
  }

  createMessageListener({UserModel? toUserData}) {
    // Live refresh our messages page directly from firebase
    final streamMessages = FirebaseFirestore.instance.
    collection("messages").doc(widget.fromUserData.uid)
        .collection(toUserData?.uid ?? widget.toUserData.uid)
        .orderBy("dateTime",descending: false)
        .snapshots();

    // Scroll at the end of messages
    _streamSubscriptionMessages = streamMessages.listen((data) {
      streamController.add(data);
      Timer(Duration(seconds: 1), (){
        scrollControllerMessage.jumpTo(scrollControllerMessage.position.maxScrollExtent);
      });
    });
  }

  updateMessageListener(){
    UserModel? toUserData = context.watch<ChatProvider>().toUserData;
    if(toUserData != null){
      createMessageListener(toUserData: toUserData);
    }
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    // To update message listener through provider
    super.didChangeDependencies();
    updateMessageListener();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamSubscriptionMessages.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createMessageListener();
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
          StreamBuilder(
              stream: streamController.stream,
              builder: (context, dataSnapshot){
                switch(dataSnapshot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Expanded(
                      child: Center(
                        child: Column(
                          children: [
                            textWidget("Loading...", 14, AppColors.whiteColor, FontWeight.normal),
                            CircularProgressIndicator()
                          ],
                        ),
                      ),
                    );

                  case ConnectionState.active:
                  case ConnectionState.done:
                    if(dataSnapshot.hasError){
                      return textWidget("Error Occured", 14, AppColors.whiteColor, FontWeight.normal);
                    }else{
                      final snapshot = dataSnapshot.data as QuerySnapshot;
                      List<DocumentSnapshot> messageList = snapshot.docs.toList();
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          controller: scrollControllerMessage,
                          itemCount: snapshot.docs.length,
                          itemBuilder: (context, index){
                            DocumentSnapshot  eachMessage = messageList[index];
                            // Align message balloons from sender and receiver
                            Alignment alignment = Alignment.bottomLeft;
                            Color color = Colors.deepPurple;
                            if(widget.fromUserData.uid == eachMessage["uid"]){
                              alignment = Alignment.bottomRight;
                              color = AppColors.secondaryDarkColor;
                            }
                            Size width = MediaQuery.of(context).size * 0.8;
                            return GestureDetector(
                              onLongPress: (){},
                              child: eachMessage["text"].toString().contains(".jpg") ?
                              Align(
                                alignment: alignment,
                                child: Container(
                                    constraints: BoxConstraints.loose(width),
                                    decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(9)
                                        )
                                    ),
                                    padding: EdgeInsets.all(16),
                                    margin: EdgeInsets.all(6),
                                    child: Image.network(
                                      eachMessage["text"],
                                      height: 200,
                                      width: 200,
                                    )
                                ),
                              ) :
                              eachMessage["text"].toString().contains(".docx")
                                  || eachMessage["text"].toString().contains(".pptx")
                                  || eachMessage["text"].toString().contains(".xlsx")
                                  || eachMessage["text"].toString().contains(".pdf")
                                  || eachMessage["text"].toString().contains(".mp3")
                                  || eachMessage["text"].toString().contains(".mp4")
                                  ?
                              Align(
                                alignment: alignment,
                                child: Container(
                                    constraints: BoxConstraints.loose(width),
                                    decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(9)
                                        )
                                    ),
                                    padding: EdgeInsets.all(16),
                                    margin: EdgeInsets.all(6),
                                    child: GestureDetector(
                                      onTap: (){},
                                      child: Image.asset(
                                        AppString.fileImg,
                                        height: 200,
                                        width: 200,
                                      ),
                                    )
                                ),
                              ) :
                              Align(
                                alignment: alignment,
                                child: Container(
                                    constraints: BoxConstraints.loose(width),
                                    decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(9)
                                        )
                                    ),
                                    padding: EdgeInsets.all(16),
                                    margin: EdgeInsets.all(6),
                                    child: textWidget(eachMessage["text"], 14,AppColors.whiteColor, FontWeight.normal)
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                }
              }
          ),
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
                        _loadingFile == false ?
                        IconButton(
                            onPressed: (){
                              dialogBoxForSelectingFile();
                            },
                            icon: Icon(Icons.attach_file_outlined)
                        ): Center(
                          child: CircularProgressIndicator(),
                        ),
                        _loadingPic == false ?
                        IconButton(
                            onPressed: (){
                              selectImage();
                            },
                            icon: Icon(Icons.camera_alt)
                        ): Center(
                          child: CircularProgressIndicator(),
                        ),
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
  dialogBoxForSelectingFile(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return AlertDialog(
                title: textWidget("Send File", 14, null, FontWeight.bold),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    textWidget("Please Select file type from the followings", 14,null, FontWeight.normal),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal  ,
                      child: DropdownButton<String>(
                        onChanged: (String? value){
                          setState(() {
                            fileTypeChoosed = value;
                          });
                        },
                        hint: textWidget("Choose Here", 14, null, FontWeight.normal),
                        value: fileTypeChoosed,
                        underline: Container(),
                        items: <String> [
                          '.pdf',
                          '.mp4',
                          '.mp3',
                          '.docx',
                          '.pptx',
                          '.xlsx',
                        ].map((String value){
                          return DropdownMenuItem<String>(
                            value: value,
                            child: textWidget(value, 14, null, FontWeight.w500),
                          );
                        }).toList()
                      ),
                    )
                  ],
                ),
                actions: [
                  ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                        // Select File
                        selectFile(fileTypeChoosed);
                      }, child: textWidget("Select File", 14, null, FontWeight.bold),
                  )
                ],
              );
            },
          );
        }
    );
  }

  selectFile(fileTypeChoosed) async{
    FilePickerResult? pickerResult = await FilePicker.platform.pickFiles(
      type: FileType.any
    );
    setState(() {
      _selectedFile = pickerResult?.files.single.bytes;
    });
    uploadFile(_selectedFile);
  }

  uploadFile(selectedFile) async{
    setState(() {_loadingFile = true;});
    if(_selectedFile != null){
      Reference fileRef = FirebaseStorage.instance.ref("files/${DateTime.now().millisecondsSinceEpoch.toString()}$fileTypeChoosed");
      UploadTask uploadTask = fileRef.putData(selectedFile);
      uploadTask.whenComplete(() async{
        String linkFile = await uploadTask.snapshot.ref.getDownloadURL();
        setState(() {
          sendMessageController.text = linkFile;
        });
        sendMessage();
        setState(() {_loadingPic = false;});
      });
    }
  }

  selectImage() async{
    FilePickerResult? pickerResult = await FilePicker.platform.pickFiles(
        type: FileType.image
    );
    setState(() {
      _selectedImage = pickerResult?.files.single.bytes;
    });
    uploadImage(_selectedImage);
  }

  uploadImage(selectedImage) async{
    setState(() {_loadingPic = true;});
    if(selectedImage != null){
      Reference fileRef = FirebaseStorage.instance.ref("chatImages/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg");
      UploadTask uploadTask = fileRef.putData(selectedImage);
      uploadTask.whenComplete(() async{
        String linkFile = await uploadTask.snapshot.ref.getDownloadURL();
        setState(() {
          sendMessageController.text = linkFile;
        });
        sendMessage();
        setState(() {_loadingPic = false;});
      });
    }
  }
}
