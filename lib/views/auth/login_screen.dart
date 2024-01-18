import 'package:fl_chat/constants/images.dart';
import 'package:fl_chat/view_model/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../constants/button.dart';
import '../../constants/colors.dart';
import '../../constants/text_field_decoration.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  // void dispose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.dispose();
  // }
  //
  // void loginUser() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   String res = await AuthService().logInUsers(
  //       email: emailController.text, password: passwordController.text);
  //   if (res == 'successful') {
  //     showSnackBar(context, 'Log in successful');
  //     Navigator.pushNamedAndRemoveUntil(
  //         context, ChatHomeScreen.id, (route) => false);
  //
  //     emailController.clear();
  //     passwordController.clear();
  //   } else {
  //     showSnackBar(context, res);
  //   }
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  bool showSpinner = false;
  String? email;
  String? password;
  @override
  Widget build(BuildContext context) {
    final signInProvider = Provider.of<AuthModelProvider>(context);
    return Scaffold(
      backgroundColor: bgColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset(appLogo),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              SizedBox(
                height: 50,
                width: 290,
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: signInProvider.emailController,
                  decoration: kTextFeildDecoration.copyWith(
                    hintText: 'Enter your email',
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              SizedBox(
                height: 50,
                width: 290,
                child: TextField(
                  controller: signInProvider.passwordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: kTextFeildDecoration.copyWith(
                    hintText: 'Enter your password',
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                colour: Colors.lightBlueAccent,
                title: 'Log In',
                onPressed: () async {
                  signInProvider.logInUser(context);
                  // try {
                  //   final User = await _auth.signInWithEmailAndPassword(
                  //       email: email, password: password);
                  //   if (User != null) {
                  //     Navigator.pushNamed(context, ChatScreen.id);
                  //   }
                  //   setState(() {
                  //     showSpinner = false;
                  //   });
                  // } catch (e) {
                  //   print(e);
                  // }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
