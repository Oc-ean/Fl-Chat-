import 'package:fl_chat/constants/images.dart';
import 'package:fl_chat/constants/services/firebase_service.dart';
import 'package:fl_chat/models/message_model.dart';
import 'package:fl_chat/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  final String? currentId;
  final String? friendId;
  final UserModel user;

  const ChatTextField(
      {super.key, this.currentId, this.friendId, required this.user});

  @override
  _ChatTextFieldState createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final TextEditingController _controller = TextEditingController();
  bool _showEmoji = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: const Color(0xFF1f1f1f),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  showAttachmentDialog();
                },
                icon: Image.asset(
                  attachmentIcon,
                  height: 26,
                  width: 26,
                  filterQuality: FilterQuality.high,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 125,
                decoration: BoxDecoration(
                  color: const Color(0xFF272626),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 173,
                        child: TextField(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          maxLines: 10,
                          minLines: 1,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              top: 0,
                              left: 7,
                            ),
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          controller: _controller,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _showEmoji = !_showEmoji;
                            });
                          },
                          icon: const Icon(
                            Icons.emoji_emotions,
                            size: 25,
                            color: Color(0xff7c01f6),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              InkWell(
                child: Image.asset(
                  sendIcon,
                  filterQuality: FilterQuality.high,
                  height: 26,
                  width: 26,
                ),
                onTap: () async {
                  if (_controller.text.isNotEmpty) {
                    FirebaseService.sendMessage(
                        widget.user, _controller.text, Type.text);
                    _controller.text = '';
                    // String message = _controller.text;
                    // _controller.clear();
                    // await FirebaseFirestore.instance
                    //     .collection('users')
                    //     .doc(widget.currentId)
                    //     .collection('messages')
                    //     .doc(widget.friendId)
                    //     .collection('chats')
                    //     .add({
                    //   "senderId": widget.currentId,
                    //   "receiverId": widget.friendId,
                    //   "message": message,
                    //   "type": "text",
                    //   "date": DateTime.now(),
                    // }).then((value) {
                    //   FirebaseFirestore.instance
                    //       .collection('users')
                    //       .doc(widget.currentId)
                    //       .collection('messages')
                    //       .doc(widget.friendId)
                    //       .set({'last_msg': message, "date": DateTime.now()});
                    // });
                    //
                    // await FirebaseFirestore.instance
                    //     .collection('users')
                    //     .doc(widget.friendId)
                    //     .collection('messages')
                    //     .doc(widget.currentId)
                    //     .collection("chats")
                    //     .add({
                    //   "senderId": widget.currentId,
                    //   "receiverId": widget.friendId,
                    //   "message": message,
                    //   "type": "text",
                    //   "date": DateTime.now(),
                    // }).then((value) {
                    //   FirebaseFirestore.instance
                    //       .collection('users')
                    //       .doc(widget.friendId)
                    //       .collection('messages')
                    //       .doc(widget.currentId)
                    //       .set({"last_msg": message, "date": DateTime.now()});
                    // });
                  } else {
                    print("Can't add ");
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  showAttachmentDialog() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return Container(
            height: 135,
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF17101b),
            ),
            child: Column(
              children: [
                options(
                  CupertinoIcons.camera,
                  'Camera',
                  () {},
                ),
                const SizedBox(
                  height: 20,
                ),
                options(
                  CupertinoIcons.photo,
                  'Photo',
                  () {},
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget options(IconData iconData, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.white,
            size: 25,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
