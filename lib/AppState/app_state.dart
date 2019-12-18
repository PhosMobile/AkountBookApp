import 'package:akaunt/Models/Expense.dart';
import 'package:akaunt/Models/discount.dart';
import 'package:akaunt/Models/edit_invoice.dart';
import 'package:akaunt/Models/invoice_name.dart';
import 'package:akaunt/Models/user.dart';
import 'package:akaunt/Models/business.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Models/invoice.dart';
import 'package:akaunt/Models/item.dart';
import 'package:akaunt/Models/payment.dart';
import 'package:akaunt/Models/receipt.dart';
import 'package:akaunt/Models/user_phone_contact.dart';
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
  List<UserPhoneContact> userContacts = [];

  InvoiceName invoiceName;
  List<Item> invoiceItems = [];
  List<Discount> invoiceDiscount = [];
  Customer invoiceCustomer;
  Invoice readyInvoice;
  Receipt invoiceReceipt;
  EditInvoice editInvoice;

  UserPhoneContact customerFromContact;

}
