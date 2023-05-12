import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/utils/app_messages.dart';

class FirebaseStorageService {
  final _firebaseStorage = FirebaseStorage.instance;
  final _customService = locator<CustomNavigationService>();

  Future<dynamic> uploadProfile(
      {required File file, required String userId}) async {
    try {
      var snapshot = await _firebaseStorage
          .ref()
          .child("images/${userId}_${file.path.split('/').last}")
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      _customService.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
      return (false);
    }
  }
}
