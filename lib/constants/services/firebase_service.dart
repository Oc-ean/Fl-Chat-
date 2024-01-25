import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chat/constants/services/storage_service.dart';
import 'package:fl_chat/models/message_model.dart';

import '../../models/user_model.dart';

class FirebaseService {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  UserModel? userModel;

  /// crea ting user fucntion..
  Future<String> createUser({
    String? email,
    String? password,
    String? userName,
    String? bio,
  }) async {
    String res = 'Some error occurred';
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      if (email!.isNotEmpty ||
          password!.isNotEmpty ||
          userName!.isNotEmpty ||
          bio!.isNotEmpty) {
        UserCredential userCredential = await auth
            .createUserWithEmailAndPassword(email: email, password: password!);

        UserModel userModel = UserModel(
            image: '',
            about: bio!,
            name: userName!,
            createdAt: time,
            isOnline: false,
            id: userCredential.user!.uid,
            lastActive: time,
            email: email,
            pushToken: '');
        firestore.collection('users').doc(userCredential.user!.uid).set(
              userModel.toJson(),
            );
        res = 'Successful';
      }
    } on FirebaseAuthException catch (error) {
      res = error.toString();
    }
    return res;
  }

  /// login users
  Future<String> logInUsers(
      {required String email, required String password}) async {
    String res = 'Some error';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'successful';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<UserModel> getUserDetails() async {
    User currentUser = auth.currentUser!;
    DocumentSnapshot documentSnapshot =
        await firestore.collection('users').doc(currentUser.uid).get();
    print(documentSnapshot.toString());
    return UserModel.fromSnap(documentSnapshot);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages() {
    return firestore
        .collection('messages')
        // .where('id', isNotEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  Future<void> getSelfInfo() async {
    try {
      await firestore.collection('users').doc(user!.uid).get().then((user) {
        if (user.exists) {
          final existedUser = UserModel.fromJson(user.data()!);
        } else {
          createUser().then((value) => getSelfInfo());
        }
      });
    } catch (e) {
      print('Getting self info ====> $e');
    }
  }

  Future<String> updateProfile(
      {String? name, String? about, required Uint8List image}) async {
    String res = 'Some error occurred';
    try {
      User? currentUser = auth.currentUser;
      if (currentUser != null) {
        String photoUrl = await StorageService()
            .uploadingImageToStorage('profilePic', image, false);
        UserModel updatedUser = UserModel(
          image: photoUrl ?? '',
          about: about ?? '',
          name: name ?? '',
          createdAt: '',
          isOnline: false,
          id: currentUser.uid,
          lastActive: '',
          email: currentUser.email!,
          pushToken: '',
        );

        await firestore.collection('users').doc(currentUser.uid).update(
              updatedUser.toJson(),
            );

        res = 'Profile updated successfully';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  /// message service
  static String getConversationID(String otherUserID) {
    return user.uid.hashCode <= otherUserID.hashCode
        ? '${user.uid}_$otherUserID'
        : '${otherUserID}_${user.uid}';
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserModel userModel) {
    String conversationID = getConversationID(userModel.id);
    String collectionPath = 'chats/$conversationID/messages/';

    return firestore
        .collection(collectionPath)
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      UserModel userModel, String message, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final MessageModel chatMessage = MessageModel(
        receiverId: userModel.id,
        message: message,
        read: '',
        messageType: type,
        senderId: user.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(userModel.id)}/messages/');
    await ref.doc(time).set(chatMessage.toJson());
    // sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
  }

  Future<bool> readMessage(MessageModel messageModel) async {
    try {
      await firestore
          .collection(
              'chats/${getConversationID(messageModel.senderId)}/messages/')
          .doc(messageModel.sent)
          .update({
        "read": DateTime.now().millisecondsSinceEpoch.toString(),
      });
      return true;
      print("Message marked as read successfully");
    } catch (error) {
      print("Error marking message as read: $error");
      return false;
      // Handle the error as needed
    }
  }

  // static Stream<List<dynamic>> getLastMessage(UserModel userModel) {
  //   return firestore
  //       .collection('chats/${getConversationID(userModel.id)}/messages/')
  //       .orderBy('sent', descending: true)
  //       .snapshots()
  //       .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
  //     final List<dynamic> result = [];
  //     final List<MessageModel> messages = snapshot.docs
  //         .map((doc) => MessageModel.fromJson(doc.data()))
  //         .toList();
  //
  //     // Filter unread messages
  //     final List<MessageModel> unreadMessages = messages
  //         .where((message) => message.read == null || message.read.isEmpty)
  //         .toList();
  //
  //     print('Unread messages: ${unreadMessages.toString()}');
  //
  //     // Get the last message
  //     MessageModel? lastMessage;
  //     if (messages.isNotEmpty) {
  //       lastMessage = messages.first;
  //     }
  //
  //     // Add last message and unread message count to the result
  //     result.add(lastMessage);
  //     result.add(unreadMessages.length);
  //
  //     return result;
  //   });
  // }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      UserModel userModel) {
    return firestore
        .collection('chats/${getConversationID(userModel.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Stream<int> getUnreadMessageCountStream(UserModel userModel) {
    try {
      return firestore
          .collection('chats/${getConversationID(userModel.id)}/messages/')
          .where('read', isEqualTo: '')
          .snapshots()
          .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs.length;
      });
    } catch (error) {
      print("Error getting unread message count: $error");
      return Stream.value(0); // Handle the error as needed
    }
  }
}

class LastMessageWithTimestamp {
  final MessageModel message;
  final DateTime timestamp;

  LastMessageWithTimestamp({required this.message, required this.timestamp});
}
//
// Future<void> updateUserInfo() async {
//   try {
//     await firestore.collection('users').doc(user!.uid).update({
//       'name': userModel!.name,
//       'about': userModel!.about,
//     });
//   } catch (e) {
//     print('Updating profile error ====>$e');
//   }
// }
