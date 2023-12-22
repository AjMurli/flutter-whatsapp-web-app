import 'package:flutter/cupertino.dart';
import 'package:notification_app_web/models/user_model.dart';

class ChatProvider extends ChangeNotifier{

  UserModel? _toUserData;
  UserModel? get toUserData => _toUserData;

  set toUserData(UserModel? userDataModel){
    _toUserData = userDataModel;
    notifyListeners();
  }


}