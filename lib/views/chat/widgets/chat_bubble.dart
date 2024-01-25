import 'package:fl_chat/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/services/firebase_service.dart';

class ChatBubble extends StatefulWidget {
  final MessageModel message;
  final dynamic isMe;
  final dynamic dataTime;
  final dynamic onLongTap;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.isMe,
      this.dataTime,
      this.onLongTap});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool isMessageRead = false;

  @override
  void initState() {
    super.initState();
    loadMessageReadStatus();
  }

  Future<void> loadMessageReadStatus() async {
    isMessageRead = await FirebaseService().readMessage(widget.message);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.message.read.isEmpty) {
      FirebaseService().readMessage(widget.message);
    }
    return Column(
      children: [
        widget.isMe
            ? Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    formatDateTime(widget.dataTime),
                    style: const TextStyle(
                      color: Color(0xFFa54ffc),
                      fontSize: 12,
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    formatDateTime(widget.dataTime),
                    style: const TextStyle(
                      color: Color(0xffbababa),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
        Container(
          margin: widget.isMe
              ? EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 3,
                  right: 15.0,
                  top: 4,
                )
              : EdgeInsets.only(
                  right: MediaQuery.of(context).size.width / 3,
                  left: 15.0,
                  top: 6),
          alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.isMe
                  ? const Color(0xFFa54ffc)
                  : const Color(0xFF1f1f1f),
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 3,
              ),
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        widget.message.message,
                        maxLines: 50,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 15,
                          color: widget.isMe
                              ? Colors.white
                              : const Color(0xffbababa),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (widget.message.read.isNotEmpty)
                      const Icon(
                        Icons.done_all,
                        size: 16,
                        color: Colors.blue,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
      ],
    );
  }

  String formatDateTime(String timestampString) {
    // Convert the timestamp to a DateTime object
    int timestamp = int.parse(timestampString);
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Formatting the DateTime object using intl package
    final formatter = DateFormat('jm');
    return formatter.format(dateTime);
  }
}

// Text(
//   DateFormat("jm").format(DateTime.parse(widget.dataTime)),
//   textAlign: TextAlign.start,
//   style: const TextStyle(color: Colors.grey),
// )
