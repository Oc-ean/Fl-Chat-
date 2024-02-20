import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import '../../constants/pick_Image.dart';

class MessageProvider extends ChangeNotifier {
  // Uint8List? image;
  List<Uint8List>? selectMoreImage;

  // selectProfilePic([ImageSource? imageSource]) async {
  //   Uint8List? img = await pickImage(imageSource ?? ImageSource.gallery);
  //   image = img;
  //   selectMoreImage = null;
  //   notifyListeners();
  // }

  selectMultipleImage() async {
    try {
      List<List<int>> images = await pickImages();

      // Assuming image is List<List<int>>
      List<Uint8List> selectedImages =
          images.map((bytes) => Uint8List.fromList(bytes)).toList();
      print('Selected Images: $selectedImages');

      // Update selectMoreImage
      selectMoreImage = selectedImages;
    } catch (e) {
      print('Select More image error $e');
    }

    notifyListeners();
  }
}
