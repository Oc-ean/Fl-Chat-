import 'package:fl_chat/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';

class ChatTile extends StatelessWidget {
  final UserModel user;
  const ChatTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 89,
      width: 326,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: cardColor,
        boxShadow: const [
          BoxShadow(
            blurRadius: 1,
            spreadRadius: 1,
          )
        ],
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.only(left: 8, top: 10, right: 15),
        leading: Container(
          height: 55,
          width: 55,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          child: user.image.isEmpty
              ? Center(
                  child: Text(
                    user.name.toString().substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                )
              : ClipOval(
                  child: Image.network(
                    user.image,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            user.name,
            style: const TextStyle(
              color: Color(0xFFC8C8C8),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        subtitle: Text(
          user.about,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          maxLines: 1,
        ),
        trailing: const Text(
          '13:06pm',
          style: TextStyle(color: Color(0xFF7C01F6)),
        ),
      ),
    );
  }
}
