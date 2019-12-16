import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/Expense.dart';

class ExpenseReducers {
  updateEditedExpense(Expense expense, AppState state) {
    state.businessExpenses.forEach((exp) {
      if (expense.id == exp.id) {
        state.businessExpenses.remove(exp);
        state.businessExpenses.insert(0, expense);
      }
    });
  }
  deleteExpense(Expense expense, AppState state) {
    state.businessExpenses.removeWhere((item) => item.id == expense.id);
  }
}