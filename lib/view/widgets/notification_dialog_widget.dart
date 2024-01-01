import 'package:flutter/material.dart';
import 'package:notification_app_web/utils/app_string.dart';
import 'package:notification_app_web/utils/common_widgets.dart';

class NotificationDialogWidget extends StatefulWidget {
  final titleText,body;
  const NotificationDialogWidget({
    super.key,
    required this.titleText,
  required this.body,
  });

  @override
  State<NotificationDialogWidget> createState() => _NotificationDialogWidgetState();
}

class _NotificationDialogWidgetState extends State<NotificationDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titleText),
      actions: [
        OutlinedButton.icon(
          onPressed: (){
            Navigator.pop(context);
        }, label: Text("Close"),
        icon: Icon(Icons.close),
        ),
      ],
      content: widget.body.toString().contains(".jpg") ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          textWidget("Sent you an image", null, null, FontWeight.normal),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Image.network(
              widget.body.toString(),
              width: 160,
              height: 160,
            ),
          ),
        ],
      ):
      widget.body.toString().contains(".docx")
        || widget.body.toString().contains(".pptx")
        || widget.body.toString().contains(".xlsx")
        || widget.body.toString().contains(".pdf")
        || widget.body.toString().contains(".mp3")
        || widget.body.toString().contains(".mp4")
          ?
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textWidget("Sent you file", null, null, FontWeight.normal),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Image.network(
              AppString.fileImg,
              width: 160,
              height: 160,
            ),
          ),
        ],
      ) : Text(widget.body)
    );
  }
}
