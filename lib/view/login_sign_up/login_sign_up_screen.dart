import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notification_app_web/view/home/home_screen.dart';
import 'package:notification_app_web/models/user_model.dart';
import 'package:notification_app_web/utils/app_colors.dart';
import 'package:notification_app_web/utils/app_string.dart';
import 'package:notification_app_web/utils/common_widgets.dart';
import 'package:notification_app_web/utils/utils.dart';

class LoginSignUpScreen extends StatefulWidget {
  const LoginSignUpScreen({super.key});

  @override
  State<LoginSignUpScreen> createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  bool doesUserWantToSignUp = true;
  Uint8List? selectedImage;
  bool errorInPicture = false;
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  chooseImage() async{
    FilePickerResult? chooseImageFile = await FilePicker.platform.pickFiles(type: FileType.image);
    setState(() {
      selectedImage = chooseImageFile!.files.single.bytes;
    });
  }

  uploadImageToStorage(UserModel userData){
    if(selectedImage != null){
      Reference imageRef = FirebaseStorage.instance.ref("ProfileImages/${userData.uid}.jpg");
      UploadTask task = imageRef.putData(selectedImage!);
      task.whenComplete(() async{
        String urlImage = await task.snapshot.ref.getDownloadURL();
        userData.profileImageUrl = urlImage;
        // Retrieve and set the user token
        // String userToken = await FirebaseAuth.instance.currentUser?.getIdToken() ?? "";
        // userData.userToken = userToken;
        // debugPrint("userToken: $userToken");
        // Retrieve and set the FCM token
        String fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
        userData.fcmToken = fcmToken;
        debugPrint("fcmToken: $fcmToken"); // it generating fcm token for notification but you have to quickly allow notification
        // 3. Save Userdata to firebase storage
        await FirebaseAuth.instance.currentUser?.updateDisplayName(userData.name);
        await FirebaseAuth.instance.currentUser?.updatePhotoURL(urlImage);


        final userReference = FirebaseFirestore.instance.collection("UserDetails");
        userReference
            .doc(userData.uid)
            .set(userData.toJson())
            .then((value){
              setState(() {
                isLoading  = false;
              });
              Navigator.pushReplacementNamed(context, "/home");
        });
      });
    }else{
      setState(() {
        isLoading = false;
      });
      Utils().DelightToastMessage(title: "Oops...! Error", message: "Please First Select Image", backgroundColor: AppColors.redColor, icon: Icons.error_outline, iconColor: AppColors.whiteColor, textColor: AppColors.whiteColor, traling: null, shadowColor: null, duration: 3, onTap: (){}, context: context);
    }
  }

  signUpUserNow(name,emailId,password) async{
    setState(() {
      isLoading = true;
    });
    // 1. Create New User
    final userCreated = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailId, password: password
    );
    // 2. Upload Image to firebase storage
    String uidOfCreatedUser = userCreated.user!.uid;
    final userData = UserModel(uidOfCreatedUser, name, emailId, password);
    uploadImageToStorage(userData);
  }

 Future loginUserNow(String emailId, String password) async{
   setState(() {
     isLoading = true;
   });
   FirebaseAuth.instance.signInWithEmailAndPassword(
       email: emailId,
       password: password
   ).then((value) {
     setState(() {
       isLoading = false;
     });
     Navigator.pushReplacementNamed(context, "/home");
   });
 }

 Future formValidation() async{
    String name = nameController.text.trim();
    String emailId = emailController.text.trim();
    String password = passwordController.text.trim();
    if(emailId.isNotEmpty && Utils().isEmailValid(emailId)){
      if(password.isNotEmpty && password.length >= 6){
        if(doesUserWantToSignUp == true){
          if(name.isNotEmpty && name.length >=3){
            signUpUserNow(name,emailId,password);
          }else{
            Utils().DelightToastMessage(title: "Oops...! Error", message: "Name should be greater then 3 characters", backgroundColor: AppColors.redColor, icon: Icons.error_outline, iconColor: AppColors.whiteColor, textColor: AppColors.whiteColor, traling: null, shadowColor: null, duration: 3, onTap: (){}, context: context);
          }
        }else{
          loginUserNow(emailId,password);
        }
      }else{
        Utils().DelightToastMessage(title: "Oops...! Error", message: "Password should be greater then 6 characters", backgroundColor: AppColors.redColor, icon: Icons.error_outline, iconColor: AppColors.whiteColor, textColor: AppColors.whiteColor, traling: null, shadowColor: null, duration: 3, onTap: (){}, context: context);
      }
    }else{
      Utils().DelightToastMessage(title: "Invalid Details", message: "Please Enter Valid Email ID", backgroundColor: AppColors.redColor, icon: Icons.error_outline, iconColor: AppColors.whiteColor, textColor: AppColors.whiteColor, traling: null, shadowColor: null, duration: 3, onTap: (){}, context: context
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.purpleBlurColor,
              borderRadius: BorderRadius.circular(5)
            ),
            width: screenWidth * 0.3,
            child: Column(
              children: [
                Visibility(
                  visible: doesUserWantToSignUp,
                  child: Column(
                    children: [
                      ClipOval(
                        child: selectedImage != null ?
                        Image.memory(selectedImage!,width: 100,height: 100,fit: BoxFit.cover) :
                            Image.asset(AppString.profileImg,width: 100,height: 100,fit: BoxFit.cover),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Visibility(
                  visible: doesUserWantToSignUp,
                  child: OutlinedButton(
                    style: errorInPicture ?  OutlinedButton.styleFrom(
                      side: BorderSide(width: 3,color: AppColors.redColor)
                    ): null,
                    onPressed: (){
                      chooseImage();
                    },
                    child: Text("Choose Picture")
                  )
                ),
                SizedBox(height: 5),
                Visibility(
                  visible: doesUserWantToSignUp,
                  child: textFormFieldWidget(
                    labelText: "Enter Name",
                    textEditingController: nameController,
                    suffixWidget: Icon(Icons.account_circle),
                    context: context, hintText: null, icon: null, color: null, cursorColor: Theme.of(context).primaryColor, fontSize: screenWidth * 0.01, autoFocus: false,  inputFormatters: [], keyboardType: TextInputType.text, initialValue: null, maxLines: 1, maxLength: null, readOnly: false, obscureText: false, prefixTextColor: Theme.of(context).primaryColor, suffixText: null, border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.hintLabelTextColor,)),
                    validator:  (value) {}, onChanged:(String value) {}, onTapped:() {},
                  ),
                ),
                SizedBox(height: 5),
                textFormFieldWidget(
                  labelText: "Enter Email ID",
                  textEditingController: emailController,
                    suffixWidget: Icon(Icons.email_outlined),
                  context: context, hintText: null, icon: null, color: null, cursorColor: Theme.of(context).primaryColor, prefixWidget: null, fontSize: screenWidth * 0.01, autoFocus: false,  inputFormatters: [], keyboardType: TextInputType.text, initialValue: null, maxLines: 1, maxLength: null, readOnly: false, obscureText: false, prefixTextColor: Theme.of(context).primaryColor, suffixText: null, border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.hintLabelTextColor,)),
                  validator:  (value) {}, onChanged:(String value) {}, onTapped:() {},
                ),
                SizedBox(height: 5),
                textFormFieldWidget(
                  labelText: "Enter Password",
                  textEditingController: passwordController,
                  suffixWidget: Icon(Icons.lock_open),
                  prefixWidget: null,
                  context: context, hintText: null, icon: null, color: null, cursorColor: Theme.of(context).primaryColor, fontSize: screenWidth * 0.01, autoFocus: false,  inputFormatters: [], keyboardType: TextInputType.text, initialValue: null, maxLines: 1, maxLength: null, readOnly: false, obscureText: false, prefixTextColor: Theme.of(context).primaryColor, suffixText: null, border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.hintLabelTextColor,)),
                  validator:  (value) {}, onChanged:(String value) {}, onTapped:() {},
                ),
                SizedBox(height: 20),
                Container(
                  height: 40,
                  width: double.infinity,
                  child: isLoading ? Center(child: CircularProgressIndicator()):
                  ElevatedButton(
                      onPressed: (){
                        formValidation();
                      },
                      child: textWidget(doesUserWantToSignUp ? "Sign Up" : "Log In", screenWidth * 0.01, null, FontWeight.normal)
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textWidget("Login", screenWidth * 0.01, null, FontWeight.normal),
                    CupertinoSwitch(
                      value: doesUserWantToSignUp,
                      onChanged: (value){
                        setState(() {
                          doesUserWantToSignUp = value;
                        });
                      },
                    ),
                    textWidget("Sign Up", screenWidth * 0.01, null, FontWeight.normal)
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
