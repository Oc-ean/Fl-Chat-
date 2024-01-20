import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fl_chat/constants/button.dart';
import 'package:fl_chat/constants/colors.dart';
import 'package:fl_chat/constants/images.dart';
import 'package:fl_chat/views/auth/registration_screen.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    // animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
    animation =
        ColorTween(begin: Colors.grey, end: Colors.white).animate(controller);
    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller.reverse(from: 1.0);
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: animation.value,
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 60.0,
                    child: Image.asset(appLogo),
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: const ['Fl Chat'],
                  textStyle: const TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              title: 'Log In',
              colour: Colors.blueAccent,
            ),
            RoundedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RegistrationScreen()));
              },
              title: 'Register',
              colour: Colors.lightBlueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
