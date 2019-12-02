import 'package:akount_books/AppState/actions/business_actions.dart';
import 'package:akount_books/AppState/actions/customer_actions.dart';
import 'package:akount_books/AppState/actions/expense_actions.dart';
import 'package:akount_books/AppState/actions/invoice_actions.dart';
import 'package:akount_books/AppState/actions/item_actions.dart';
import 'package:akount_books/AppState/actions/user_actions.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/AppState/reducers/invoice_reducers.dart';
import 'package:akount_books/Models/invoice.dart';

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
  } else if (action is AddInvoiceCustomer) {
    newAppState.invoiceCustomer = action.payload;
  } else if (action is AddNameInvoice) {
    newAppState.invoiceName = action.payload;
  } else if (action is AddInvoiceItems) {
    newAppState.invoiceItems = action.payload;
  }else if (action is UpdateBusinessCustomers) {
    newAppState.businessCustomers.insert(0, action.payload);
  }else if (action is UpdateBusinessItems) {
    newAppState.businessItems.insert(0, action.payload);
  } else if (action is CreateInvoice) {
    newAppState.readyInvoice = action.payload;
  }else if (action is AddBusinessInvoice) {
    newAppState.businessInvoices.insert(0, action.payload);
  }else if (action is AddEditInvoice) {
    newAppState.editInvoice = action.payload;
  }else if (action is EditNameInvoice) {
    InvoiceReducers().updateEditInvoiceName(action.payload, newAppState);
  }
  else if (action is EditInvoiceCustomer) {
    InvoiceReducers().editInvoiceCustomer(action.payload, newAppState);
  }else if (action is EditInvoiceItems) {
    InvoiceReducers().editInvoiceItems(action.payload, newAppState);
  }
  else if (action is UpdateBusinessInvoice) {
    InvoiceReducers().updateBusinessInvoice(action.payload, newAppState);
  }
  return newAppState;
}




