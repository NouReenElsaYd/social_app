class CommentModel {
  String? uId;
  String? name;
  String? image;
  String? comment;
  String? dateTime;

  CommentModel({
    this.uId,
    this.name,
    this.image,
    this.comment,
    this.dateTime,
  });

  // Convert Firebase JSON to Dart Object
  CommentModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    image = json['image'];
    comment = json['comment'];
    dateTime = json['dateTime'];
  }

  // Convert Dart Object to Firebase JSON
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'image': image,
      'comment': comment,
      'dateTime': dateTime,
    };
  }
}
