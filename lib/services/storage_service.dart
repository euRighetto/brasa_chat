import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/constants/storage_paths.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> uploadProfileImage(File file) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Fixed path: profile_images/{uid}.jpg — overwrites previous image
    final path = '${StoragePaths.profileImages}/$uid.jpg';
    final ref = _storage.ref().child(path);

    final uploadTask = await ref.putFile(
      file,
      SettableMetadata(
        contentType: "image/jpeg",
      ),
    );

    return await uploadTask.ref.getDownloadURL();
  }
}