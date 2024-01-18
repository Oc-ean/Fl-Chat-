import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.email,
    required this.pushToken,
  });
  String image;
  String about;
  String name;
  String createdAt;
  bool isOnline;
  String id;
  String lastActive;
  String email;
  String pushToken;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['isOnline'] = isOnline;
    data['id'] = id;
    data['lastActive'] = lastActive;
    data['email'] = email;
    data['pushToken'] = pushToken;
    return data;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      image: json['image'] ?? '',
      about: json['about'] ?? '',
      name: json['name'] ?? '',
      createdAt: json['createdAt'] ?? '',
      isOnline: json['isOnline'] ?? '',
      id: json['id'] ?? '',
      lastActive: json['lastActive'] ?? '',
      email: json['email'] ?? '',
      pushToken: json['pushToken'] ?? '',
    );
  }

  static UserModel fromSnap(DocumentSnapshot snapshot) {
    var documentSnapShot = snapshot.data() as Map<String, dynamic>;
    print('==========>$documentSnapShot<========');
    return UserModel(
      email: documentSnapShot['email'],
      id: documentSnapShot['id'],
      about: documentSnapShot['about'],
      name: documentSnapShot['name'],
      createdAt: documentSnapShot['createdAt'],
      lastActive: documentSnapShot['lastActive'],
      pushToken: documentSnapShot['pushToken'],
      image: documentSnapShot['image'],
      isOnline: documentSnapShot['isOnline'],
    );
  }
}
