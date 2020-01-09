import 'dart:io';

import 'package:akaunt/Widgets/loading_snack_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class UploadFile {
  uploadProfileImage(_scaffoldKey, context, image) async {
    if (image == null) {
      return null;
    } else {
      String fileName = p.basename(image.path);
      var dateNow = DateTime.now().millisecondsSinceEpoch;
      final StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(dateNow.toString() + fileName);
      final StorageUploadTask task = firebaseStorageRef.putFile(image);

      if (task.isInProgress) {
        _scaffoldKey.currentState.showSnackBar(
          LoadingSnackBar().loaderHigh("Processing...", context),
        );
      }
      await task.onComplete;
      return firebaseStorageRef;
    }
  }


  uploadInvoice(File image) async {
    if (image == null) {
      return null;
    } else {
      String fileName = p.basename(image.path);
      var dateNow = DateTime.now().millisecondsSinceEpoch;
      final StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child(dateNow.toString() + fileName);
      final StorageUploadTask task = firebaseStorageRef.putFile(image);
      await task.onComplete;
      return firebaseStorageRef;
    }
  }


}
