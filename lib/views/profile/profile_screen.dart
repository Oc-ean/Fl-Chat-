import 'dart:ui';

import 'package:fl_chat/constants/images.dart';
import 'package:fl_chat/view_model/providers/auth_provider.dart';
import 'package:fl_chat/view_model/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/services/auth_service.dart';
import '../../constants/snackbar.dart';
import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name = '';
  String bio = '';

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = Provider.of<AuthModelProvider>(context).getUser;
    final authProvider = Provider.of<AuthModelProvider>(context);
    final messageProvider = Provider.of<MessageProvider>(context);

    print('This image ======> ${userModel!.image}');
    return Scaffold(
      backgroundColor: bgColor,
      extendBody: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: bgColor,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21,
            color: Color(0xFF504F50),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 35,
                  ),
                  Stack(
                    children: [
                      // messageProvider.image == null
                      Center(
                        child: Container(
                          width: 150, // Set width as needed
                          height: 150, // Set height as needed
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.indigoAccent
                              // image: DecorationImage(
                              //   image: AssetImage('assets/your_image.png'), // Replace with your image asset
                              //   fit: BoxFit.cover,
                              // ),
                              ),
                          child: userModel.image.isEmpty &&
                                  messageProvider.image == null
                              ? Center(
                                  child: Text(
                                    userModel.name.toString().substring(0, 1),
                                    style: const TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  // height: MediaQuery.of(context).size.width - 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                  ),
                                  child: ClipOval(
                                    child: userModel.image.isNotEmpty
                                        ? Image.network(
                                            userModel.image,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.memory(
                                            messageProvider.image!,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                        ),
                      ),
                      // : Center(),
                      Positioned(
                        bottom: 1, // Adjust the bottom position as needed
                        left: MediaQuery.of(context).size.width / 2 - 0,
                        child: InkWell(
                          onTap: () {
                            selectPhotoSheet(messageProvider);
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.edit),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      userModel.email,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    initialValue: userModel.name,
                    style: const TextStyle(color: Colors.white),
                    onSaved: (val) {
                      name = val!;
                    },
                    // onSaved: (val) => '',
                    // validator: (val) =>
                    //     val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      hintText: 'eg. Happy Singh',
                      label: const Text(
                        'Name',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: userModel.about,
                    style: const TextStyle(color: Colors.white),
                    onSaved: (val) {
                      bio = val!;
                    },
                    // onSaved: (val) => '',
                    // validator: (val) =>
                    //     val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.info_outline, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      hintText: 'eg. Happy Singh',
                      label: const Text(
                        'About',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 20),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            _formKey.currentState!.save();
                            AuthService()
                                .updateProfile(
                                    name: name,
                                    about: bio,
                                    image: messageProvider.image!)
                                .then(
                                  (value) => showSnackBar(
                                      context,
                                      'Profile Updated Successful',
                                      Colors.green),
                                );
                          },
                          child: Container(
                            height: 37,
                            width: 139,
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
                                'UPDATE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        InkWell(
                          onTap: () {
                            authProvider.signOut(context);
                          },
                          child: Container(
                            height: 35,
                            width: 139,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.red,
                                  Colors.redAccent,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                                stops: [0.1, 0.9],
                              ),
                              color: const Color(0xFF7C01F6),
                            ),
                            child: const Center(
                              child: Text(
                                'LOG OUT',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  selectPhotoSheet(MessageProvider messageProvider) {
    showDialog(
        context: context,
        builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 5.0),
                  child: Container(
                    height: 100,
                    // margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF17101b).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        sheetOptions(
                          imagePath: galleryIcon,
                          text: 'Gallery',
                          onTap: () {
                            messageProvider.selectProfilePic();
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: sheetOptions(
                            imagePath: cameraIcon,
                            text: 'Camera',
                            height: 47,
                            onTap: () {
                              messageProvider
                                  .selectProfilePic(ImageSource.camera);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  Widget sheetOptions(
      {required String imagePath,
      required String text,
      double? height,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            imagePath,
            height: height ?? 50,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
