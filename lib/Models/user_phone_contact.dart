import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';

class UserPhoneContact {
  String displayName, otherName,email,phone;
  String address;
  Uint8List avatar;
  UserPhoneContact(this.displayName, this.otherName, this.email, this.phone, this.address, this.avatar);
}
