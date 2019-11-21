import 'package:akount_books/Models/customer.dart';
import 'package:flutter/material.dart';

class AddCustomer {
  final List<Customer> payload;

  AddCustomer({@required this.payload});
}

class UpdateCustomer {
  final Customer payload;

  UpdateCustomer({@required this.payload});
}

class DeleteCustomer {
  final Customer payload;

  DeleteCustomer({@required this.payload});
}
