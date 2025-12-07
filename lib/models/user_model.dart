class UserModel {
  String? name;
  String? phone;
  String? email;
  String? uId;
  String? image;
  String? cover;
  String? bio;
  bool? isEmailVerified;

  UserModel(
      { this.email,
       this.phone,
       this.name,
       this.uId,
       this.image,
        this.cover,
       this.bio,
       this.isEmailVerified});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    isEmailVerified = json['isEmailVerified'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'uId': uId,
      'image' : image,
      'cover' : cover,
      'bio' : bio,
      'isEmailVerified': isEmailVerified,
    };
  }
}
