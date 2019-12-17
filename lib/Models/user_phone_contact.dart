import 'dart:typed_data';

class UserPhoneContact {
  String displayName, otherName,email,phone;
  String address;
  Uint8List avatar;
  UserPhoneContact(this.displayName, this.otherName, this.email, this.phone, this.address, this.avatar);
}
