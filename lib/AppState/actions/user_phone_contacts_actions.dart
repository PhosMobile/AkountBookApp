import 'package:akaunt/Models/user_phone_contact.dart';
import 'package:flutter/material.dart';

class AddUserContacts {
  final List<UserPhoneContact> payload;

  AddUserContacts({@required this.payload});
}

class AddCustomerFromContact {
  final UserPhoneContact payload;

  AddCustomerFromContact({@required this.payload});
}

