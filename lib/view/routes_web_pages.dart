import 'package:flutter/material.dart';
import 'package:notification_app_web/view/home_screen.dart';

import 'login_sign_up/login_sign_up_screen.dart';

class RoutesForWebPages {

  static Route<dynamic> createRoutes(RouteSettings settingsRoute) {
    final arguments = settingsRoute.arguments;

    switch(settingsRoute.name) {
      case "/":
        return MaterialPageRoute(builder: (c) => const LoginSignUpScreen());
      case "/login":
        return MaterialPageRoute(builder: (c) => const LoginSignUpScreen());
      case "/home":
        return MaterialPageRoute(builder: (c) => const HomeScreen());
    }
    return errorPageRoute();
}

static Route<dynamic> errorPageRoute(){
    return MaterialPageRoute(builder: (c) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Web Page Not Found"),
        ),
        body: Center(
          child: Text("Web Page Not Fount"),
        ),
      );
    });
}
}