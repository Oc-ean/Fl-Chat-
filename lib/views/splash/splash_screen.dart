import 'dart:async';

import 'package:fl_chat/constants/colors.dart';
import 'package:fl_chat/constants/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/providers/auth_provider.dart';
import '../auth/welcome_screen.dart';
import '../navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () async {
      final authModelProvider =
          Provider.of<AuthModelProvider>(context, listen: false);
      await authModelProvider.isLoggedIn();

      authModelProvider.isSignedIn
          ? Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (_) => const BottomNavBar()),
              (route) => false)
          : Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (_) => const WelcomeScreen(),
              ),
            );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authModelProvider =
        Provider.of<AuthModelProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: 'logo',
            child: TweenAnimationBuilder(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: value,
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                appLogo,
                height: 100,
                width: 100,
              ),
            ),
          ),
          // const Spacer(),

          const Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'CHAT WITH PEOPLE GLOBALLY 😉',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
