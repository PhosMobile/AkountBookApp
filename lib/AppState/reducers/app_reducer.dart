import 'package:akount_books/AppState/actions/business_actions.dart';
import 'package:akount_books/AppState/actions/customer_actions.dart';
import 'package:akount_books/AppState/actions/expense_actions.dart';
import 'package:akount_books/AppState/actions/invoice_actions.dart';
import 'package:akount_books/AppState/actions/item_actions.dart';
import 'package:akount_books/AppState/actions/user_actions.dart';
import 'package:akount_books/AppState/app_state.dart';

AppState appReducer(AppState prevState, dynamic action) {
  AppState newAppState = prevState;
  if (action is AddUser) {
    newAppState.loggedInUser = action.payload;
  } else if (action is SaveUserBusinesses) {
    newAppState.userBusinesses = action.payload;
  } else if (action is UserCurrentBusiness) {
    newAppState.currentBusiness = action.payload;
  } else if (action is FetchUserInvoice) {
    newAppState.businessInvoices = action.payload;
  } else if (action is AddCustomer) {
    newAppState.businessCustomers = action.payload;
  } else if (action is AddExpense) {
    newAppState.businessExpenses = action.payload;
  } else if (action is AddBusinessItem) {
    newAppState.businessItems = action.payload;
  }else if(action is AddInvoiceCustomer){
    newAppState.invoiceCustomer = action.payload;
  }
  else if (action is AddInvoice) {
    newAppState.invoiceName = action.payload;
  }

  return newAppState;
}
