import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // firebaseOnMessage();
    onFirebaseOpenApp();
  }

  //  Error: AbortError: Failed to execute 'subscribe' on 'PushManager': Subscription failed - no active Service Worker
  void onFirebaseOpenApp(){
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      debugPrint("Title: ${event.notification!.title}");
      debugPrint("body: ${event.notification!.body}");
    });
  }

  void firebaseOnMessage(){
    FirebaseMessaging.onMessage.listen((message){
      if(message != null){
        final title = message.notification!.title;
        final body = message.notification!.body;
        showDialog(
            context: context,
            builder: (context){
              return SimpleDialog(
                contentPadding: EdgeInsets.all(18),
                children: [
                  Text("Title: $title"),
                  Text("Body:  $body"),
                ],
              );
            });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async{
            String _token = "";
            try{
              await http.post(
                Uri.parse('https://fcm.googleapis.com/fcm/send'),
                headers: <String, String>
                {
                  "Content-Type": "application/json",
                  "Authorization": "key=AAAAc49kWnM:APA91bFmEbLj0fYbGaWZsoIv0SWtiun4Wkb4DwyM9K82YhXXaWGBpmkEGW7JjbrV_FbQyTtx3WJEc3fMZEh2-2294Ru7wid9wnXpCjz5-4fp3ftEbD4hDR3F_4weMa06NfZGyIBljBsW"
                  // "Authorization": "key=AAAAZAVk8pA:APA91bF2mYqRMzUoJMvFyOrpAP3r9PvtEIlypdUqQQ9NfZjYTLTCUM4zhIqjKbL6M2sWcCbeo_10nQLYMz9mp644j9Yf_EEU3-h55XndjWC_8klyu3DovAPq1FflLi-uddJdmFkG7H8D"
                },
                body: json.encode(
                  {
                    "to": _token,
                    "message":
                        {
                          "token" : _token
                        },
                    "notification":
                        {
                          "title" : "Murli Title",
                          "body" : "Hello Murli, How Are You?",
                        }
                  }),
              );
            }catch(error){
              debugPrint("Error: $error");
            }
          },
          child: Text("Hi There"),
        ),
      ),
    );
  }
}
