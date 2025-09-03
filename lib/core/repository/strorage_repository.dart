import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository {
  final FirebaseStorage _storage;

  StorageRepository(this._storage);

  Future<List<String>> postImages(List<File> images) async {
    List<String> imageUrls = [];

    try {
      for (File image in images) {
        String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        String extension = image.path.split('.').last;
        TaskSnapshot snapshot = await _storage
            .ref('posts/${timestamp}_.$extension')
            .putFile(image);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }
    } catch (e) {
      throw Exception('StorageRepository: Error uploading images: $e');
    }

    return imageUrls;
  }

  Future<String> uploadProfilePhoto(File image) async {
    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String extension = image.path.split('.').last;
      TaskSnapshot snapshot = await _storage
          .ref('profiles/${timestamp}_.$extension')
          .putFile(image);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('StorageRepository: Error uploading profile photo: $e');
    }
  }

  Future<void> deleteImages(List<String> imageUrls) async {
    try {
      for (String url in imageUrls) {
        final ref = _storage.refFromURL(url);
        await ref.delete();
      }
    } catch (e) {
      throw Exception('StorageRepository: Error deleting images: $e');
    }
  }
}
