import 'dart:ui';

import 'package:fl_chat/constants/images.dart';
import 'package:fl_chat/views/profile/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  static const id = 'nav_screen';

  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<Widget> page = [
    const ChatHomeScreen(),
    const Center(child: Text('Not yet implemented')),
    const ProfileScreen(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: Column(
          children: [Expanded(child: page[_currentIndex])],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(
              height: 52,
              margin: EdgeInsets.only(
                  left: width * 0.20, right: width * 0.20, bottom: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width / 0.04,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xFF222222).withOpacity(0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                    child: Image.asset(
                      messageIcon,
                      color: _currentIndex == 0
                          ? const Color(0xFF7C01F6)
                          : const Color(0xFF4D4C4E),
                      height: 27,
                      width: 27,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                    child: Icon(
                      CupertinoIcons.search,
                      color: _currentIndex == 1
                          ? const Color(0xFF7C01F6)
                          : const Color(0xFF4D4C4E),
                      size: 32,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _currentIndex = 2;
                      });
                    },
                    child: Icon(
                      Icons.person,
                      size: 32,
                      color: _currentIndex == 2
                          ? const Color(0xFF7C01F6)
                          : const Color(0xFF4D4C4E),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ImageString s.asset(
// 'images/settings.png',
// color: _currentIndex == 2
// ? const Color(0xFF7C01F6)
// : const Color(0xFF4D4C4E),
// ),
//
// Icon(Icons.person,
// color: _currentIndex == 1
// ? const Color(0xFF7C01F6)
//     : const Color(0xFF4D4C4E)),
