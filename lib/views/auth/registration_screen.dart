import 'package:fl_chat/constants/images.dart';
import 'package:fl_chat/constants/text_field_decoration.dart';
import 'package:fl_chat/view_model/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../constants/button.dart';
import '../../constants/colors.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    final signUpProvider = Provider.of<AuthModelProvider>(context);
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
                  keyboardType: TextInputType.emailAddress,
                  controller: signUpProvider.usernameController,
                  decoration: kTextFeildDecoration.copyWith(
                    hintText: 'Enter your name',
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
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  controller: signUpProvider.emailController,
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
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  controller: signUpProvider.passwordController,
                  decoration: kTextFeildDecoration.copyWith(
                    hintText: 'Enter your password',
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
                  style: const TextStyle(color: Colors.white),
                  obscureText: false,
                  controller: signUpProvider.bioController,
                  decoration: kTextFeildDecoration.copyWith(
                    hintText: 'Enter your bio',
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                colour: Colors.blueAccent,
                title: 'Register',
                onPressed: () async {
                  signUpProvider.signUpUsers(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
