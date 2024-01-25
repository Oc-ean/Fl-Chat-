import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  MessageModel({
    required this.receiverId,
    required this.message,
    required this.read,
    required this.messageType,
    required this.senderId,
    required this.sent,
  });

  late final String receiverId;
  late final String message;
  late final String read;
  late final String senderId;
  late final String sent;
  late final Type messageType;

  MessageModel.fromJson(Map<String, dynamic> json) {
    receiverId = json['receiverId'].toString();
    message = json['message'].toString();
    read = json['read'].toString();
    messageType = json['messageType'].toString() == Type.image.name
        ? Type.image
        : Type.text;
    senderId = json['senderId'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['receiverId'] = receiverId;
    data['message'] = message;
    data['read'] = read;
    data['messageType'] = messageType.name;
    data['senderId'] = senderId;
    data['sent'] = sent;
    return data;
  }

  static MessageModel fromSnap(DocumentSnapshot snapshot) {
    var documentSnapShot = snapshot.data() as Map<String, dynamic>;
    print('messages ==========>$documentSnapShot<========');
    return MessageModel(
      receiverId: documentSnapShot['receiverId'],
      message: documentSnapShot['message'],
      read: documentSnapShot['read'],
      messageType: documentSnapShot['messageType'],
      senderId: documentSnapShot['senderId'],
      sent: documentSnapShot['sent'],
    );
  }
}

enum Type { text, image }
