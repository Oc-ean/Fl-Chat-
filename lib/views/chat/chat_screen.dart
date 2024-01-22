import 'package:fl_chat/views/chat/widgets/chat_bubble.dart';
import 'package:fl_chat/views/chat/widgets/chat_text_field.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Messages> list = [
      Messages(message: 'Hey man', isMe: true),
      Messages(message: 'What\'s up?', isMe: false),
      Messages(message: 'Nothing much actually', isMe: true),
      Messages(message: 'Alright', isMe: false),
      Messages(message: 'How are you doing?', isMe: true),
      Messages(message: 'I\'m okay ', isMe: false),
    ];

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
        child: Column(
          children: [
            Expanded(
              child: list.isNotEmpty
                  ? ListView.builder(
                      clipBehavior: Clip.none,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final data = list[index];
                        return ChatBubble(
                          message: data.message,
                          sender: '',
                          isMe: data.isMe,
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
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
              // child: StreamBuilder(
              //   builder: (context,
              //       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
              //           snapshot) {
              //     if (snapshot.hasData) {
              //       final results = snapshot.data!.docs;
              //       // _list = results
              //       //     .map((e) => UserModel.fromJson(e.data()))
              //       //     .toList();
              //
              //       log('Snapshot list ===> $_list');
              //       log('Fire list ===> $results');
              //       return _list.isNotEmpty
              //           ? ListView.builder(
              //               itemBuilder: (context, index) {
              //                 return ChatBubble(
              //                     message: _list.toString(),
              //                     sender: '2',
              //                     isMe: _list);
              //               },
              //             )
              //           : SizedBox(
              //               height: MediaQuery.of(context).size.height / 2,
              //               width: 400,
              //               child: const Center(
              //                 child: Text(
              //                   'Send a message ',
              //                   style: TextStyle(
              //                     fontSize: 20,
              //                     color: Colors.white,
              //                   ),
              //                 ),
              //               ),
              //             );
              //     } else if (snapshot.hasError) {
              //       return Text('Error: ${snapshot.error}');
              //     } else {
              //       return const Center(child: CircularProgressIndicator());
              //     }
              //   },
              //   stream: null,
              // ),
            ),
            const SizedBox(
              height: 30,
            ),
            const ChatTextField(),
          ],
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
