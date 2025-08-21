import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StoragePostService {
  final FirebaseStorage _storage;

  StoragePostService() : _storage = FirebaseStorage.instance;

  Future<List<String>> uploadImages(List<File> images) async {
    List<String> imageUrls = [];

    try {
      for (File image in images) {
        TaskSnapshot snapshot = await _storage
            .ref('posts/${image.path.split('/').last}')
            .putFile(image);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }
    } catch (e) {
      throw Exception('StoragePostService: Error uploading images: $e');
    }

    return imageUrls;
  }
}
