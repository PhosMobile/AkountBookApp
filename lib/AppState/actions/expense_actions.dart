import 'package:akaunt/Models/Expense.dart';
import 'package:flutter/material.dart';

class AddExpense {
  final List<Expense> payload;

  AddExpense({@required this.payload});
}

class CreateExpense {
  final Expense payload;
  CreateExpense({@required this.payload});
}

class DeleteExpense {
  final Expense payload;

  DeleteExpense({@required this.payload});
}



class EditExpense {
  final Expense payload;
  EditExpense({@required this.payload});
}
