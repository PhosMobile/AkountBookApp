import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AttachImage {
  Future getProfileImage() async {
    var _image = ImagePicker.pickImage(source: ImageSource.gallery);
    return _image;
  }
}
