import 'dart:developer';

import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    log('Image Path ====> ${file.path} --- Type ${file.mimeType}');
    return await file.readAsBytes();
  } else {
    print('No image selected');
  }
}

Future<List<List<int>>> pickImages() async {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? files = await imagePicker.pickMultiImage(imageQuality: 70);

  if (files.isNotEmpty) {
    for (XFile file in files) {
      log('Image Path ====> ${file.path} --- Type ${file.mimeType}');
    }

    List<Future<List<int>>> imageBytesFutures =
        files.map((XFile file) => file.readAsBytes()).toList();

    return await Future.wait(imageBytesFutures);
  } else {
    print('No image selected');
    return [];
  }
}
