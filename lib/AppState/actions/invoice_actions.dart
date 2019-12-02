import 'package:akount_books/Models/edit_invoice.dart';
import 'package:akount_books/Models/invoice.dart';
import 'package:akount_books/Models/invoice_name.dart';
import 'package:flutter/material.dart';

class FetchUserInvoice {
  final List<Invoice> payload;

  FetchUserInvoice({@required this.payload});
}

class AddNameInvoice {
  final InvoiceName payload;
  AddNameInvoice({@required this.payload});
}

class EditNameInvoice {
  final InvoiceName payload;
  EditNameInvoice({@required this.payload});
}


class AddBusinessInvoice {
  final Invoice payload;
  AddBusinessInvoice({@required this.payload});
}

class CreateInvoice {
  final Invoice payload;
  CreateInvoice({@required this.payload});
}

class UpdateInvoice {
  final Invoice payload;
  UpdateInvoice({@required this.payload});
}

class DeleteInvoice {
  final Invoice payload;

  DeleteInvoice({@required this.payload});
}
class AddEditInvoice{
  final EditInvoice payload;
  AddEditInvoice({@required this.payload});
}

class UpdateBusinessInvoice{
final Invoice payload;
UpdateBusinessInvoice({@required this.payload});
}



