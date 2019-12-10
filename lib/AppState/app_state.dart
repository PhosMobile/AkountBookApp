import 'package:akount_books/Models/Expense.dart';
import 'package:akount_books/Models/discount.dart';
import 'package:akount_books/Models/edit_invoice.dart';
import 'package:akount_books/Models/invoice_name.dart';
import 'package:akount_books/Models/user.dart';
import 'package:akount_books/Models/business.dart';
import 'package:akount_books/Models/customer.dart';
import 'package:akount_books/Models/invoice.dart';
import 'package:akount_books/Models/item.dart';
import 'package:akount_books/Models/payment.dart';
import 'package:akount_books/Models/receipt.dart';
class AppState {
  User loggedInUser;
  List<Business> userBusinesses = [];
  Business currentBusiness;
  List<Customer> businessCustomers = [];
  List<Expense> businessExpenses = [];
  List<Item> businessItems = [];
  List<Payment> businessPayments = [];
  List<Receipt> businessReceipts = [];
  List<Invoice> businessInvoices = [];

  InvoiceName invoiceName;
  List<Item> invoiceItems = [];
  List<Discount> invoiceDiscount = [];
  Customer invoiceCustomer;
  Invoice readyInvoice;

  EditInvoice editInvoice;
}
