import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:notification_app_web/custom_widgets/container_shimmer_widget.dart';
import 'package:notification_app_web/custom_widgets/custom_tooltip_widget.dart';
import 'package:notification_app_web/utils/app_colors.dart';
import 'package:notification_app_web/utils/app_string.dart';
import 'package:notification_app_web/utils/utils.dart';
import 'package:readmore/readmore.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void navigateToScreen(context, page){
  Navigator.push(context, MaterialPageRoute(builder: (context)=> page));
}
void navigateToPreviousScreen(context){
  Navigator.pop(context);
}

void nextScreenReplace(context, page){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> page));
}

bool isLightMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light;
}
Widget textWidget(String? title, double? fontSize, Color? color, FontWeight? fontWeight) {
  return Text(title!, style: TextStyle(fontFamily: "Poppins",  color: color, fontSize: fontSize, fontWeight: fontWeight ));
}
Widget textMaxWidget(String? title,int? maxLines,  double? fontSize, Color? color, FontWeight? fontWeight) {
  return Text(title!,maxLines: maxLines, style: TextStyle(fontFamily: "Poppins",  color: color, fontSize: fontSize, fontWeight: fontWeight,overflow: TextOverflow.ellipsis ));
}
Widget textCenterAlignWidget(String? title, double? fontSize, Color? color, FontWeight? fontWeight) {
  return Text(title!,textAlign: TextAlign.center, style: TextStyle(fontFamily: "Poppins",  color: color, fontSize: fontSize, fontWeight: fontWeight, ));
}
Widget selectableText(String? title, double? fontSize, Color? color, FontWeight? fontWeight) {
  return SelectableText(title!, style: TextStyle(fontFamily: "Poppins",  color: color, fontSize: fontSize, fontWeight: fontWeight, ));
}
Widget poppinsNormalTextWithoutPadding(String title, double fontSize, Color color, bool bold) {
  return Text(title, style: TextStyle(fontFamily: "Poppins",  color: color, fontSize: fontSize, fontWeight: bold ? FontWeight.bold : FontWeight.normal));
}

Widget defaultTextWidget(String? title, double? fontSize, TextStyle? textStyle, FontWeight? fontWeight) {
  return Text(
    title!,
    style: TextStyle(
      fontFamily: "Poppins",
      color: textStyle?.color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
  );
}

Widget ExtendedFloatingButtonWidget({
  required BuildContext context,
  required String label,
  required IconData icon,
  required Color backgroundColor,
  required void Function() onPressed,
}) {
  return FloatingActionButton.extended(
    onPressed: onPressed,
    label: defaultTextWidget(label, null, Theme.of(context).textTheme.labelSmall, FontWeight.bold),
    icon: Icon(icon, color: Theme.of(context).textTheme.labelSmall?.color),
    backgroundColor: backgroundColor,
  );
}



PreferredSizeWidget AppBarWidget({
  required BuildContext context,
  required String? title,
  required Color? appBarBgColor,
  required double? elevation,
  bool centerTitle = false,
  required void Function() onPressed,
  List<Widget>? actions,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  return AppBar(
    backgroundColor: appBarBgColor,
    elevation: elevation,
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios, color: isLightMode(context) ? AppColors.blackColor : AppColors.whiteColor),
      onPressed: onPressed,
    ),
    centerTitle: centerTitle,
    title: textWidget(title, screenWidth * 0.045, isLightMode(context) ? AppColors.blackColor : AppColors.whiteColor, FontWeight.bold),
    actions: actions,
  );
}

Widget HeaderWidget({
  required BuildContext context,
  required String? title,
  String? searchHint,
  TextEditingController? searchController,
  Function(String)? searchOnChanged,
  String? buttonTitle,
  IconData? buttonIcon,
  void Function()? onButtonPressed,
}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_outlined),
                    onPressed: () {
                      navigateToPreviousScreen(context);
                    },
                  ),
                ),
                SizedBox(width: 10,),
                if (title!.isNotEmpty)
                  textWidget(title, 20, null, FontWeight.bold),
              ],
            ),
          ),
          if (searchHint != null)
            Expanded(
              child: Container(
                height: 45,
                child: customSearchTextField(
                  searchController!,
                  searchOnChanged!,
                  searchHint!,
                  searchHint!,
                  null,
                  context,
                ),
              ),
            ),
          if (buttonTitle != null)
            Container(
              margin: EdgeInsets.only(left: 5),
              height: 40,
              child: customElevatedButtonIcon(
                buttonTitle!,
                null,
                AppColors.primaryColor,
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                null,
                FontWeight.normal,
                buttonIcon,
                null,
                null,
                onButtonPressed!,
              ),
            )
        ],
      ),
      SizedBox(height: 5,),
      Divider(),
      SizedBox(height: 10),
    ],
  );
}

Widget textFormFieldWidget({
  BuildContext? context,
  String? hintText,
  String? labelText,
  Icon? icon,
  Color? color,
  Color? cursorColor,
  double? fontSize,
  bool? autoFocus,
  TextEditingController? textEditingController,
  List<TextInputFormatter>? inputFormatters,
  TextInputType? keyboardType,
  String? initialValue,
  int? maxLines,
  int? maxLength,
  bool? readOnly,
  bool? obscureText,
  InputBorder? border,
  Widget? prefixWidget,
  Color? prefixTextColor,
  Widget? suffixWidget,
  String? suffixText,
  FormFieldValidator<String>? validator,
  void Function(String)? onChanged,
  void Function()? onTapped,
} ) {
  return TextFormField(
    autofocus: autoFocus!,
    readOnly: readOnly!,
    obscureText: obscureText!,
    controller: textEditingController,
    validator: validator,
    initialValue: initialValue,
    cursorColor: cursorColor,
    maxLines: maxLines,
    maxLength: maxLength,
    style:  TextStyle(color: color,fontSize: fontSize),
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    onChanged: onChanged,
    onTap: onTapped,
    decoration: InputDecoration(
      counterText: "",
      border: border,
      enabledBorder: const UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.primaryColor
            )
        ),
      hintText: hintText,
      hintStyle:  TextStyle(fontFamily: 'Poppins', color: AppColors.hintLabelTextColor,fontSize: MediaQuery.of(context!).size.width * 0.009),
      labelStyle:  TextStyle(fontFamily: 'Poppins', color: AppColors.hintLabelTextColor,fontSize:  MediaQuery.of(context!).size.width * 0.009),
      prefixIcon: prefixWidget,
      contentPadding: EdgeInsets.zero,
      prefixStyle: TextStyle(color: prefixTextColor),
      suffixIcon: suffixWidget,
      labelText: labelText,
      suffixText: suffixText
    ),
  );
}
Widget textFormFieldBorderWidget({
  BuildContext? context,
  String? hintText,
  String? labelText,
  Icon? icon,
  Color? color,
  Color? cursorColor,
  double? fontSize,
  bool? autoFocus,
  TextEditingController? textEditingController,
  List<TextInputFormatter>? inputFormatters,
  TextInputType? keyboardType,
  String? initialValue,
  int? maxLines,
  int? maxLength,
  bool? readOnly,
  bool? obscureText,
  InputBorder? border,
  Widget? prefixWidget,
  Color? prefixTextColor,
  Widget? suffixWidget,
  String? suffixText,
  FormFieldValidator<String>? validator,
  void Function(String)? onChanged,
  void Function()? onTapped,
} ) {
  return TextFormField(
    autofocus: autoFocus!,
    readOnly: readOnly!,
    obscureText: obscureText!,
    controller: textEditingController,
    validator: validator,
    initialValue: initialValue,
    cursorColor: cursorColor,
    maxLines: maxLines,
    maxLength: maxLength,
    style:  TextStyle(color: color,fontSize: fontSize),
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    onChanged: onChanged,
    onTap: onTapped,
    decoration: InputDecoration(
      filled: true,
        fillColor: isLightMode(context!) ? null : AppColors.blueSelectedColor,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color:  isLightMode(context) ? AppColors.hintLabel3TextColor : AppColors.blueSelectedColor,)
        ),
        counterText: "",
        border: border,
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.primaryColor
            )
        ),
        hintText: hintText,
        hintStyle: const TextStyle(fontFamily: 'Poppins', color: AppColors.hintLabelTextColor,),
        labelStyle: const TextStyle(fontFamily: 'Poppins', color: AppColors.hintLabelTextColor,),
        prefixIcon: prefixWidget,
        prefixStyle: TextStyle(color: prefixTextColor),
        suffixIcon: suffixWidget,
        labelText: labelText,
        suffixText: suffixText
    ),
  );
}

Widget  customSearchTextField(
    TextEditingController? controller,
    Function(String)? onChanged,
    String? labelText,
    String? hintText,
    String? initialValue,
    BuildContext context,
    ){
  return TextFormField(
    cursorColor: AppColors.primaryColor,
    controller: controller,
    onChanged: onChanged,
    initialValue: initialValue,
    style:  TextStyle(
        color: isLightMode(context) ? AppColors.blackColor : AppColors.whiteColor, fontSize: 14
    ),
    textInputAction: TextInputAction.done,
    decoration: InputDecoration(
      filled: true,
      fillColor: AppColors.primaryColor,
      labelText: labelText,
      hintText: hintText,
      hintStyle: const TextStyle(
        fontFamily: 'Poppins',
        color: Colors.grey,
      ),
      labelStyle: const TextStyle(
        fontFamily: 'Poppins',
        color: Colors.grey,
      ),
      contentPadding: EdgeInsets.zero,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: isLightMode(context) ? AppColors.hintLabel2TextColor : AppColors.blueSelectedColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primaryColor
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.greyColor,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 5,bottom: 0),
        child:  Icon(Icons.search_rounded,color: isLightMode(context) ?  AppColors.greyColor : AppColors.hintLabel2TextColor),
      ),
    ),
  );
}


TextStyle textStyleWidget(
    double? fontSize,
    Color? textColor,
    FontWeight? fontWeight,
    ){
  return TextStyle(
    fontFamily: "Poppins",
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: textColor,
  );
}


Widget customReadMoreText(
    String? text,
    String? trimCollapsedText,
    String? trimExpandedText,
    int? trimLines,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextStyle? moreStyle,
    TextStyle? lessStyle,
    ) {
  return ReadMoreText(
    text!,
    trimCollapsedText: trimCollapsedText!,
    trimExpandedText: trimExpandedText!,
    trimLines: trimLines!,
    style: TextStyle(
      fontFamily: "Poppins",
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ),
    moreStyle: moreStyle,
    lessStyle: lessStyle,
    trimMode: TrimMode.Line,
  );
}

Widget customElevatedButton( {
  String? label,
  double? fontSize,
  Color? backgroundColor,
  RoundedRectangleBorder? shape,
  Color? textColor,
  FontWeight? fontWeight,
  void Function()? onPressed,
} ) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: shape,
    ),
    child: Text(
      label!, style: textStyleWidget(fontSize, textColor, fontWeight),
    ),
  );
}

Widget customOutlinedButton(
{
  String? label,
  double? fontSize,
  Color? backgroundColor,
  RoundedRectangleBorder? shape,
  Color? textColor,
  FontWeight? fontWeight,
  void Function()? onPressed,
}
    ) {
  return OutlinedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: shape,
    ),
    child: Text(
      label!, style: textStyleWidget(fontSize, textColor, fontWeight),
    ),
  );
}

Widget customElevatedButtonIcon(
    String label,
    double? fontSize,
    Color? backgroundColor,
    RoundedRectangleBorder? shape,
    Color? textColor,
    FontWeight? fontWeight,
    IconData? icon,
    Color? iconColor,
    double? iconSize,
    void Function() onPressed,
    ) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: shape,
    ),
    icon: Icon(icon,color: iconColor, size: iconSize,),
    label:  Text(
      label, style: textStyleWidget(fontSize, textColor, fontWeight),
    ),
  );
}


Widget dateTimeElevatedButtonWidget(
    BuildContext context,
    double? width,
    double? height,
    IconData? iconData,
    double? fontSize,
    Color? textColor,
    FontWeight? fontWeight,
    Color? backgroundColor,
    RoundedRectangleBorder shape,
    void Function() onPressed,
    String? text,
    ){
  return Container(
    width: width,
    child: Material(
      color: AppColors.whiteColor,
      shape: shape,
      elevation: 3,
      child: Container(
        height: height,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
             shape: shape
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text!,
                style:  TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  color: textColor
                ),
              ),
               Icon(iconData, color: Colors.white),
            ],
          ),
        ),
      ),
    ),
  );
}
 Widget circularProgressIndicator(
     double? height,
     double? width,
     Color? backgroundColor,
     BorderRadius? borderRadius,
     Color? loadingColor,
     ) {
   return Container(
     height: height,
     width: width,
     decoration: BoxDecoration(
       borderRadius: borderRadius,
       color: backgroundColor
     ),
     child: Center(
       child: CircularProgressIndicator(color: loadingColor,),
     ),
   );
 }

 Widget rowDatePickerWidget(
     BuildContext context,
     Color? materialColor,
     double? height,
     RoundedRectangleBorder? shape,
     Color? backgroundColor,
     void Function() onPressed,
     String? text,
     Color? textColor,
     double? fontSize,
     FontWeight? fontWeight,
     IconData? iconData,
     double? iconSize,
     Color? iconColor,
     ){
  return Material(
    color: materialColor,
    shape: shape,
    elevation: 3,
    child: Container(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: shape,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textWidget(text, fontSize, textColor, fontWeight),
             Icon(iconData, color: iconColor,size: iconSize,),
          ],
        ),
      ),
    ),
  );
 }

Widget customDropdown({
  required BuildContext context,
  String? value,
  void Function(String?)? onChanged,
  List<DropdownMenuItem<String>>? items,
}) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.05,
    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width <= 900 ?  MediaQuery.of(context).size.width * 0.03 :18),
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor,
      border: Border.all(
        color: Theme.of(context).primaryColor,
        width: 1.0,
      ),
      // borderRadius: BorderRadius.circular(50),
    ),
    child: Theme(
      data: Theme.of(context).copyWith(
        canvasColor: isLightMode(context) ? AppColors.whiteColor : AppColors.blueSelectedColor,
      ),
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: items,
        style: const TextStyle(
          color: AppColors.whiteColor,
          fontWeight: FontWeight.bold,
        ),
        underline: Container(height: 0),
        isExpanded: true,
        iconEnabledColor: AppColors.whiteColor,
      ),
    ),
  );
}


Widget customOutLineDropdownWidget({
  required BuildContext context,
  double? dropDownHeight,
  double? dropDownWidth,
  Color? dropDownBorderColor,
  String? value,
  void Function(String?)? onChanged,
  List<DropdownMenuItem<String>>? items,
}) {
  return Container(
    height: dropDownHeight!,
    width: dropDownWidth!,
    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width <= 900 ?  MediaQuery.of(context).size.width * 0.03 :18),
    decoration: BoxDecoration(
      color: isLightMode(context) ? null : AppColors.blueSelectedColor,
      borderRadius: BorderRadius.circular(3),
      border: Border.all(
        color: dropDownBorderColor!,
        width: 1.0,
      ),
    ),
    child: Theme(
      data: Theme.of(context).copyWith(
        canvasColor:  isLightMode(context) ? AppColors.whiteColor : AppColors.blueSelectedColor,
      ),
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: items,
        style:  TextStyle(
          color: isLightMode(context) ? AppColors.blackColor : AppColors.whiteColor,
          fontWeight: FontWeight.bold,
        ),
        underline: Container(height: 0),
        isExpanded: true,
        iconEnabledColor: isLightMode(context) ? AppColors.blackColor : AppColors.whiteColor,
      ),
    ),
  );
}



Widget rowModuleWidget(
    BuildContext context,
    String? leftTextTitle,
    String? leftTextSubtitle,
    String? rightTextTitle,
    String? rightTextSubtitle,
    Color? color
    ){
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textWidget(
            leftTextTitle,
            MediaQuery.of(context).size.width <= 900 ? MediaQuery.of(context).size.width * 0.04 : 13,
            null,
            FontWeight.bold,
          ),
          textWidget(
            rightTextTitle,
            MediaQuery.of(context).size.width <= 900 ? MediaQuery.of(context).size.width * 0.04 : 13,
            null,
            FontWeight.bold,
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textWidget(
            leftTextSubtitle,
            MediaQuery.of(context).size.width <= 900 ? MediaQuery.of(context).size.width * 0.04 : 13,
            color,
            FontWeight.bold,
          ),
          textWidget(
            rightTextSubtitle,
            MediaQuery.of(context).size.width <= 900 ? MediaQuery.of(context).size.width * 0.04 : 13,
            color,
            FontWeight.bold,
          )
        ],
      ),
    ],
  );
}



Widget labelWidget(
     double? width,
     EdgeInsetsGeometry? padding,
     Decoration? decoration,
     String? title,
     double? fontSize,
     Color? color,
     FontWeight? fontWeight
     ){
  return  Container(
    width: width,
    padding: padding,
    decoration: decoration,
    child: Center(
      child: textWidget(
        title,
        fontSize,
        color,
        fontWeight,
      ),
    ),
  );
 }

 Widget customOutlineButton(
     RoundedRectangleBorder shape,
     Color? bgColor,
     String? label,
     double? fontSize,
     Color? color,
     FontWeight? fontWeight,

     String? trimCollapsedText,
     String? trimExpandedText,
     int? trimLines,
     TextStyle? moreStyle,
     TextStyle? lessStyle,
     ){
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
        shape: shape,
      backgroundColor: bgColor,
    ),
    onPressed: () {},
    child:  ReadMoreText(
      label!,
      trimCollapsedText: trimCollapsedText!,
      trimExpandedText: trimExpandedText!,
      trimLines: trimLines!,
      style: TextStyle(
        fontFamily: "Poppins",
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
      moreStyle: moreStyle,
      lessStyle: lessStyle,
      trimMode: TrimMode.Line,
    )
  );
 }

Widget customElevatedRedMoreButton(
    RoundedRectangleBorder shape,
    Color? bgColor,
    String? label,
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,

    String? trimCollapsedText,
    String? trimExpandedText,
    int? trimLines,
    TextStyle? moreStyle,
    TextStyle? lessStyle,
    ){
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: shape,
        backgroundColor: bgColor,
      ),
      onPressed: () {},
      child:  ReadMoreText(
        label!,
        trimCollapsedText: trimCollapsedText!,
        trimExpandedText: trimExpandedText!,
        trimLines: trimLines!,
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
        moreStyle: moreStyle,
        lessStyle: lessStyle,
        trimMode: TrimMode.Line,
      )
  );
}

 Widget customToolTipWidget(
     Color? tooltipBgColor,
     String? message,
     EdgeInsetsGeometry? padding,
     int? duration,
     double? fontSize,
     Color? textColor,
     FontWeight? fontWeight,
     bool? preferBelow,
     double? verticalOffset,
     Widget? child,
     ){
  return Tooltip(
    child: child!,
    message: message,
    padding: padding,
    showDuration:  Duration(seconds: duration!),
    decoration: ShapeDecoration(
      color: tooltipBgColor,
      shape: ToolTipCustomShape(),
    ),
    textStyle: TextStyle(
      fontFamily: "Poppins",
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
    ),
    preferBelow: preferBelow,
    verticalOffset: verticalOffset ,
  );
 }

 Widget textButtonWithTextSpan({
  String? leftTitle,
  String? rightTitle,
  double? fontSize,
  Color? leftTextColor,
  Color? rightTextColor,
  FontWeight? leftFontWeight,
  FontWeight?  rightFontWeight,
  void Function()? onButtonPressed
}
     ){
  return TextButton(
    onPressed: onButtonPressed,
    child: RichText(
        text:TextSpan(
            children: [
              TextSpan(
                  text: leftTitle,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: leftFontWeight,
                      color: leftTextColor,
                    fontFamily: "Poppins"
                  )
              ),
              TextSpan(
                  text: rightTitle,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: rightTextColor,
                    fontWeight: rightFontWeight,
                  )
              ),
            ]
        )
    ),
  );
 }

Widget customShowCaseWidget(
    BuildContext context,
    GlobalKey key,
     String title,
     String description,
    TextAlign? titleTextAlign,
    TextAlign? descriptionTextAlign,
    Color? tooltipBackgroundColor,
    Color? textColor,
    BorderRadius? targetBorderRadius,
    EdgeInsets? targetPadding,
    EdgeInsets? tooltipPadding,
    Color? overlayColor,
    double? overlayOpacity,
    Widget child,
    ) {
  return Showcase(
    titleAlignment: titleTextAlign!,
    descriptionAlignment: descriptionTextAlign!,
    tooltipBackgroundColor: tooltipBackgroundColor!,
    textColor: textColor!,
    targetBorderRadius: targetBorderRadius,
    targetPadding: targetPadding!,
    tooltipPadding: tooltipPadding!,
    overlayColor: overlayColor!,
    overlayOpacity: overlayOpacity!,
    key: key,
    title:title,
    description: description,
    child: child,
  );
}




Widget loadingWidget(double radius, Color? color) {
  return Center(
    child: CupertinoActivityIndicator(
      radius: radius,
      color: color,
    ),
  );
}



Widget lottieLoadingWidget(double? height){
  return  Center(
      child: Lottie.asset(
        'assets/animations/loading.json',
        height: height,
        repeat: true,
        reverse: true,
        animate: true,
      ));
}

Widget chipWidget(
    BuildContext context,
    void Function() onTap,
    String label,
    BorderSide? borderSide,
    double? chipVerticalPadding,
    double? chipHorizontalPadding,
    ){
  return  GestureDetector(
    onTap: onTap,
    child: Material(
        color: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: borderSide!
        ),
        elevation: 1,
        child: Padding(
          padding:  EdgeInsets.symmetric(
            vertical: chipVerticalPadding!,
            horizontal: chipHorizontalPadding!,
          ),
          child: textWidget(label, null, null, FontWeight.normal)
        )
    ),
  );
}
Widget profileAvatarWidget({
  String? imageUrl,
  void Function()? onEditPressed,
}) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      CircleAvatar(
        radius: 42,
        child: CircleAvatar(
          radius: 40,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: imageUrl ?? '',
              fit: BoxFit.fill,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => Image.asset(AppString.logoImg),
            ),
          ),
        ),
      ),
      // Positioned(
      //   right: -5,
      //   bottom: 3,
      //   child: CircleAvatar(
      //     radius: 14,
      //     child: CircleAvatar(
      //       radius: 13,
      //       backgroundColor: Colors.white,
      //       child:  GestureDetector(
      //           onTap: onEditPressed,
      //           child: Icon(Icons.edit_outlined, size: 15)),
      //     ),
      //   ),
      // ),
    ],
  );
}

Widget buildRow(String firstTitle, String firstValue, String secondTitle , String secondValue, double screenWidth) {
  return  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(firstTitle, screenWidth * 0.048, null, FontWeight.bold),
          textWidget(firstValue, screenWidth * 0.045, AppColors.greyColor, FontWeight.bold),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          textWidget(secondTitle, screenWidth * 0.048, null, FontWeight.bold),
          textWidget(secondValue, screenWidth * 0.045, AppColors.greyColor, FontWeight.bold),
        ],
      ),
    ],
  );
}

Widget loadingWidgetMaker() {
  return Center(
      child: Lottie.asset(
        'assets/animations/loading.json',
        height: 100,
        repeat: true,
        reverse: true,
        animate: true,
      ));
}