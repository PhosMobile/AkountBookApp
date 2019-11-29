import 'package:akount_books/Models/item.dart';
import 'package:flutter/material.dart';
class AddBusinessItem {
  final List<Item> payload;
  AddBusinessItem({@required this.payload});
}
class UpdateBusinessItems {
  final Item payload;
  UpdateBusinessItems({@required this.payload});
}
class DeleteBusinessItem {
  final Item payload;
  DeleteBusinessItem({@required this.payload});
}

class AddInvoiceItems{
  final List<Item> payload;
  AddInvoiceItems({@required this.payload});
}

