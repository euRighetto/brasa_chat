import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerHelper {

  static final _picker = ImagePicker();

  static Future<File?> pickFromGallery() async {

    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
    );

    if (picked == null) return null;

    return File(picked.path);
  }

}