import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chat/constants/services/firebase_service.dart';
import 'package:fl_chat/models/message_model.dart';
import 'package:fl_chat/models/user_model.dart';
import 'package:fl_chat/views/chat/widgets/chat_bubble.dart';
import 'package:fl_chat/views/chat/widgets/chat_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'contact_info.dart';

class ChatScreen extends StatelessWidget {
  final UserModel userModel;
  final User? user;
  const ChatScreen({super.key, required this.userModel, this.user});

  @override
  Widget build(BuildContext context) {
    // List<Messages> list = [
    //   Messages(message: 'Hey man', isMe: true),
    //   Messages(message: 'What\'s up?', isMe: false),
    //   Messages(message: 'Nothing much actually', isMe: true),
    //   Messages(message: 'Alright', isMe: false),
    //   Messages(message: 'How are you doing?', isMe: true),
    //   Messages(message: 'I\'m okay ', isMe: false),
    //   Messages(message: 'Okay , can you be my mentor? ', isMe: true),
    // ];
    List<MessageModel> _list = [];
    bool _showEmoji = false;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leadingWidth: 33,
          backgroundColor: const Color(0xFF1f1f1f),
          elevation: 0.0,
          title: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => const ContactInfo(),
                  ));
            },
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: userModel.image.isEmpty ? Colors.blue : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: userModel.image.isEmpty
                      ? Center(
                          child: Text(
                            userModel.name.toString().substring(0, 1),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17),
                          ),
                        )
                      : ClipOval(
                          child: Image.network(
                            userModel.image,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userModel.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white54,
                      ),
                    ),
                    const Text(
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
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                // ? ListView.builder(
                //     clipBehavior: Clip.none,
                //     itemCount: list.length,
                //     itemBuilder: (context, index) {
                //       final data = list[index];
                //       return ChatBubble(
                //         message: data.message,
                //         sender: '',
                //         isMe: data.isMe,
                //       );
                //     },
                //   )
                // : SizedBox(
                //     height: MediaQuery.of(context).size.height / 2,
                //     width: 400,
                //     child: const Center(
                //       child: Text(
                //         'Send a message ',
                //         style: TextStyle(
                //           fontSize: 20,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ),
                //   ),
                child: StreamBuilder(
                  stream: FirebaseService.getAllMessages(userModel),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData) {
                      final results = snapshot.data!.docs;
                      _list = results
                          .map((e) => MessageModel.fromJson(e.data()))
                          .toList();

                      log('Snapshot list ===> $_list');
                      log('Fire list ===> $results');
                      return _list.isNotEmpty
                          ? ListView.builder(
                              reverse: true,
                              clipBehavior: Clip.none,
                              itemCount: _list.length,
                              itemBuilder: (context, index) {
                                final currentUser =
                                    FirebaseAuth.instance.currentUser!;

                                bool isMe = results[index]['senderId'] ==
                                    currentUser.uid;

                                return ChatBubble(
                                  message: _list[index],
                                  isMe: isMe,
                                  dataTime: _list[index].sent,
                                );
                              },
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              width: 400,
                              child: const Center(
                                child: Text(
                                  'Send a message ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ChatTextField(
                user: userModel,
                showEmoji: _showEmoji,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Messages {
  String message;
  bool isMe;
  Messages({required this.message, required this.isMe});
}
