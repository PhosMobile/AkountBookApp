import 'package:akount_books/Models/customer.dart';
import 'package:flutter/material.dart';

class AddCustomer {
  final List<Customer> payload;

  AddCustomer({@required this.payload});
}


class UpdateBusinessCustomers {
  final Customer payload;
  UpdateBusinessCustomers({@required this.payload});
}

class DeleteCustomer {
  final Customer payload;

  DeleteCustomer({@required this.payload});
}

class AddInvoiceCustomer {
  final Customer payload;

  AddInvoiceCustomer({@required this.payload});
}

class EditInvoiceCustomer {
  final Customer payload;

  EditInvoiceCustomer({@required this.payload});
}

class UpdateEditedCustomer {
  final Customer payload;

  UpdateEditedCustomer({@required this.payload});
}
