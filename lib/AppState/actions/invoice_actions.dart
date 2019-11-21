import 'package:akount_books/Models/invoice.dart';
import 'package:flutter/material.dart';

class AddInvoice {
  final List<Invoice> payload;

  AddInvoice({@required this.payload});
}

class UpdateInvoice {
  final Invoice payload;

  UpdateInvoice({@required this.payload});
}

class DeleteInvoice {
  final Invoice payload;

  DeleteInvoice({@required this.payload});
}
