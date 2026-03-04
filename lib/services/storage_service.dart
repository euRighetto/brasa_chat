import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> uploadProfileImage(File file) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // caminho único por usuário
    final ref = _storage.ref().child("profile_images").child(uid);

    // sobrescreve automaticamente a foto antiga
    final uploadTask = await ref.putFile(
      file,
      SettableMetadata(
        contentType: "image/jpeg",
      ),
    );

    // retorna url pública da imagem
    return await uploadTask.ref.getDownloadURL();
  }
}