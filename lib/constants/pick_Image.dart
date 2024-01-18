import 'dart:developer';

import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? file = await _imagePicker.pickImage(source: source);
  if (file != null) {
    log('Image Path ====> ${file.path} --- Type ${file.mimeType}');
    return await file.readAsBytes();
  } else {
    print('No image selected');
  }
}
