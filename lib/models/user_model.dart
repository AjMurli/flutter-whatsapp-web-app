class UserModel{
  String uid;
  String name;
  String email;
  String password;
  String profileImageUrl;
  // String userToken;
  String fcmToken;

  UserModel(
     this.uid,
     this.name,
     this.email,
     this.password,
  {
    this.profileImageUrl = "",
    // this.userToken = "",
    this.fcmToken = "",
  }
  );

  Map<String, dynamic> toJson(){
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "password": password,
      "profileImageUrl": profileImageUrl,
      // "userToken": userToken,
      "fcmToken": fcmToken,
    };
  }
}