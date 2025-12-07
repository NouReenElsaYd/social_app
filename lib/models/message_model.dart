class MessageModel {
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? text;


  MessageModel({
    this.senderId,
    this.receiverId,
    this.dateTime,
    this.text,
  });

  // Convert Firebase JSON to Dart Object
  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    text = json['text'];
  }

  // Convert Dart Object to Firebase JSON
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'dateTime': dateTime,
      'text': text,
    };
  }
}
