import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notification_app_web/utils/app_colors.dart';
import 'package:notification_app_web/utils/common_widgets.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class Utils{
  void showErrorMessage(BuildContext context, String title, String message) {
    if (kIsWeb) {
      Utils.showErrorAwesomeSnackBar(
        context,
        title,
        message,
      );
    } else {
      Utils().snackBarMessage(
        context,
        title,
        message,
        AppColors.redColor,
        Icons.error_outline,
      );
    }
  }


  void showSuccessMessage(BuildContext context, String title, String message) {
    if (kIsWeb) {
      Utils.showSuccessAwesomeSnackBar(
        context,
        title,
        message,
      );
    } else {
      Utils().snackBarMessage(
        context,
        title,
        message,
        AppColors.primaryColor,
        Icons.check_circle,
      );
    }
  }

  void showInfoMessage(BuildContext context, String title, String message, Color? bgColor, IconData? icon) {
    if (kIsWeb) {
      Utils.showInfoAwesomeSnackBar(
        context,
        title,
        message,
      );
    } else {
      Utils().snackBarMessage(
        context,
        title,
        message,
        bgColor,
        icon,
      );
    }
  }
  snackBarMessage(BuildContext context, String? title, String? message,Color? bgColor ,IconData? icon){
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.all(8),
            height: 80,
            decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                Icon(icon,color: AppColors.whiteColor,size: 40,),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidget(title , 20, AppColors.whiteColor, FontWeight.bold),
                      SizedBox(height: 5,),
                      textMaxWidget(message , 2 ,15, AppColors.whiteColor, FontWeight.normal),
                    ],
                  ),
                )
              ],
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        )
    );
  }


  static void showErrorAwesomeSnackBar(BuildContext context, String title, String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }


  static void showSuccessAwesomeSnackBar(BuildContext context, String title, String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showInfoAwesomeSnackBar(BuildContext context, String title, String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 10),
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: ContentType.help,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }


  static void animatedErrorSnackBarMessage(String message, BuildContext context){
    AnimatedSnackBar.material(
      message,
      type: AnimatedSnackBarType.error,
      desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
      mobileSnackBarPosition: MobileSnackBarPosition.top,
    ).show(context);
  }

  static void animatedInfoSnackBarMessage(String message, BuildContext context){
    AnimatedSnackBar.material(
        message,
        type: AnimatedSnackBarType.info,
        desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
        mobileSnackBarPosition: MobileSnackBarPosition.top,
        duration: const Duration(milliseconds: 160)
    ).show(context);
  }

  static void animatedSuccessSnackBarMessage(String message, BuildContext context){
    AnimatedSnackBar.material(
        message,
        type: AnimatedSnackBarType.success,
        desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
        mobileSnackBarPosition: MobileSnackBarPosition.top,
        duration: const Duration(milliseconds: 120)
    ).show(context);
  }


  static void animatedSubmitSuccessMessage(String message,BuildContext context){
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: message,
    );
  }

  static void sendingMails(String emailId) async {
    var url = Uri.parse("mailto:$emailId");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Fluttertoast.showToast(
        msg: 'Unable To Send Email ☹️ $url',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.blue,
      );
    }
  }

  static void makingPhoneCall(String mobileNumber) async {
    var url = 'tel:$mobileNumber';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      Fluttertoast.showToast(
        msg: '️Making Call',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.blue,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Unable To Call Please Try Again Later ☹️',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.blue,
      );
    }
  }
  Future<void> launchUrlUtils(String link) async {
    final uri = Uri.parse(link);
    if (!await launchUrl(uri)) {
      throw 'COULD NOT LAUNCH $uri';
    }
  }

  static Widget readMoreText(double width,String text, int lines, Color? color, double fontSize, FontWeight fontWeight, ){
    return SizedBox(
      width: width,
      child:  ReadMoreText(
        text,
        trimLines: lines,
        style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w900
        ),
        colorClickableText: AppColors.primaryColor,
        trimMode: TrimMode.Line,
        trimCollapsedText: '...Read More',
        trimExpandedText: ' less ',
      ),
    );
  }

  bool isEmailValid(String email) {
    final regex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return regex.hasMatch(email);
  }


  void DelightToastMessage({
    String? title,
    String? message,
    Color? backgroundColor,
    IconData? icon,
    Color? iconColor,
    Color? textColor,
    Widget? traling,
    Color? shadowColor,
    int? duration,
    void Function()? onTap,
    BuildContext? context   ,
}) {
    if(kIsWeb){
      Utils.showErrorAwesomeSnackBar(
        context!,
        title!,
        message!,
      );

    }
    else{
      DelightToastBar(
          autoDismiss: true,
          snackbarDuration: Duration(seconds: duration!),
          builder: (context) =>  ToastCard(
            color: backgroundColor,
            leading: Icon(icon,color: iconColor,),
            title: textWidget(title, null, textColor, FontWeight.bold),
            subtitle: textWidget(message, null, textColor, FontWeight.normal),
            trailing: traling,
            onTap: onTap,
            shadowColor: shadowColor,
          )
      ).show(context!);
    }

  }
}

