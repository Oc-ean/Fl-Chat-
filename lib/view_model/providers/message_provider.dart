import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/pick_Image.dart';

class MessageProvider extends ChangeNotifier {
  Uint8List? image;
  selectProfilePic([ImageSource? imageSource]) async {
    Uint8List? img = await pickImage(imageSource ?? ImageSource.gallery);
    image = img;
    notifyListeners();
  }
}
