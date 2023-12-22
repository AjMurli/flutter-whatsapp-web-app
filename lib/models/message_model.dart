class MessageModel{
  String uid;
  String text;
  String dateTime;
  MessageModel(
      this.uid,
      this.text,
      this.dateTime
  );

  Map<String, dynamic> toMap(){
    Map<String, dynamic> mapMessage = {
      "uid": uid,
      "text": text,
      "dateTime": dateTime,
    };
    return mapMessage;
  }

}