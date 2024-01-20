import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chat/constants/services/storage_service.dart';

import '../../models/user_model.dart';

class AuthService {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  var user = auth.currentUser;

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
