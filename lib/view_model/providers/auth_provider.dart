import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/pick_Image.dart';
import '../../constants/services/firebase_service.dart';
import '../../constants/snackbar.dart';
import '../../constants/strings.dart';
import '../../models/user_model.dart';
import '../../views/auth/welcome_screen.dart';
import '../../views/navigation.dart';

class AuthModelProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseService _authService = FirebaseService();

  bool _searching = false;
  bool _isSignedIn = false;

  bool isLoading = false;
  Uint8List? image;

  Box<UserModel>? _userBox;
  UserModel? _user;

  UserModel? get getCUser => _user;
  bool get isSearching => _searching;
  bool get isSignedIn => _isSignedIn;

  void toggleSearch() {
    _searching = !_searching;
    notifyListeners();
  }

  Future<void> isLoggedIn() async {
    firebaseAuth.authStateChanges().listen((User? user) {
      // log("isLoggedIn $user");
      if (user == null) {
        _isSignedIn = false;
      } else {
        _isSignedIn = true;
      }
    });
    notifyListeners();
  }

  Future<void> updatingUserValue() async {
    log('updating');
    try {
      UserModel userModel = await _authService.getUserDetails();
      log('User model ====> $userModel<=====');
      _user = userModel;
      log('User model ====> $_user<=====');

      notifyListeners();
    } catch (e) {
      log('User authentication error<==========>$e<=========>');
    }
  }

  Future<void> signUpUsers(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    String res = await _authService.createUser(
        email: emailController.text,
        password: passwordController.text,
        userName: usernameController.text,
        bio: bioController.text);

    isLoading = false;
    notifyListeners();
    if (res != 'success') {
      showSnackBar(context, 'Sign-Up in process');
      await Future.delayed(
        const Duration(seconds: 2),
      );
      userOnlineStatus(true);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
          (route) => false);
      showSnackBar(context, res);
    }
    emailController.clear();
    passwordController.clear();
    bioController.clear();
    usernameController.clear();
    notifyListeners();
  }

  logInUser(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      if (emailController.text.isNotEmpty ||
          passwordController.text.isNotEmpty) {
        UserCredential userCredential =
            await firebaseAuth.signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim());
        log('Users credentials $userCredential');
        // for the showReusableDialog visit utils folder = > const.dart...
        showSnackBar(context, 'Sign-In in process');
        await Future.delayed(const Duration(seconds: 3));
        userOnlineStatus(true);
        showSnackBar(context, 'Sign-In successful');
        // for the navigation visit utils folder = > const.dart...
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
            (route) => false);
      } else {
        showSnackBar(
          context,
          'Please enter a valid email and password',
        );
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      showSnackBar(context, 'Email or password is invalid');
      print('Logging Error ====>${e.toString()}');

      log('Login user error ===> $e <===');
    }
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      await firebaseAuth.signOut();

      await Future.delayed(const Duration(seconds: 2));
      // FirebaseService.userActiveStatus;
      // for the navigation visit utils folder = > const.dart...
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (_) => const WelcomeScreen()),
          (route) => false);

      showSnackBar(context, 'Sign-Out successful');
      isLoading = false;
      notifyListeners();
    } catch (e) {
      log('Failed to sign out: $e');
    }
  }

  selectProfilePic([ImageSource? imageSource]) async {
    Uint8List? img = await pickImage(imageSource ?? ImageSource.gallery);
    image = img;
    notifyListeners();
  }

  Future<void> userOnlineStatus(bool status) async {
    try {
      if (_user != null) {
        await FirebaseService.userActiveStatus(status);
        _user!.isOnline = status;
        notifyListeners();
      }
    } catch (e) {
      log('Failed to update online status: $e');
    }
  }
}
