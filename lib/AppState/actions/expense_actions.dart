import 'package:akount_books/Models/Expense.dart';
import 'package:flutter/material.dart';

class AddExpense {
  final List<Expense> payload;

  AddExpense({@required this.payload});
}

class UpdateExpense {
  final Expense payload;

  UpdateExpense({@required this.payload});
}

class DeleteExpense {
  final Expense payload;

  DeleteExpense({@required this.payload});
}
