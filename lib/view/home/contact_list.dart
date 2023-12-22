import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notification_app_web/models/user_model.dart';
import 'package:notification_app_web/utils/app_colors.dart';
import 'package:notification_app_web/utils/common_widgets.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  String currentUserId = "";

  Future getCurrentFirebaseUser() async{
    User? currentFirebaseUser = FirebaseAuth.instance.currentUser!;
    if(currentFirebaseUser != null){
      currentUserId = currentFirebaseUser.uid;
    }
  }

  Future<List<UserModel>> readContactList() async{
    final userRef = FirebaseFirestore.instance.collection("UserDetails");
    QuerySnapshot allUserRecord = await userRef.get();

    List<UserModel> allUsersList = [];

    for(DocumentSnapshot userRecord in allUserRecord.docs){
      String uid = userRecord["uid"];
      if(uid == currentUserId){
        continue;
      }
      String name = userRecord["name"];
      String email = userRecord["email"];
      String password = userRecord["password"];
      String profileImageUrl = userRecord["profileImageUrl"];

      UserModel userModel = UserModel(uid, name, email, password, profileImageUrl: profileImageUrl);
      allUsersList.add(userModel);
    }

    return allUsersList;
  }


  @override
  void initState() {
    getCurrentFirebaseUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readContactList(),
      builder: (context, dataSnapshot){
        switch(dataSnapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            if(dataSnapshot.hasError){
              return Center(child: textWidget("Error On Loading Contact List", 14, null, FontWeight.normal));
            }else{
              List<UserModel>? userContactList = dataSnapshot.data;
              if(userContactList != null){
                return ListView.separated(
                    separatorBuilder: (context, index){
                      return Divider(
                        thickness: 0.3,
                        color: AppColors.greyColor,
                      );
                    },
                  itemCount: userContactList.length,
                    itemBuilder: (context, index){
                      UserModel userData = userContactList[index];
                      return ListTile(
                        onTap: (){
                          Future.delayed(Duration.zero,(){
                            Navigator.pushNamed(context, "/messages",arguments: userData);
                          });
                        },
                        leading: CircleAvatar(
                          radius: 26,
                          child: CachedNetworkImage(
                            imageUrl: userData.profileImageUrl.toString(),
                            fit: BoxFit.fill,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Container(),
                          ),
                        ),
                        title: textWidget(userData.name.toString(), 15,AppColors.whiteColor, FontWeight.bold),
                        contentPadding: EdgeInsets.all(9),
                      );
                    },
                );
              }else{
                return Center(
                  child: textWidget("No Contact List", 14, null, FontWeight.normal),
                );
              }
            }

        }
      },
    );
  }
}
