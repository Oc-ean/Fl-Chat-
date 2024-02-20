import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fl_chat/constants/images.dart';
import 'package:fl_chat/constants/services/firebase_service.dart';
import 'package:fl_chat/models/message_model.dart';
import 'package:fl_chat/models/user_model.dart';
import 'package:fl_chat/view_model/providers/auth_provider.dart';
import 'package:fl_chat/view_model/providers/message_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatTextField extends StatefulWidget {
  final String? currentId;
  final String? friendId;
  final UserModel user;
  late bool showEmoji;
  late bool upLoading;

  ChatTextField(
      {super.key,
      this.currentId,
      this.friendId,
      required this.user,
      required this.showEmoji,
      required this.upLoading});

  @override
  _ChatTextFieldState createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final TextEditingController _controller = TextEditingController();
  // bool _showEmoji = false;
  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);
    final authProvider = Provider.of<AuthModelProvider>(context);

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
                  if (!widget.upLoading) {
                    showAttachmentDialog(messageProvider, authProvider);
                  }
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
                          onTap: () {
                            if (widget.showEmoji) {
                              setState(() {
                                widget.showEmoji = !widget.showEmoji;
                              });
                            }
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              widget.showEmoji = !widget.showEmoji;
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
                  } else {
                    print("Can't add ");
                  }
                },
              ),
            ],
          ),
        ),
        Visibility(
          visible: widget.showEmoji == true,
          child: SizedBox(
            height: 270,
            child: EmojiPicker(
              textEditingController: _controller,
              config: Config(
                columns: 8,
                emojiSizeMax: 26 * (Platform.isIOS ? 1.30 : 1.0),
                bgColor: const Color(0xFF1f1f1f),
                noRecents: const Text(
                  'No Recents',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ), // Needs to be const Widge
              ),
            ),
          ),
        )
      ],
    );
  }

  showAttachmentDialog(
      MessageProvider messageProvider, AuthModelProvider authProvider) {
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
                  () async {
                    if (authProvider.image == null) {
                      // Assuming `selectProfilePic` is an asynchronous method
                      await authProvider.selectProfilePic(ImageSource.camera);

                      if (authProvider.image != null) {
                        await FirebaseService.sendImageToChat(
                          userModel: widget.user,
                          image: authProvider.image,
                        );
                      } else {
                        // Handle the case where image selection was canceled or unsuccessful
                        print('Image selection canceled or failed.');
                      }
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                options(
                  CupertinoIcons.photo,
                  'Photo',
                  () async {
                    if (messageProvider.selectMoreImage != null ||
                        messageProvider.selectMoreImage!.isEmpty) {
                      await messageProvider.selectMultipleImage();
                      Navigator.pop(context);
                      // Assuming `selectProfilePic` is an asynchronous method
                      print(
                          'Select more Image ====> ${messageProvider.selectMoreImage}');
                      if (messageProvider.selectMoreImage != null &&
                          messageProvider.selectMoreImage!.isNotEmpty) {
                        for (var i in messageProvider.selectMoreImage!) {
                          setState(() => widget.upLoading = true);
                          await FirebaseService.sendImageToChat(
                            userModel: widget.user,
                            image: i,
                          );
                          setState(() => widget.upLoading = false);
                        }
                      } else {
                        // Handle the case where image selection was canceled or unsuccessful
                        print('Image selection canceled or failed.');
                      }
                    }
                  },
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
