import 'package:akount_books/Models/invoice.dart';
import 'package:akount_books/Models/invoice_name.dart';
import 'package:flutter/material.dart';

class FetchUserInvoice {
  final List<Invoice> payload;

  FetchUserInvoice({@required this.payload});
}

class AddInvoice {
  final InvoiceName payload;
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
