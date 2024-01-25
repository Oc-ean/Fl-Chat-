import 'package:flutter/material.dart';

class ContactInfo extends StatelessWidget {
  const ContactInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leadingWidth: 33,
        backgroundColor: const Color(0xFF1f1f1f),
        elevation: 0.0,
        title: const Text(
          'Contact Info',
          style: TextStyle(
            fontSize: 17,
          ),
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
