import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chat/constants/colors.dart';
import 'package:fl_chat/constants/services/firebase_service.dart';
import 'package:fl_chat/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/message_model.dart';

class ChatTile extends StatefulWidget {
  final UserModel user;
  const ChatTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  MessageModel? messageModel;
  int unreadMessageCount = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseService.getLastMessage(widget.user),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Container();
        }
        final results = snapshot.data!.docs;
        final list =
            results.map((e) => MessageModel.fromJson(e.data())).toList();
        if (list.isNotEmpty) messageModel = list[0];

        return StreamBuilder(
          stream: FirebaseService.getUnreadMessageCountStream(widget.user),
          builder: (BuildContext context, AsyncSnapshot<int> unreadSnapshot) {
            if (!unreadSnapshot.hasData) {
              return Container();
            }

            unreadMessageCount = unreadSnapshot.data!;
            print('Unread message count ====> ${unreadMessageCount}');

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
                contentPadding:
                    const EdgeInsets.only(left: 8, top: 10, right: 15),
                leading: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.user.image.isEmpty
                          ? Colors.blue
                          : Colors.grey),
                  child: widget.user.image.isEmpty
                      ? Center(
                          child: Text(
                            widget.user.name
                                .toString()
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : ClipOval(
                          child: Image.network(
                            widget.user.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Text(
                    widget.user.name,
                    style: const TextStyle(
                      color: Color(0xFFC8C8C8),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                subtitle: Text(
                  messageModel != null
                      ? messageModel!.message
                      : widget.user.about,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatDateTime(messageModel!.sent),
                      style: const TextStyle(color: Color(0xFF7C01F6)),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Visibility(
                      visible: widget.user.id == messageModel!.senderId,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: const Color(0xFF7C01F6),
                        child: Center(
                          child: Text(
                            unreadMessageCount.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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

// class ChatTile extends StatefulWidget {
//   final UserModel user;
//   const ChatTile({
//     Key? key,
//     required this.user,
//   }) : super(key: key);
//
//   @override
//   State<ChatTile> createState() => _ChatTileState();
// }
//
// class _ChatTileState extends State<ChatTile> {
//   MessageModel? messageModel;
//   int unreadMessageCount = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseService.getLastMessage(widget.user),
//       builder: (BuildContext context,
//           AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//         if (!snapshot.hasData || snapshot.data == null) {
//           return Container();
//         }
//         final results = snapshot.data!.docs;
//         final list =
//             results.map((e) => MessageModel.fromJson(e.data())).toList();
//         if (list.isNotEmpty) messageModel = list[0];
//
//         return Container(
//           height: 89,
//           width: 326,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(22),
//             color: cardColor,
//             boxShadow: const [
//               BoxShadow(
//                 blurRadius: 1,
//                 spreadRadius: 1,
//               )
//             ],
//             border: Border.all(color: Colors.grey, width: 0.5),
//           ),
//           child: ListTile(
//             visualDensity: VisualDensity.compact,
//             contentPadding: const EdgeInsets.only(left: 8, top: 10, right: 15),
//             leading: Container(
//               height: 55,
//               width: 55,
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: widget.user.image.isEmpty ? Colors.blue : Colors.grey),
//               child: widget.user.image.isEmpty
//                   ? Center(
//                       child: Text(
//                         widget.user.name
//                             .toString()
//                             .substring(0, 1)
//                             .toUpperCase(),
//                         style: const TextStyle(
//                           fontSize: 25,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     )
//                   : ClipOval(
//                       child: Image.network(
//                         widget.user.image,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//             ),
//             title: Padding(
//               padding: const EdgeInsets.only(bottom: 7),
//               child: Text(
//                 widget.user.name,
//                 style: const TextStyle(
//                   color: Color(0xFFC8C8C8),
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ),
//             subtitle: Text(
//               messageModel != null ? messageModel!.message : widget.user.about,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//                 letterSpacing: 0.5,
//               ),
//               maxLines: 1,
//             ),
//             trailing: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   '13:06pm',
//                   style: TextStyle(color: Color(0xFF7C01F6)),
//                 ),
//                 const SizedBox(
//                   height: 6,
//                 ),
//                 CircleAvatar(
//                   radius: 8,
//                   backgroundColor: const Color(0xFF7C01F6),
//                   child: Center(
//                     child: Text(
//                       unreadMessageCount.toString(),
//                       style: const TextStyle(color: Colors.white, fontSize: 12),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
