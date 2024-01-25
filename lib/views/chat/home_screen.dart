import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chat/constants/services/firebase_service.dart';
import 'package:fl_chat/view_model/providers/auth_provider.dart';
import 'package:fl_chat/views/chat/widgets/chat_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import 'chat_screen.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  List<UserModel> _list = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    addData();

    FirebaseService().getSelfInfo();
    super.initState();
  }

  addData() async {
    AuthModelProvider userModel =
        Provider.of<AuthModelProvider>(context, listen: false);
    await userModel.updatingUserValue();
  }

  @override
  Widget build(BuildContext context) {
    // final auth = FirebaseAuth.instance.currentUser!.uid;
    // final authProvider = Provider.of<AuthModelProvider>(context, listen: false);
    UserModel? userModel = Provider.of<AuthModelProvider>(
      context,
    ).getUser;
    log('Testing  ===> ${userModel.toString()}');
    log('Printing');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(0xFF161616),
          title: const Text(
            'Messages',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Color(0xFF504F50),
            ),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 29,
                  width: 139,
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF7C01F6),
                        Color(0xFFC093ED),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      stops: [0.1, 0.9],
                    ),
                    color: const Color(0xFF7C01F6),
                  ),
                  child: const Center(
                    child: Row(
                      children: [
                        Text(
                          'Currently Active',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Center(
                          child: Text(
                            '🟢',
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    'No active users',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  height: 29,
                  width: 90,
                  margin: const EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF7C01F6),
                        Color(0xFFC093ED),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      stops: [0.1, 0.9],
                    ),
                    color: const Color(0xFF7C01F6),
                  ),
                  child: const Center(
                    child: Text(
                      'Recents',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                userModel == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : StreamBuilder(
                        stream: FirebaseService.getAllUsers(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasData) {
                            final results = snapshot.data!.docs;
                            _list = results
                                .map((e) => UserModel.fromJson(e.data()))
                                .toList();

                            log('Snapshot list ===> $_list');
                            log('Fire list ===> $results');

                            return _list.isNotEmpty
                                ? Expanded(
                                    child: SingleChildScrollView(
                                      child: ListView.separated(
                                        clipBehavior: Clip.none,
                                        padding: const EdgeInsets.only(top: 10),
                                        shrinkWrap: true,
                                        itemCount: _list.length,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (_) => ChatScreen(
                                                      userModel: _list[index],
                                                    ),
                                                  ));
                                            },
                                            child: ChatTile(
                                              user: _list[index],
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return const SizedBox(
                                            height: 10,
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    width: 400,
                                    child: const Center(
                                      child: Text(
                                        'No Connections Found',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
