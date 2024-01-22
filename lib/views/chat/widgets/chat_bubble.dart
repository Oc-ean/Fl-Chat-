import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final String sender;
  final dynamic isMe;
  final dynamic dataTime;
  final dynamic onLongTap;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.sender,
      required this.isMe,
      this.dataTime,
      this.onLongTap});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    final time = DateTime.now();

    return Column(
      children: [
        Container(
          margin: widget.isMe
              ? EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 3,
                  right: 15.0,
                  top: 10,
                )
              : EdgeInsets.only(
                  right: MediaQuery.of(context).size.width / 3,
                  left: 15.0,
                  top: 10),
          alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.isMe
                  ? const Color(0xFFa54ffc)
                  : const Color(0xFF1f1f1f),
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: widget.isMe
                      ? const Radius.circular(0.0)
                      : const Radius.circular(20.0),
                  topRight: widget.isMe
                      ? const Radius.circular(20.0)
                      : const Radius.circular(0.0),
                  bottomLeft: const Radius.circular(20.0),
                  bottomRight: const Radius.circular(20.0),
                ),
              ),
            ),
            onPressed: () {},
            onLongPress: widget.onLongTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 140,
                  child: Text(
                    widget.message,
                    maxLines: 50,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Text(
//   DateFormat("jm").format(DateTime.parse(widget.dataTime)),
//   textAlign: TextAlign.start,
//   style: const TextStyle(color: Colors.grey),
// )
