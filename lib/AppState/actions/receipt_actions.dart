import 'package:akount_books/Models/receipt.dart';
import 'package:flutter/material.dart';

class AddBusinessReceipt {
  final List<Receipt> payload;
  AddBusinessReceipt({@required this.payload});
}
class UpdateBusinessReceipt {
  final Receipt payload;
  UpdateBusinessReceipt({@required this.payload});
}
class UpdateInvoiceReceipts {
  final Receipt payload;
  UpdateInvoiceReceipts({@required this.payload});
}
class DeleteInvoiceReceipt {
final Receipt payload;
DeleteInvoiceReceipt({@required this.payload});
}