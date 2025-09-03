import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

String getMessageFromErrorCode(String code) {
  switch (code) {
    case 'user-not-found':
      return 'User not found';
    case 'wrong-password':
      return 'Wrong password';
    case 'email-already-in-use':
      return 'Email already in use';
    case 'weak-password':
      return 'Weak password';
    case 'too-many-requests':
      return 'Too many requests';
    default:
      return 'Request failed';
  }
}

Future<List<File>> convertAssetEntityListToFileList(
  List<AssetEntity> assetEntities,
) async {
  List<File> fileList = [];
  for (AssetEntity assetEntity in assetEntities) {
    File? file = await assetEntity.file;
    fileList.add(file!);
  }
  return fileList;
}

Future<bool> checkAndRequestGalleryPermission() async {
  final PermissionState state = await PhotoManager.requestPermissionExtend();

  return state.isAuth;
}

Future<File?> imagePickerFromGallery() async {
  final ImagePicker picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

Future<File?> imagePickerFromCamera() async {
  final ImagePicker picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}
