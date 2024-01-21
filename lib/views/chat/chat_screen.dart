import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leadingWidth: 33,
        backgroundColor: const Color(0xFF1f1f1f),
        elevation: 0.0,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Micheal',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white54,
                  ),
                ),
                Text(
                  'last seen : 4:50 pm',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF161616),
              Color(0xFF1e0f2b),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 0.7],
          ),
        ),
      ),
    );
  }
}
