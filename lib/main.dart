import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:notification_app_web/provider/chat_provider.dart';
import 'package:notification_app_web/view/advertisement_screen.dart';
import 'package:notification_app_web/view/routes_web_pages.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('A bg message just showed up :  ${message.messageId}');
}

String firstRoute = "/";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  MobileAds.instance.initialize();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDJbBtF5WT1Fx0u_nedPgyOgTdj1TWC31Y",
            authDomain: "notification-website-app.firebaseapp.com",
            projectId: "notification-website-app",
            storageBucket: "notification-website-app.appspot.com",
            messagingSenderId: "496326957683",
            appId: "1:496326957683:web:dc5d76ea2d0e31928de806",
            measurementId: "G-VQ05B53X13"
        ));
    User? currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser != null){
      firstRoute = "/home";
    }
  }
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: MyApp(),
    )
  );
  // runApp(const MyApp());

  // FirebaseMessaging.instance.getToken().then(print); // token
  // print("Default Token:");
  //  ci1PNqUua22gIBa-e6yKzs:APA91bHxS480NaKOEEjIerEagYJI_HyaqVPbHcyukITfmq184-AULtMcyZ-TtIu1B5Qf4O4lK_uDvq_P1KaNh9GqgyRssNqhEthf6ZrTujRV3OiTDM8zbVPMZw5dNKrqPB84PY_Q5RGV
 //  Default Token: ci1PNqUua22gIBa-e6yKzs:APA91bHxS480NaKOEEjIerEagYJI_HyaqVPbHcyukITfmq184-AULtMcyZ-TtIu1B5Qf4O4lK_uDvq_P1KaNh9GqgyRssNqhEthf6ZrTujRV3OiTDM8zbVPMZw5dNKrqPB84PY_Q5RGV
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Web Whats App ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: firstRoute,
      onGenerateRoute: RoutesForWebPages.createRoutes,
    );
  }
}

